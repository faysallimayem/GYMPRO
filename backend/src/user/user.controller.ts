import { Controller, Post, Body, Get, Patch, Delete, UseGuards, Req, Param, NotFoundException, Query, ParseIntPipe, ForbiddenException } from '@nestjs/common';
import { UserService, PaginatedResult } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';
import { User } from './user.entity';
import { UpdateUserRoleDto } from './dto/update-user-role.dto';
import { UpdateUserDto } from './dto/update-user-details.dto';
import { UpdateMembershipDto } from './dto/update-membership.dto';

import { AuthGuard } from '@nestjs/passport';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiQuery, ApiResponse, ApiTags, ApiUnauthorizedResponse } from '@nestjs/swagger';
import { Role } from './role.enum';
import { Roles } from 'src/auth/roles.decorator';
import { RolesGuard } from 'src/auth/roles.guard';


@ApiTags('users')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RolesGuard)
@Roles(Role.ADMIN)
@ApiResponse({ status: 403, description: 'only admin can use it  ' })
@Controller('user') 
export class UserController {
  constructor(private readonly userService: UserService) {}

@Post() 
@ApiOperation({ summary: 'Create a new user' })
@ApiBody({ type: CreateUserDto })
@ApiUnauthorizedResponse({ description: 'Unauthorized' })
async create(@Body() createUserDto: CreateUserDto) {
  return this.userService.create(createUserDto);
}

@Get()
@ApiOperation({ summary: 'Get all users with optional pagination and search, filtered by admin gym' })
@ApiQuery({ name: 'page', required: false, description: 'Page number (default: 1)' })
@ApiQuery({ name: 'limit', required: false, description: 'Number of items per page (default: 10)' })
@ApiQuery({ name: 'search', required: false, description: 'Search term for name or email' })
@ApiQuery({ name: 'gymId', required: false, description: 'Gym ID to filter users by' })
@ApiQuery({ name: 'isGymMember', required: false, description: 'Filter by gym membership status' })
async getAllUsers(
  @Query('page') page = '1',
  @Query('limit') limit = '10',
  @Query('search') search?: string,
  @Query('gymId') gymId?: string,
  @Req() req?: any
) {
  const pageNumber = parseInt(page) || 1;
  const limitNumber = parseInt(limit) || 10;

  // Fetch the full admin user with relations
  const admin = await this.userService.getProfile(req?.user?.id);
  if (!admin) {
    throw new ForbiddenException('Admin not found in request');
  }

  // Always use the admin's managed gym ID
  let adminGymId: number | undefined;
  if (admin.managedGym?.id) {
    adminGymId = admin.managedGym.id;
  } else {
    throw new ForbiddenException('Admin does not manage any gym');
  }

  return this.userService.getPaginatedUsers(pageNumber, limitNumber, search, adminGymId);
}

@Get('find-by-email')
@ApiOperation({ summary: 'Find user by exact email (no membership filter)' })
@ApiQuery({ name: 'email', required: true, description: 'User email to search for' })
async findByEmail(@Query('email') email: string) {
  // Use getByEmail for exact match, no isGymMember filter
  const user = await this.userService.getByEmail(email);
  if (!user) {
    throw new NotFoundException('No user found with this email');
  }
  return [user]; // Return as array for frontend compatibility
}


@Get(':id')
@ApiOperation({ summary: 'Get user by ID' })
@ApiResponse({ status: 404, description: 'User not found' })
@ApiBearerAuth()
async getUserById(@Param('id') id: number, @Req() req: any) {
  // Load full user with gym for both requester and target
  const targetUser = await this.userService.getUserById(id);
  if (!targetUser) throw new NotFoundException('User not found');

  const requester = await this.userService.getUserById(req.user.id);
  if (!requester) throw new NotFoundException('Requester not found');

  // Debug logs
  console.log('Requester:', requester.id, 'Gym:', requester.gym?.id);
  console.log('Target:', targetUser.id, 'Gym:', targetUser.gym?.id, 'ManagedGym:', targetUser.managedGym?.id);

  // Allow if admin
  if (requester.role === 'admin') return targetUser;
  // Allow if self
  if (requester.id === targetUser.id) return targetUser;
  // Allow if both are in the same gym
  if (
    requester.gym &&
    (targetUser.gym && requester.gym.id === targetUser.gym.id ||
     targetUser.managedGym && requester.gym.id === targetUser.managedGym.id)
  ) {
    return targetUser;
  }
  throw new ForbiddenException('Forbidden resource');
}

@Post(':id/role')
@ApiOperation({ summary: 'Update user role by ID - Admin can only change roles' })
@ApiBody({ type: UpdateUserRoleDto })
@ApiResponse({ status: 404, description: 'User not found' })
async updateUserRole(@Param('id') id: number, @Body() updateRoleDto: UpdateUserRoleDto) {
  // Admin can only update the user's role
  return this.userService.updateUserRole(id, updateRoleDto.role); 
}

@Delete(':id')
@ApiOperation({ summary: 'Delete user by ID' })
@ApiResponse({ status: 404, description: 'User not found' })
@ApiResponse({ status: 200, description: 'User deleted successfully' })
async deleteUser(@Param('id') id: number): Promise<{ message: string }> {
  const result = await this.userService.deleteUser(id);
  if (!result) {
    throw new NotFoundException(`User with ID ${id} not found`);
  }
  return { message: `User with ID ${id} deleted successfully` };
}

@Get('me')
@ApiOperation({ summary: 'Get current user profile (robust)' })
@ApiBearerAuth()
@ApiUnauthorizedResponse({ description: 'Unauthorized' })
async getMe(@Req() req) {
  // Try to extract user ID from all possible sources and log for debugging
  let userId: number | undefined;
  console.log('DEBUG /user/me req.user:', req.user);
  if (req.user) {
    if (typeof req.user.id === 'number' && !isNaN(req.user.id)) {
      userId = req.user.id;
    } else if (typeof req.user.id === 'string' && !isNaN(Number(req.user.id))) {
      userId = Number(req.user.id);
    } else if (typeof req.user.sub === 'number' && !isNaN(req.user.sub)) {
      userId = req.user.sub;
    } else if (typeof req.user.sub === 'string' && !isNaN(Number(req.user.sub))) {
      userId = Number(req.user.sub);
    }
  }
  if (!userId) {
    console.error('AUTH ERROR: Could not extract user ID from req.user:', req.user);
    throw new NotFoundException('Authenticated user not found or invalid token. req.user=' + JSON.stringify(req.user));
  }
  const user = await this.userService.getProfile(userId);
  if (!user) throw new NotFoundException('User not found');

  // Always include managedGymId and managedGym in the response
  return {
    ...user,
    managedGymId: user.managedGym ? user.managedGym.id : null,
    managedGym: user.managedGym || null,
    gymId: user.gym ? user.gym.id : null,
    gym: user.gym || null,
  };
}

@Patch(':id')
@ApiOperation({ summary: 'Update user details by ID' })
@ApiBody({ type: UpdateUserDto })
@ApiResponse({ status: 404, description: 'User not found' })
async UpdateUserDetails(@Param('id') id: number, @Body() updateUserDto: UpdateUserDto) {
  return this.userService.updateUserDetails(id, updateUserDto);
}

@Patch(':id/membership')
@ApiOperation({ summary: 'Update user gym membership status' })
@ApiBody({ type: UpdateMembershipDto })
@ApiResponse({ status: 404, description: 'User not found' })
@ApiResponse({ status: 200, description: 'Membership updated successfully' })
async UpdateMembershipDto(@Param('id') id: number, @Body() updateMembershipDto: UpdateMembershipDto) {
  // Convert string date to Date object if provided
  const membershipExpiresAt = updateMembershipDto.membershipExpiresAt 
    ? new Date(updateMembershipDto.membershipExpiresAt) 
    : undefined;
  
  return this.userService.updateMembership(
    id, 
    updateMembershipDto.isGymMember, 
    membershipExpiresAt
  );
}

@Post(':adminId/assign-gym/:gymId')
@ApiOperation({ summary: 'Assign an admin to manage a gym' })
@ApiResponse({ status: 200, description: 'Admin assigned to gym successfully', type: User })
async assignAdminToGym(
  @Param('adminId', ParseIntPipe) adminId: number,
  @Param('gymId', ParseIntPipe) gymId: number
) {
  return this.userService.assignAdminToGym(adminId, gymId);
}


}
function assignAdminToGym(arg0: any, adminId: any, number: any, arg3: any, gymId: any, number1: any) {
  throw new Error('Function not implemented.');
}

