import { Controller, Post, Body, Get, Delete, UseGuards,Req } from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';
import { User } from './user.entity';

import { AuthGuard } from '@nestjs/passport';

@Controller('user') 
export class UserController {
  constructor(private readonly userService: UserService) {}

@Post() 
  async create(@Body() createUserDto: CreateUserDto) {
    return this.userService.create(createUserDto);
  }

@Get()
  async getAllUsers() {
    return this.userService.getAllUsers();
  }

@Get(':id')
  async getUserById(id: number) {
    return this.userService.getUserById(id);
  }

@Post(':id')
  async updateUser(id: number, @Body() userData: Partial<User>) {
    return this.userService.updateUser(id, userData); 
  }

@Delete(':id')
  async deleteUser(id: number) {
    return this.userService.deleteUser(id);
  }

@Get('me')
@UseGuards(AuthGuard('jwt'))
  async getProfile(@Req() req) {
    return this.userService.getProfile(req.user.id);
  }  



}
