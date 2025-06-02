import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsOptional, IsString, MinLength, IsNumber, IsUrl } from 'class-validator';

export class UpdateUserDto {
  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  firstName?: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  lastName?: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsEmail()
  email?: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  age?: number;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  height?: number;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  weight?: number;
  @ApiProperty({ required: false, enum: ['Male', 'Female'] })
  @IsOptional()
  @IsString()
  gender?: string;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsString()
  photoUrl?: string;
}
