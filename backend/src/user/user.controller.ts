import { Controller, Post, Body, Get, Patch, Delete, UseGuards, Req, Param, NotFoundException, Query } from '@nestjs/common';
import { UserService, PaginatedResult } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';
import { User } from './user.entity';
import { UpdateUserRoleDto } from './dto/update-user-role.dto';
import { UpdateUserDto } from './dto/update-user-details.dto';

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
@ApiOperation({ summary: 'Get all users with optional pagination and search' })
@ApiQuery({ name: 'page', required: false, description: 'Page number (default: 1)' })
@ApiQuery({ name: 'limit', required: false, description: 'Number of items per page (default: 10)' })
@ApiQuery({ name: 'search', required: false, description: 'Search term for name or email' })
async getAllUsers(
  @Query('page') page = '1',
  @Query('limit') limit = '10',
  @Query('search') search?: string,
) {
  const pageNumber = parseInt(page) || 1;
  const limitNumber = parseInt(limit) || 10;
  
  return this.userService.getPaginatedUsers(pageNumber, limitNumber, search);
}

@Get(':id')
@ApiOperation({ summary: 'Get user by ID' })
@ApiResponse({ status: 404, description: 'User not found' })
async getUserById(@Param('id') id: number) {
  return this.userService.getUserById(id);
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
@ApiOperation({ summary: 'Get current user profile' })
@ApiBearerAuth()
@ApiUnauthorizedResponse({ description: 'Unauthorized' })

async getProfile(@Req() req) {
  return this.userService.getProfile(req.user.id);
}

@Patch(':id')
@ApiOperation({ summary: 'Update user details by ID' })
@ApiBody({ type: UpdateUserDto })
@ApiResponse({ status: 404, description: 'User not found' })
async updateUserDetails(@Param('id') id: number, @Body() updateUserDto: UpdateUserDto) {
  return this.userService.updateUserDetails(id, updateUserDto);
}

}
