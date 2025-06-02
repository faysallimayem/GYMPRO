import { Module } from '@nestjs/common';
import { ChatService } from './chat.service';
import { ChatController } from './chat.controller';
import { ChatGateway } from './chat.gateway';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Message } from './message.entity';
import { Conversation } from './conversation.entity';
import { User } from '../user/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Message, Conversation, User])],
  providers: [ChatService, ChatGateway],
  controllers: [ChatController]
})
export class ChatModule {}
