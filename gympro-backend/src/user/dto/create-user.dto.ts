import { IsEmail, IsEnum, IsOptional, IsString, MinLength } from 'class-validator';
import { Role } from '../role.enum';
import { Transform } from 'class-transformer';

export class CreateUserDto {
    @IsString()
    nom: string;

    @IsString()
    prenom: string;

    @IsEmail()
    email: string;

    @IsString()
    @MinLength(6)
    mot_de_passe: string;

    @IsOptional()
    @IsEnum(Role, { message: 'Role must be CLIENT, COACH, or ADMIN' })
    @Transform(({ value }) => value ?? Role.CLIENT) // Default to CLIENT if undefined
    role?: Role;
}
