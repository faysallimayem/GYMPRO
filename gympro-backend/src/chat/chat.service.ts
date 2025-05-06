import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Message, MessageType } from './message.entity';
import { Conversation } from './conversation.entity';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class ChatService {
  constructor(
    @InjectRepository(Message)
    private readonly messageRepository: Repository<Message>,
    @InjectRepository(Conversation)
    private readonly conversationRepository: Repository<Conversation>,
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
      conversation.unreadCount = (conversation.unreadCount || 0) + 1;
      await this.conversationRepository.save(conversation);

      return savedMessage;
    } catch (error) {
      console.error('Error saving message:', error);
      throw error;
    }
  }

  async sendImageMessage(senderId: string, conversationId: number, imageBuffer: Buffer, filename: string): Promise<Message> {
    const conversation = await this.conversationRepository.findOne({ where: { id: conversationId } });

    if (!conversation) {
      throw new NotFoundException('Conversation not found');
    }

    const uploadsDir = path.join(process.cwd(), 'uploads');
    if (!fs.existsSync(uploadsDir)) {
      fs.mkdirSync(uploadsDir, { recursive: true });
    }

    const uniqueFilename = `${Date.now()}-${filename}`;
    const filePath = path.join(uploadsDir, uniqueFilename);
    fs.writeFileSync(filePath, imageBuffer);

    const imageUrl = `/uploads/${uniqueFilename}`;

    const receiverId =
      conversation.participantOneId === senderId ? conversation.participantTwoId : conversation.participantOneId;

    const message = this.messageRepository.create({
      senderId,
      receiverId,
      type: MessageType.IMAGE,
      content: 'Image',
      imageUrl,
      conversationId,
    });

    conversation.lastMessagePreview = 'Image';
    conversation.lastMessageTime = new Date();
    conversation.unreadCount += 1;
    await this.conversationRepository.save(conversation);

    return this.messageRepository.save(message);
  }

  async getMessages(conversationId: number): Promise<Message[]> {
    return this.messageRepository.find({
      where: { conversationId },
      order: { createdAt: 'ASC' },
    });
  }

  async getUserConversations(userId: string): Promise<Conversation[]> {
    return this.conversationRepository.find({
      where: [
        { participantOneId: userId },
        { participantTwoId: userId },
      ],
      order: { lastMessageTime: 'DESC' },
    });
  }
}