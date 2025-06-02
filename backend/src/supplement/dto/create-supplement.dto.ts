import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNumber, IsNotEmpty, Min, MaxLength, IsOptional } from 'class-validator';

export class CreateSupplementDto {
  @ApiProperty({ example: 'Whey Protein', description: 'Name of the supplement' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  name: string;

  @ApiProperty({ example: 'A high-quality whey protein supplement', description: 'Description of the supplement' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(500)
  description: string;

  @ApiProperty({ example: 120, description: 'Price of the supplement' }) 
  @IsNumber()
  @Min(0)
  price: number;
  
  @ApiProperty({ example: 10, description: 'Stock quantity of the supplement' })
  @IsNumber()
  @Min(0)
  stock: number;
  
  @ApiProperty({ example: 'https://example.com/image.jpg', description: 'URL of the supplement image', required: false })
  @IsOptional()
  @IsString()
  imageUrl?: string;

  @ApiProperty({ example: 'WHEY', description: 'Category of the supplement', required: false })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  category?: string;

  @ApiProperty({ example: '30 scoops', description: 'Serving size of the supplement', required: false })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  serving?: string;

  @ApiProperty({ example: 1, description: 'ID of the gym this supplement belongs to' })
  @IsNotEmpty()
  @IsOptional()
  gymId: number;
}