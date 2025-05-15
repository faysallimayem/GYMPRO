import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNumber, IsNotEmpty, Min, MaxLength } from 'class-validator';

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

  @ApiProperty({ example: 120, description: 'Type of the supplement' }) 
  @IsNumber()
  @Min(0)
  price: number;

  
  @ApiProperty({ example: 10, description: 'Expiration date of the supplement' })
  @IsNumber()
  @Min(0)
  stock: number;
}