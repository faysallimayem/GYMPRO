import { IsString, IsArray, IsNumber, IsOptional, ValidateNested, IsInt } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty } from '@nestjs/swagger';

class WorkoutExerciseDto {
  @ApiProperty({ example: 1, description: 'ID of the exercise' })
  @IsInt()
  id: number; 
}

export class CreateWorkoutDto {
  @ApiProperty({ example: 'Upper Body Blast', description: 'Workout name' })
  @IsString()
  name: string;

  @ApiProperty({ example: 'A great workout for shoulders and arms', required: false })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({
    type: [WorkoutExerciseDto],
    example: [{ id: 1 }, { id: 2 }],
    description: 'Array of exercise IDs'
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkoutExerciseDto)
  exercises: WorkoutExerciseDto[];

  @ApiProperty({ example: 45, required: false, description: 'Duration in minutes' })
  @IsNumber()
  @IsOptional()
  duration?: number;
}