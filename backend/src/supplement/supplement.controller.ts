import { Controller, Post, Get, Patch, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiResponse, ApiBody } from '@nestjs/swagger';
import { Roles } from 'src/auth/roles.decorator';
import { RolesGuard } from 'src/auth/roles.guard';
import { AuthGuard } from '@nestjs/passport';
import { Role } from 'src/user/role.enum';
import { SupplementService } from './supplement.service';
import { Supplement } from './supplement.entity';
import { CreateSupplementDto } from './dto/create-supplement.dto';
import { UpdateSupplementDto } from './dto/update-supplement.dto';

@ApiTags('supplements')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))

@Controller('supplements')
export class SupplementController {
  constructor(private readonly supplementService: SupplementService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  @ApiOperation({ summary: 'Create a new supplement' })
  @ApiResponse({ status: 201, description: 'Supplement created successfully' })
  @ApiBody({ type: CreateSupplementDto })
  async createSupplement(@Body() createSupplementDto: CreateSupplementDto): Promise<Supplement> {
    return this.supplementService.createSupplement(createSupplementDto);
  }

  @Get()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)  
  @ApiOperation({ summary: 'Get all supplements' })
  @ApiResponse({ status: 200, description: 'List of all supplements' })
  async getAllSupplements(): Promise<Supplement[]> {
    return this.supplementService.getAllSupplements();
  }

  @Get(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)    
  @ApiOperation({ summary: 'Get supplement by ID' })
  @ApiResponse({ status: 200, description: 'Supplement found' })
  @ApiResponse({ status: 404, description: 'Supplement not found' })
  async getSupplementById(@Param('id') id: number): Promise<Supplement> {
    return this.supplementService.getSupplementById(id);
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
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
  async updateSupplement(@Param('id') id: number, @Body() updateSupplementDto: UpdateSupplementDto): Promise<Supplement> {
    return this.supplementService.updateSupplement(id, updateSupplementDto);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)    
  @Roles(Role.ADMIN)    
  @ApiOperation({ summary: 'Delete supplement by ID' })
  @ApiResponse({ status: 200, description: 'Supplement deleted successfully' })
  @ApiResponse({ status: 404, description: 'Supplement not found' })
  async deleteSupplement(@Param('id') id: number): Promise<{ message: string }> {
    await this.supplementService.deleteSupplement(id);
    return { message: `Supplement with ID ${id} deleted successfully` };
  }

   // Public endpoint to get all supplements
   @Get('public')
   @ApiOperation({ summary: 'Get all available supplements (public)' })
   @ApiResponse({ status: 200, description: 'List of all available supplements' })
   async getAllAvailableSupplements(): Promise<Supplement[]> {
     return this.supplementService.getAllSupplements();
   }
   
   // Public endpoint to search  a specific supplement by ID
  @Get('public/:name')
  @ApiOperation({ summary: 'Get supplement details by Name (public)' })
  @ApiResponse({ status: 200, description: 'Supplement details found' })
  @ApiResponse({ status: 404, description: 'Supplement not found' })
  async searchSupplementByName(@Param('name') name: string): Promise<Supplement[]> {
    return this.supplementService.searchSupplementsByName(name);
  }
}