import { Controller, Get, Post, Param, Body, UseGuards } from '@nestjs/common';
import { ChatService } from './chat.service';
import { AuthGuard } from '@nestjs/passport';
import { ApiBearerAuth } from '@nestjs/swagger';
import { CreateConversationDto } from './dto/create-conversation.dto';

@Controller('chat')
@UseGuards(AuthGuard('jwt')) 
@ApiBearerAuth() 
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  // Get all conversations for a user
  @Get('conversations/:userId')
  
  async getUserConversations(@Param('userId') userId: string) {
    return this.chatService.getUserConversations(userId);
  }

  // Get all messages for a specific conversation
  @Get('conversations/:conversationId/messages')
  async getMessages(@Param('conversationId') conversationId: number) {
    return this.chatService.getMessages(conversationId);
  }

  // Create or retrieve a conversation between two users
  @Post('conversations')
  async createOrGetConversation(@Body() createConversationDto: CreateConversationDto) {
    const { userOneId, userTwoId } = createConversationDto;
    return this.chatService.getOrCreateConversation(userOneId, userTwoId);
  }
}