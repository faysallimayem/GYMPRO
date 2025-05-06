import { IsEmail, IsEnum, IsNumber, IsOptional, IsString, Max, Min, MinLength } from 'class-validator';
import { Role } from '../role.enum';
import { Transform } from 'class-transformer';

export class CreateUserDto {
    @IsString()
    lastName: string;

    @IsString()
    firstName: string;

    @IsEmail()
    email: string;

    @IsString()
    @MinLength(6)
    password: string;

    @IsNumber()
    @Min(12)
    @Max(100)
    age: number;

    @IsOptional()
    @IsNumber()
    height?: number;

    @IsOptional()
    @IsNumber()
    weight?: number;

    @IsString()
    gender: string;

    @IsOptional()
    @IsEnum(Role, { message: 'Role must be CLIENT, COACH, or ADMIN' })
    @Transform(({ value }) => value ?? Role.CLIENT) // Default to CLIENT if undefined
    role?: Role;
}
