import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class CreateConversationDto {
  @IsString()
  @ApiProperty({ example: 'user123', description: 'ID of the first user' })
  userOneId: string;

  @IsString()
  @ApiProperty({ example: 'user456', description: 'ID of the second user' })
  userTwoId: string;
}