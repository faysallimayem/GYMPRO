import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { ChatService } from './chat.service';

@WebSocketGateway({ cors: { origin: '*' } })
export class ChatGateway {
  @WebSocketServer()
  server: Server;

  constructor(private readonly chatService: ChatService) {}

  // Handle sending a text message
  @SubscribeMessage('sendMessage')
  async handleSendMessage(
    @MessageBody() data: any,
    @ConnectedSocket() client: Socket,
  ) {
    try {
      console.log('Received message data:', data);
      console.log('Client socket id:', client.id);
      console.log('Client rooms:', Array.from(client.rooms));

      const senderId = data.senderId;
      const conversationId = data.conversationId;
      const content = data.content || '';
      
      const room = `conversation-${conversationId}`;
      console.log('Broadcasting to room:', room);
      console.log('Clients in room:', this.server.sockets.adapter.rooms.get(room));

      if (!senderId || !conversationId) {
        throw new Error('senderId and conversationId are required');
      }

      const message = await this.chatService.sendMessage(
        String(senderId),
        Number(conversationId),
        String(content)
      );

      // Broadcast to the room
      this.server.to(room).emit('newMessage', {
        id: message.id,
        senderId: message.senderId,
        content: message.content,
        conversationId: message.conversationId,
        createdAt: message.createdAt
      });
      
      console.log('Message broadcasted:', message);
      return message;
    } catch (error) {
      console.error('Error sending message:', error);
      throw error;
    }
  }

  // Handle sending an image message
  @SubscribeMessage('sendImageMessage')
  async handleSendImageMessage(
    @MessageBody() data: { senderId: string; conversationId: number; imageBuffer: Buffer | string; filename: string },
    @ConnectedSocket() client: Socket,
  ) {
    // Convert Buffer to base64 Data URI string
    let imageDataUri: string;
    if (data.imageBuffer instanceof Buffer) {
      // Default to PNG if you don't know the type
      const mimeType = 'image/png';
      const base64 = data.imageBuffer.toString('base64');
      imageDataUri = `data:${mimeType};base64,${base64}`;
    } else if (typeof data.imageBuffer === 'string' && data.imageBuffer.startsWith('data:image/')) {
      imageDataUri = data.imageBuffer;
    } else {
      throw new Error('Invalid imageBuffer: must be Buffer or data URI string');
    }

    const message = await this.chatService.sendImageMessage(
      data.senderId,
      data.conversationId,
      imageDataUri,
      data.filename,
    );

    // Notify all participants in the conversation about the new image message
    this.server.to(`conversation-${data.conversationId}`).emit('newMessage', message);
    return message;
  }

  // Handle joining a conversation room
  @SubscribeMessage('joinConversation')
  handleJoinConversation(
    @MessageBody() data: { conversationId: number },
    @ConnectedSocket() client: Socket,
  ) {
    const room = `conversation-${data.conversationId}`;
    console.log(`Client ${client.id} attempting to join room ${room}`);
    client.join(room);
    console.log('Current rooms for client:', Array.from(client.rooms));
    console.log('All rooms:', this.server.sockets.adapter.rooms);
    console.log('All clients in room:', this.server.sockets.adapter.rooms.get(room));
    
    // Emit a confirmation back to the client
    client.emit('joinedConversation', { 
      conversationId: data.conversationId,
      socketId: client.id,
      room: room
    });
  }

  // Handle typing indicator
  @SubscribeMessage('typing')
  handleTyping(
    @MessageBody() data: { conversationId: number; userId: string },
    @ConnectedSocket() client: Socket,
  ) {
    // Notify other participants in the conversation that the user is typing
    this.server.to(`conversation-${data.conversationId}`).emit('userTyping', { userId: data.userId });
  }

  // Handle read receipts
  @SubscribeMessage('readReceipt')
  async handleReadReceipt(
    @MessageBody() data: { conversationId: number; userId: string },
    @ConnectedSocket() client: Socket,
  ) {
    // Mark messages as read in the conversation for this user
    await this.chatService.markMessagesAsRead(data.conversationId, data.userId);

    // Notify other participants that messages have been read
    this.server.to(`conversation-${data.conversationId}`).emit('messagesRead', { userId: data.userId });
  }
}