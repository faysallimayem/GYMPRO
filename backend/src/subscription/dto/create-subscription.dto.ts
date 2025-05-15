import { ApiProperty } from '@nestjs/swagger';
import { IsDate, IsNumber, IsString, IsPositive } from 'class-validator';

export class CreateSubscriptionDto {
  
  @ApiProperty({ example: 1, description: 'User ID' })  
  @IsNumber()
  userId: number;

  @IsString()
  @ApiProperty({ example: 'Premium Plan', description: 'Name of the subscription plan' })  
  planName: string;

  @IsNumber()
  @IsPositive()
  @ApiProperty({ example: 29.99, description: 'Price of the subscription plan' })
  price: number;

  @IsNumber()
  @IsPositive()
  @ApiProperty({ example: 30, description: 'Duration of the subscription in days' })
  durationInDays: number;

  
}