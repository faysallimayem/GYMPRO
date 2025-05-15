import { IsString, IsNumber, IsEnum, IsDateString, IsOptional, Min, MaxLength, Matches } from 'class-validator';
import { ClassType } from '../class.entity';

export class UpdateClassDto {
  @IsOptional()
  @IsString()
  @MaxLength(100)
  className?: string;

  @IsOptional()
  @IsString()
  @Matches(/^([01]\d|2[0-3]):([0-5]\d)$/, { message: 'Start time must be in format HH:MM' })
  startTime?: string;

  @IsOptional()
  @IsString()
  @Matches(/^([01]\d|2[0-3]):([0-5]\d)$/, { message: 'End time must be in format HH:MM' })
  endTime?: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  instructor?: string;

  @IsOptional()
  @IsString()
  instructorImageUrl?: string;

  @IsOptional()
  @IsNumber()
  @Min(1)
  duration?: number;

  @IsOptional()
  @IsNumber()
  @Min(1)
  capacity?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  bookedSpots?: number;

  @IsOptional()
  @IsEnum(ClassType)
  classType?: ClassType;

  @IsOptional()
  @IsDateString()
  date?: string;
} 