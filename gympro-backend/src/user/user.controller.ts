import { Controller, Post, Body, Get, Delete, UseGuards,Req, Param, NotFoundException } from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';
import { User } from './user.entity';

import { AuthGuard } from '@nestjs/passport';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiResponse, ApiTags, ApiUnauthorizedResponse } from '@nestjs/swagger';
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
@ApiOperation({ summary: 'Get all users' })
async getAllUsers() {
  return this.userService.getAllUsers();
}

@Get(':id')
@ApiOperation({ summary: 'Get user by ID' })
@ApiResponse({ status: 404, description: 'User not found' })
async getUserById(id: number) {
  return this.userService.getUserById(id);
}

@Post(':id')
@ApiOperation({ summary: 'Update user by ID' })
async updateUser(id: number, @Body() userData: Partial<User>) {
  return this.userService.updateUser(id, userData); 
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



}
