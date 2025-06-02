import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Message, MessageType } from './message.entity';
import { Conversation } from './conversation.entity';
import { User } from '../user/user.entity';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class ChatService {
  constructor(
    @InjectRepository(Message)
    private readonly messageRepository: Repository<Message>,
    @InjectRepository(Conversation)
    private readonly conversationRepository: Repository<Conversation>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async getOrCreateConversation(userOneId: string, userTwoId: string): Promise<Conversation> {
    const existingConversation = await this.conversationRepository.findOne({
      where: [
        { participantOneId: userOneId, participantTwoId: userTwoId },
        { participantOneId: userTwoId, participantTwoId: userOneId },
      ],
    });

    if (existingConversation) {
      return existingConversation;
    }

    const newConversation = this.conversationRepository.create({
      participantOneId: userOneId,
      participantTwoId: userTwoId,
    });

    return this.conversationRepository.save(newConversation);
  }

  async sendMessage(senderId: string, conversationId: number, content: string): Promise<Message> {
    console.log('SendMessage called with:', { senderId, conversationId, content }); // Add logging

    if (!senderId) {
      throw new Error('senderId is required');
    }

    if (!conversationId) {
      throw new Error('conversationId is required');
    }

    const conversation = await this.conversationRepository.findOne({ 
      where: { id: conversationId } 
    });

    if (!conversation) {
      throw new Error(`Conversation with id ${conversationId} not found`);
    }

    // Verify that the sender is part of the conversation
    if (conversation.participantOneId !== senderId && conversation.participantTwoId !== senderId) {
      throw new Error('Sender is not part of this conversation');
    }

    const receiverId = conversation.participantOneId === senderId 
      ? conversation.participantTwoId 
      : conversation.participantOneId;

    // Create the message with all required fields
    const message = new Message();
    message.senderId = senderId;
    message.receiverId = receiverId;
    message.conversationId = conversationId;
    message.type = MessageType.TEXT;
    message.content = content || '';
    message.isRead = false;

    try {
      // Save the message first
      const savedMessage = await this.messageRepository.save(message);

      // Update conversation
      conversation.lastMessagePreview = content ? content.substring(0, 50) : '';
      conversation.lastMessageTime = new Date();
      await this.conversationRepository.save(conversation);

      return savedMessage;
    } catch (error) {
      console.error('Error saving message:', error);
      throw error;
    }
  }

  async sendImageMessage(
    senderId: string, 
    conversationId: number, 
    imageBuffer: string,
    filename: string
  ): Promise<Message> {
    try {
      console.log('Received image data:', {
        dataLength: imageBuffer?.length,
        startsWith: imageBuffer?.substring(0, 50),
        filename
      });

      const conversation = await this.conversationRepository.findOne({ 
        where: { id: conversationId } 
      });

      if (!conversation) {
        throw new NotFoundException('Conversation not found');
      }

      // Create uploads directory if it doesn't exist
      const uploadsDir = path.join(process.cwd(), 'uploads');
      if (!fs.existsSync(uploadsDir)) {
        fs.mkdirSync(uploadsDir, { recursive: true });
      }

      let buffer: Buffer;
      
      // Validate and extract data from data URI
      if (!imageBuffer.startsWith('data:image/')) {
        throw new Error('Invalid image format: Data URI must start with "data:image/"');
      }

      const matches = imageBuffer.match(/^data:image\/([a-zA-Z]+);base64,(.+)$/);
      if (!matches || matches.length !== 3) {
        throw new Error('Invalid image data URI format');
      }

      const imageType = matches[1].toLowerCase();
      const base64Data = matches[2];

      // Validate image type
      if (!['jpeg', 'jpg', 'png', 'gif'].includes(imageType)) {
        throw new Error(`Unsupported image type: ${imageType}`);
      }

      try {
        buffer = Buffer.from(base64Data, 'base64');
      } catch (e) {
        console.error('Failed to decode base64:', e);
        throw new Error('Invalid base64 data');
      }

      if (!buffer || buffer.length === 0) {
        throw new Error('Empty image buffer');
      }

      if (buffer.length > 5 * 1024 * 1024) { // 5MB limit
        throw new Error('Image size exceeds 5MB limit');
      }

      console.log('Decoded buffer length:', buffer.length);
      
      // Generate unique filename with proper extension
      let ext = '';
      
      // Try to get extension from the original filename
      if (filename.includes('.')) {
        ext = filename.split('.').pop() || '';
      }
      
      // If no extension found, try to detect from the data URI
      if (!ext && imageBuffer.startsWith('data:image/')) {
        const mimeMatch = imageBuffer.match(/^data:image\/([a-zA-Z]+);/);
        if (mimeMatch && mimeMatch[1]) {
          ext = mimeMatch[1].toLowerCase();
          if (ext === 'jpeg') ext = 'jpg';
        }
      }
      
      // Default to jpg if still no extension
      if (!ext) {
        ext = 'jpg';
      }
      
      // Clean the base filename (remove extension if present)
      const baseFilename = filename.split('.')[0].replace(/[^a-zA-Z0-9-_]/g, '_');
      const uniqueFilename = `${Date.now()}-${baseFilename}.${ext}`;
      const filePath = path.join(uploadsDir, uniqueFilename);
      
      // Write file
      fs.writeFileSync(filePath, buffer);
      console.log('Image saved to:', filePath);

      const imageUrl = `/uploads/${uniqueFilename}`;

      const receiverId = conversation.participantOneId === senderId 
        ? conversation.participantTwoId 
        : conversation.participantOneId;

      const message = this.messageRepository.create({
        senderId,
        receiverId,
        type: MessageType.IMAGE,
        content: 'Image',
        imageUrl,
        conversationId,
      });

      // Update conversation
      conversation.lastMessagePreview = 'Image';
      conversation.lastMessageTime = new Date();
      await this.conversationRepository.save(conversation);

      const savedMessage = await this.messageRepository.save(message);
      
      return {
        ...savedMessage,
        type: MessageType.IMAGE,
        imageUrl: imageUrl
      };
    } catch (error) {
      console.error('Error saving image message:', error);
      throw error;
    }
  }

  async getMessages(conversationId: number): Promise<Message[]> {
    return this.messageRepository.find({
      where: { conversationId },
      order: { createdAt: 'ASC' },
    });
  }

  async getUserConversations(userId: string): Promise<any[]> {
    // Get the current user with their gym info
    const currentUser = await this.userRepository
      .createQueryBuilder('user')
      .leftJoinAndSelect('user.gym', 'userGym')
      .leftJoinAndSelect('user.managedGym', 'userManagedGym')
      .where('user.id = :userId', { userId: parseInt(userId) })
      .getOne();

    if (!currentUser) {
      throw new NotFoundException('User not found');
    }

    // 1. Fetch all conversations for the user
    const conversations = await this.conversationRepository.find({
      where: [
        { participantOneId: userId },
        { participantTwoId: userId },
      ],
      order: { lastMessageTime: 'DESC' },
    });

    // Return empty array if user has no conversations
    if (conversations.length === 0) {
      return [];
    }

    // 2. Collect all 'other' participant IDs
    const otherParticipantIds = conversations.map(conv =>
      conv.participantOneId === userId ? conv.participantTwoId : conv.participantOneId
    );

    // 3. Fetch all those users in one query (with gym and managedGym)
    const otherUsers = await this.userRepository.createQueryBuilder('user')
      .leftJoinAndSelect('user.gym', 'userGym')
      .leftJoinAndSelect('user.managedGym', 'userManagedGym')
      .where('user.id IN (:...ids)', { ids: otherParticipantIds.map(id => parseInt(id)) })
      .getMany();

    // 4. Map userId to user
    const otherUserMap = new Map<string, User>();
    for (const u of otherUsers) {
      otherUserMap.set(String(u.id), u);
    }

    // 5. Build the result
    const results: any[] = [];
    
    for (const conv of conversations) {
      const otherParticipantId = conv.participantOneId === userId ? conv.participantTwoId : conv.participantOneId;
      const otherUser = otherUserMap.get(String(otherParticipantId));
      
      // Count unread messages for this user in this conversation
      const unreadCount = await this.messageRepository.count({
        where: {
          conversationId: conv.id,
          receiverId: userId,
          isRead: false
        }
      });

      // DEBUG: Log the actual otherUser object to see its structure
      console.log('DEBUG otherUser:', otherUser);

      // Safely extract gym and managedGym IDs
      const otherUserGymId = otherUser ? ((otherUser.gym && otherUser.gym.id) || (otherUser as any).gym_id) : null;
      const otherUserManagedGymId = otherUser ? ((otherUser.managedGym && otherUser.managedGym.id) || (otherUser as any).managedGymId) : null;
      const currentUserGymId = (currentUser.gym && currentUser.gym.id) || (currentUser as any).gym_id;
      const currentUserManagedGymId = (currentUser.managedGym && currentUser.managedGym.id) || (currentUser as any).managedGymId;

      let shouldShowDetails = false;

      if (otherUser) {
        if (currentUser.role === 'coach') {
          shouldShowDetails =
            (currentUserManagedGymId && otherUserGymId && currentUserManagedGymId == otherUserGymId) ||
            (currentUserGymId && otherUserGymId && currentUserGymId == otherUserGymId);
        } else if (currentUser.role === 'client') {
          shouldShowDetails =
            (currentUserGymId && otherUserGymId && currentUserGymId == otherUserGymId) ||
            (currentUserGymId && otherUserManagedGymId && currentUserGymId == otherUserManagedGymId);
        } else if (currentUser.role === 'admin') {
          shouldShowDetails = true;
        }
      }

      const userInfo = shouldShowDetails && otherUser ? {
        id: otherUser.id,
        firstName: (otherUser as any).prenom || otherUser.firstName || '',
        lastName: (otherUser as any).nom || otherUser.lastName || '',
        photoUrl: otherUser.photoUrl || (otherUser as any).photo_url || null,
        role: otherUser.role,
        gymId: otherUserGymId || otherUserManagedGymId || null
      } : {
        id: parseInt(otherParticipantId),
        firstName: 'Unknown',
        lastName: 'User',
        photoUrl: null,
        role: null,
        gymId: null
      };

      results.push({
        ...conv,
        unreadCount: unreadCount, // Use the calculated unread count
        otherParticipant: userInfo
      });
    }
    
    return results;
  }

  // Mark all messages as read for a user in a conversation
  async markMessagesAsRead(conversationId: number, userId: string): Promise<void> {
    // Mark all unread messages as read for this user
    await this.messageRepository.update(
      { conversationId, receiverId: userId, isRead: false },
      { isRead: true }
    );
  }
}