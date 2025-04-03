import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsEmail, MinLength, IsDate, IsOptional, IsNumber, IsEnum } from 'class-validator';
import { Role } from 'src/user/role.enum';

export class SignupDto {
  @ApiProperty({ example: 'Doe' })
  @IsString()
  nom: string;

  @ApiProperty({ example: 'John' })
  @IsString()
  prenom: string;

  @ApiProperty({ example: 'john.doe@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'secure123' })
  @MinLength(6)
  mot_de_passe: string;

  @ApiProperty({ example: '1995-06-15' })
  @IsDate()
  dateNaissance: Date;

  @ApiProperty({ example: 180, required: false })
  @IsOptional()
  @IsNumber()
  hauteur?: number;

  @ApiProperty({ example: 75, required: false })
  @IsOptional()
  @IsNumber()
  poids?: number;

  @ApiProperty({ example: 'Homme' })
  @IsString()
  sexe: string;

  @ApiProperty({ example: Role.CLIENT, enum: Role, default: Role.CLIENT })
  @IsEnum(Role)
  role: Role;
}
