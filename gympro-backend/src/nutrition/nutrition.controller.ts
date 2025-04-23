import { Body, Controller, Delete, Get, NotFoundException, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { NutritionService } from './nutrition.service';
import { Nutrition } from './nutrition.entity';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { CreateNutritionDto } from './dto/create-nutrition.dto';
import { Roles } from 'src/auth/roles.decorator';
import { RolesGuard } from 'src/auth/roles.guard';
import { Role } from 'src/user/role.enum';

@ApiTags('nutrition')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RolesGuard)
@Roles(Role.ADMIN)
@ApiResponse({ status: 403, description: 'only admin can use it  ' })
@Controller('nutrition')
export class NutritionController {
    constructor(private nutritionService: NutritionService) { }

    @Post()
    @ApiOperation({ summary: 'Create a new nutrition item' })
    @ApiBody({ type: CreateNutritionDto })
    @ApiResponse({ status: 201, description: 'Nutrition item created successfully' })
    @ApiResponse({ status: 400, description: 'Bad request' })
    async createNutrition(@Body() createNutritionDto: Partial<Nutrition>) {
        return await this.nutritionService.createNutrition(createNutritionDto);
    }

    @Get('all')
    @ApiOperation({ summary: 'Get all nutrition items' })
    @ApiResponse({ status: 200, description: 'List of all nutrition items' })
    async getAllNutrition() {
        return await this.nutritionService.getAllNutrition();
    }

    @Get(':name')
    @ApiOperation({ summary: 'Get nutrition item by name' })
    @ApiResponse({ status: 200, description: 'Nutrition item found' })
    @ApiResponse({ status: 404, description: 'Nutrition item not found' })
    @ApiBody({ type: String, description: 'Name of the nutrition item' })
    async getNutritionByName(@Body('name') name: string) {
        return await this.nutritionService.getNutritionByName(name);
    }

    @Patch(':name')
    @ApiOperation({ summary: 'Update nutrition item by name' })
    @ApiResponse({ status: 200, description: 'Nutrition item updated successfully' })
    @ApiResponse({ status: 404, description: 'Nutrition item not found' })
    @ApiBody({ type: CreateNutritionDto, description: 'Updated nutrition item data' })
    async updateNutrition(@Body('name') name: string, @Body() updateNutritionDto: Partial<Nutrition>) {
        return this.nutritionService.updateNutrition(name, updateNutritionDto);
    }

    @Delete(':name')
    @ApiOperation({ summary: 'Delete nutrition item by name' })
    @ApiResponse({ status: 200, description: 'Nutrition item deleted successfully' })
    @ApiResponse({ status: 404, description: 'Nutrition item not found' })
    async deleteNutrition(@Param('name') name: string): Promise<{ message: string }> {
        console.log('Deleting nutrition item with name:', name);
        const result = await this.nutritionService.deleteNutrition(name);
        console.log('Delete result:', result);
        if (!result){
            throw new NotFoundException(`Nutrition item with name "${name}" not found`);
        }
        return { message: `Nutrition item with name "${name}" deleted successfully` };
    }

    @Get('search')
    @ApiOperation({ summary: 'Search nutrition items by name' })
    @ApiQuery({ name: 'query', required: true, description: ' Name or part of the name to search for ' })
    async searchNutritionByName(@Body('query') query: string):Promise<Nutrition[]> {    
        if (!query) return this.nutritionService.getAllNutrition();
        return await this.nutritionService.searchNutritionByName(query);
    }
}
