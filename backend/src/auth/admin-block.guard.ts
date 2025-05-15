import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Role } from '../user/role.enum';

/**
 * This guard specifically blocks admin users from accessing certain endpoints
 * It's used to prevent admin accounts from managing nutrition and exercise data
 */
@Injectable()
export class AdminBlockGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    
    if (user && user.role === Role.ADMIN) {
      throw new ForbiddenException('Admin users are not allowed to access this resource');
    }
    
    return true;
  }
}
