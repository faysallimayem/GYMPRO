import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsEmail, MinLength, IsOptional, IsNumber, IsEnum, Min, Max } from 'class-validator';
import { Role } from 'src/user/role.enum';

export class SignupDto {
  @ApiProperty({ example: 'Doe' })
  @IsString()
  lastName: string;

  @ApiProperty({ example: 'John' })
  @IsString()
  firstName: string;

  @ApiProperty({ example: 'john.doe@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'secure123' })
  @MinLength(6)
  password: string;

  @ApiProperty({ example: 25 })
  @IsNumber()
  @Min(12)
  @Max(100)
  age: number;

  @ApiProperty({ example: 180, required: false })
  @IsOptional()
  @IsNumber()
  height?: number;

  @ApiProperty({ example: 75, required: false })
  @IsOptional()
  @IsNumber()
  weight?: number;

  @ApiProperty({ example: 'Male' })
  @IsString()
  gender: string;

  @ApiProperty({ example: Role.CLIENT, enum: Role, default: Role.CLIENT })
  @IsEnum(Role)
  role: Role;
}
