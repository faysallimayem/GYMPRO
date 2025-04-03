import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, MinLength } from 'class-validator';

export class LoginDto {
  @ApiProperty({ example: 'john.doe@example.com' })
  @IsNotEmpty()
  @IsEmail()
  email: string;


  @ApiProperty({ example: 'secure123' })
  @IsString()
  @MinLength(6)
  @IsNotEmpty()

  mot_de_passe: string;
}
