import { IsNotEmpty, IsString, IsNumber, IsEnum, IsDateString, IsOptional, Min, MaxLength, Matches } from 'class-validator';
import { Transform } from 'class-transformer';
import { ClassType } from '../class.entity';

export class CreateClassDto {
  @IsOptional()
  @IsNumber()
  gymId?: number;

  @IsNotEmpty()
  @IsString()
  @MaxLength(100)
  className: string;

  @IsNotEmpty()
  @IsString()
  @Matches(/^([01]\d|2[0-3]):([0-5]\d)$/, { message: 'Start time must be in format HH:MM' })
  startTime: string;

  @IsNotEmpty()
  @IsString()
  @Matches(/^([01]\d|2[0-3]):([0-5]\d)$/, { message: 'End time must be in format HH:MM' })
  endTime: string;

  @IsNotEmpty()
  @IsString()
  @MaxLength(100)
  instructor: string;

  @IsOptional()
  @IsString()
  instructorImageUrl?: string;

  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  duration: number;

  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  capacity: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  bookedSpots?: number;

  @IsNotEmpty()
  @IsEnum(ClassType)
  @Transform(({ value }) => {
    // Transform the incoming value to match the ClassType enum format
    if (value === 'CARDIO') return ClassType.Cardio;
    if (value === 'STRENGTH') return ClassType.Strength;
    if (value === 'YOGA') return ClassType.Yoga;
    return value;
  })
  classType: ClassType;

  @IsNotEmpty()
  @IsDateString()
  date: string;
}