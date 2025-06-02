import { Controller, Post, Get, Patch, Delete, Body, Param, UseGuards, Request, ForbiddenException } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiResponse, ApiBody } from '@nestjs/swagger';
import { Roles } from 'src/auth/roles.decorator';
import { RolesGuard } from 'src/auth/roles.guard';
import { AuthGuard } from '@nestjs/passport';
import { Role } from 'src/user/role.enum';
import { GymMemberGuard } from 'src/auth/gym-member.guard';
import { RequiresGymMembership } from 'src/auth/requires-membership.decorator';
import { SupplementService } from './supplement.service';
import { Supplement } from './supplement.entity';
import { CreateSupplementDto } from './dto/create-supplement.dto';
import { UpdateSupplementDto } from './dto/update-supplement.dto';
import { Gym } from '../gym/gym.entity';
import { UserService } from '../user/user.service';

@ApiTags('supplements')
@Controller('supplements')
export class SupplementController {
  constructor(
    private readonly supplementService: SupplementService,
    private readonly userService: UserService,
  ) {}

  @Post()
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Roles(Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create a new supplement' })
  @ApiResponse({ status: 201, description: 'Supplement created successfully' })
  @ApiBody({ type: CreateSupplementDto })
  async createSupplement(@Body() createSupplementDto: CreateSupplementDto, @Request() req: any): Promise<Supplement> {
    const admin = await this.userService.getProfile(req.user.id);
    if (!admin) {
      throw new ForbiddenException('Admin not found');
    }
    if (!admin.managedGym) {
      throw new ForbiddenException('You must manage a gym to add supplements');
    }
    return this.supplementService.createSupplement({ ...createSupplementDto, gymId: admin.managedGym.id });
  }

  @Get()
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Roles(Role.ADMIN)  
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get all supplements' })
  @ApiResponse({ status: 200, description: 'List of all supplements' })
  async getAllSupplements(): Promise<Supplement[]> {
    return this.supplementService.getAllSupplements();
  }

  @Get('public/all')
  @ApiOperation({ summary: 'Get all available supplements (public)' })
  @ApiResponse({ status: 200, description: 'List of all available supplements' })
  async getAllAvailableSupplements(): Promise<Supplement[]> {
    return this.supplementService.getAllSupplements();
  }
   
  @Get('public/:name')
  @ApiOperation({ summary: 'Get supplement details by Name (public)' })
  @ApiResponse({ status: 200, description: 'Supplement details found' })
  @ApiResponse({ status: 404, description: 'Supplement not found' })
  async searchSupplementByName(@Param('name') name: string): Promise<Supplement[]> {
    return this.supplementService.searchSupplementsByName(name);
  }

  @Get('details/:id')
  @UseGuards(AuthGuard('jwt'), GymMemberGuard)
  @RequiresGymMembership()
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get detailed supplement information (premium feature)' })
  @ApiResponse({ status: 200, description: 'Supplement details found' })
  @ApiResponse({ status: 404, description: 'Supplement not found' })
  @ApiResponse({ status: 401, description: 'This feature requires an active gym membership' })
  async getSupplementDetails(@Param('id') id: number): Promise<Supplement> {
    return this.supplementService.getSupplementById(id);
  }


  @Get('my-gym')
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Roles(Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get all supplements for the admin\'s managed gym' })
  @ApiResponse({ status: 200, description: 'List of supplements for the admin\'s gym' })
  async getMyGymSupplements(@Request() req: any): Promise<Supplement[]> {
    const admin = await this.userService.getProfile(req.user.id);
    if (!admin) throw new ForbiddenException('Admin not found');
    if (!admin.managedGym) throw new ForbiddenException('No managed gym');
    const supplements = await this.supplementService.getSupplementsByGymId(admin.managedGym.id);
    console.log('DEBUG /supplements/my-gym supplements:', supplements);
    return supplements;
  }

  
  @Get(':id')
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Roles(Role.ADMIN)    
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get supplement by ID' })
  @ApiResponse({ status: 200, description: 'Supplement found' })
  @ApiResponse({ status: 404, description: 'Supplement not found' })
  async getSupplementById(@Param('id') id: number): Promise<Supplement> {
    return this.supplementService.getSupplementById(id);
  }

  @Patch(':id')
  @UseGuards(AuthGuard('jwt'), RolesGuard)
  @Roles(Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update supplement by ID' })
  @ApiResponse({ status: 200, description: 'Supplement updated successfully' })
  @ApiResponse({ status: 404, description: 'Supplement not found' })
  @ApiBody({ type: UpdateSupplementDto,examples: {
    example1: {
      summary: 'Update Supplement Example',
      value: {
        name: 'Updated Whey Protein',
        description: 'An updated description for the whey protein supplement.',
        price: 150,
        stock: 30,
      },
    },
  },
 })
  async updateSupplement(@Param('id') id: number, @Body() updateSupplementDto: UpdateSupplementDto, @Request() req: any): Promise<Supplement> {
    const admin = await this.userService.getProfile(req.user.id);
    if (!admin) {
      throw new ForbiddenException('Admin not found');
    }
    const supplement = await this.supplementService.getSupplementById(id);
    if (!admin.managedGym || supplement.gym.id !== admin.managedGym.id) {
      throw new ForbiddenException('You can only update supplements for your managed gym');
    }
    return this.supplementService.updateSupplement(id, updateSupplementDto);
  }

  @Delete(':id')
  @UseGuards(AuthGuard('jwt'), RolesGuard)    
  @Roles(Role.ADMIN)    
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete supplement by ID' })
  @ApiResponse({ status: 200, description: 'Supplement deleted successfully' })
  @ApiResponse({ status: 404, description: 'Supplement not found' })
  async deleteSupplement(@Param('id') id: number, @Request() req: any): Promise<{ message: string }> {
    const admin = await this.userService.getProfile(req.user.id);
    if (!admin) {
      throw new ForbiddenException('Admin not found');
    }
    const supplement = await this.supplementService.getSupplementById(id);
    if (!admin.managedGym || supplement.gym.id !== admin.managedGym.id) {
      throw new ForbiddenException('You can only delete supplements for your managed gym');
    }
    await this.supplementService.deleteSupplement(id);
    return { message: `Supplement with ID ${id} deleted successfully` };
  }

  @Post('purchase/:id')
  @UseGuards(AuthGuard('jwt'), GymMemberGuard)
  @RequiresGymMembership()
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Purchase a supplement (premium feature)' })
  @ApiResponse({ status: 200, description: 'Supplement purchased successfully' })
  @ApiResponse({ status: 404, description: 'Supplement not found' })
  @ApiResponse({ status: 401, description: 'This feature requires an active gym membership' })
  async purchaseSupplement(@Param('id') id: number): Promise<{ message: string }> {
    await this.supplementService.getSupplementById(id); // Just to verify it exists
    return { message: `Supplement with ID ${id} purchased successfully` };
  }

  @Get('by-gym/:gymId')
  @ApiOperation({ summary: 'Get all supplements for a specific gym' })
  @ApiResponse({ status: 200, description: 'List of supplements for the gym' })
  async getSupplementsByGym(@Param('gymId') gymId: number): Promise<Supplement[]> {
    return this.supplementService.getSupplementsByGymId(gymId);
  }

  
}