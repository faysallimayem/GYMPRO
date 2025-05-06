import { IsNumber, IsOptional, IsString, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class NutritionItemDto {
  @IsNumber()
  nutritionId: number;
  
  @IsNumber()
  quantity: number;
  
  @IsString()
  @IsOptional()
  unit?: string;
}

export class CalculateNutritionDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => NutritionItemDto)
  items: NutritionItemDto[];
  
  @IsNumber()
  @IsOptional()
  targetCalories?: number;
  
  @IsNumber()
  @IsOptional()
  targetProtein?: number;
  
  @IsNumber()
  @IsOptional()
  targetFat?: number;
  
  @IsNumber()
  @IsOptional()
  targetCarbohydrates?: number;
}