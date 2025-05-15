import { IsString, IsOptional, IsUrl } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateExerciseDto {
  @ApiProperty({ example: 'Push-up', description: 'Exercise name' })
  @IsString()
  name: string;

  @ApiProperty({ 
    example: 'A classic bodyweight exercise for chest muscles',
    required: false 
  })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({ example: 'chest', description: 'Target muscle group' })
  @IsString()
  muscleGroup: string;

  @ApiProperty({ 
    example: 'https://example.com/pushup-video.mp4',
    required: false 
  })
  @IsUrl()
  @IsOptional()
  videoUrl?: string;
}