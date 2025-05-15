import { IsString, IsOptional, IsNumber, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateMealItemDto {
  @IsNumber()
  nutritionId: number;

  @IsNumber()
  @IsOptional()
  quantity: number = 1;

  @IsString()
  @IsOptional()
  unit: string = 'serving';
}

export class CreateMealDto {
  @IsString()
  name: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsNumber()
  @IsOptional()
  userId?: number;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateMealItemDto)
  items: CreateMealItemDto[];
}