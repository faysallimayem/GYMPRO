import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from './roles.decorator';
import { Role } from '../user/role.enum';

@Injectable()
export class RolesGuard implements CanActivate {
    constructor(private reflector: Reflector){}

    canActivate(context: ExecutionContext): boolean  {
        const requiredRoles = this.reflector.getAllAndOverride<Role[]>(ROLES_KEY, [
        context.getHandler(),
        context.getClass(),
        ]);
        
        if (!requiredRoles) {
            return true;
        }
        
        const {user} = context.switchToHttp().getRequest();
        
        if (!user || !user.role) {
            return false;
        }
        
        return requiredRoles.some((role) => user.role === role);
    }
}    