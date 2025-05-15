import { IsString, IsArray, IsNumber, IsOptional, ValidateNested, IsInt } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, PartialType } from '@nestjs/swagger';
import { CreateWorkoutDto } from './create-workout.dto';


export class UpdateWorkoutDto extends PartialType(CreateWorkoutDto) {

}