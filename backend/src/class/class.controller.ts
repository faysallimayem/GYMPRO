import { Controller, Get, Post, Patch, Delete, Body, Param, Query, UseGuards, Req, ParseUUIDPipe, HttpStatus, BadRequestException } from '@nestjs/common';
import { ClassService } from './class.service';
import { GymClass } from './class.entity';
import { CreateClassDto } from './dto/create-class.dto';
import { UpdateClassDto } from './dto/update-class.dto';
import { JwtAuthGuard, RolesGuard } from '../auth/guards.index';
import { Roles } from '../auth/roles.decorator';
import { Role } from '../user/role.enum';

@Controller('classes')
export class ClassController {
  constructor(private readonly classService: ClassService) {}

  // Get all classes with optional filters
  @Get()
  async findAll(
    @Query('date') date?: string,
    @Query('type') classType?: string,
  ): Promise<GymClass[]> {
    return this.classService.findAll(date, classType);
  }

  // Get a specific class by ID
  @Get(':id')
  async findOne(@Param('id', ParseUUIDPipe) id: string): Promise<GymClass> {
    return this.classService.findOne(id);
  }

  // Create a new class (admin only)
  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN)
  async create(
    @Body() createClassDto: CreateClassDto,
    @Req() req: any,
  ): Promise<GymClass> {
    // Check if user and id exist before calling toString()
    const userId = req.user && req.user.id ? req.user.id.toString() : undefined;
    return this.classService.create(createClassDto, userId);
  }

  // Update a class (admin only)
  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN)
  async update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateClassDto: UpdateClassDto,
  ): Promise<GymClass> {
    return this.classService.update(id, updateClassDto);
  }

  // Delete a class (admin only)
  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN)
  async remove(@Param('id', ParseUUIDPipe) id: string): Promise<{ message: string }> {
    await this.classService.remove(id);
    return { message: 'Class successfully deleted' };
  }
  // Book a class
  @Post(':id/book')
  @UseGuards(JwtAuthGuard)
  async bookClass(
    @Param('id', ParseUUIDPipe) classId: string,
    @Req() req: any,
    @Body() body: any,
  ): Promise<GymClass> {
    // First try to get userId from the request body
    let userId = body && body.userId ? body.userId.toString() : undefined;
    
    // If not in body, try to get it from the JWT token
    if (!userId && req.user && req.user.id) {
      userId = req.user.id.toString();
    }
    
    if (!userId) {
      throw new BadRequestException('User ID is missing');
    }
    return this.classService.bookClass(classId, userId);
  }
  // Cancel a booking
  @Post(':id/cancel')
  @UseGuards(JwtAuthGuard)
  async cancelBooking(
    @Param('id', ParseUUIDPipe) classId: string,
    @Req() req: any,
    @Body() body: any,
  ): Promise<GymClass> {
    // First try to get userId from the request body
    let userId = body && body.userId ? body.userId.toString() : undefined;
    
    // If not in body, try to get it from the JWT token
    if (!userId && req.user && req.user.id) {
      userId = req.user.id.toString();
    }
    
    if (!userId) {
      throw new BadRequestException('User ID is missing');
    }
    return this.classService.cancelBooking(classId, userId);
  }

  // Get user's bookings
  @Get('user/bookings')
  @UseGuards(JwtAuthGuard)
  async getUserBookings(@Req() req: any): Promise<GymClass[]> {
    // Apply the same check here for consistency
    const userId = req.user && req.user.id ? req.user.id.toString() : undefined;
    if (!userId) {
      throw new BadRequestException('User ID is missing');
    }
    return this.classService.getUserBookings(userId);
  }
} 