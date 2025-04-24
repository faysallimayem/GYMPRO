import { ApiProperty } from "@nestjs/swagger";
import { IsNotEmpty, IsNumber, IsString } from "class-validator";

export class CreateNutritionDto {
    @ApiProperty({example:'Chicken'})
    @IsString()
    @IsNotEmpty()
    name: string;

    @ApiProperty({example: 30, description: 'Protein per 100g'})
    @IsNumber()
    @IsNotEmpty()
    protein: number;
    
    @ApiProperty({example: 300, description: 'calories per 100g'})
    @IsNumber()
    @IsNotEmpty()
    calories: number;


    @ApiProperty({example: 10, description: 'Fat per 100g'})
    @IsNumber()
    @IsNotEmpty()
    fat: number;
    
    @ApiProperty({example: 50, description: 'Carbohydrates per 100g'})
    @IsNumber()
    @IsNotEmpty()
    carbohydrates: number;

    @ApiProperty({example: 'https://example.com/image.jpg', description: 'Image URL'})
    @IsString()
    imageUrl: string;
  }