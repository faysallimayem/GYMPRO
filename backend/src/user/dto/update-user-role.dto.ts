import { IsEnum } from 'class-validator';
import { Role } from '../role.enum';
import { ApiProperty } from '@nestjs/swagger';

export class UpdateUserRoleDto {
    @ApiProperty({
        description: 'User role',
        enum: Role,
        example: Role.CLIENT
    })
    @IsEnum(Role, { message: 'Role must be CLIENT, COACH, or ADMIN' })
    role: Role;
}
