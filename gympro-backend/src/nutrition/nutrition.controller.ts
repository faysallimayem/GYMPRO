import { Body, Controller, Delete, Get, NotFoundException, Param, ParseIntPipe, Patch, Post, Query, UseGuards, HttpException, HttpStatus } from '@nestjs/common';
import { NutritionService } from './nutrition.service';
import { Nutrition } from './nutrition.entity';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiParam, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { CreateNutritionDto } from './dto/create-nutrition.dto';
import { Roles } from 'src/auth/roles.decorator';
import { RolesGuard } from 'src/auth/roles.guard';
import { Role } from 'src/user/role.enum';
import { seedNutrition } from './nutrition.seed';
import { CreateMealDto } from './dto/create-meal.dto';
import { UpdateMealDto } from './dto/update-meal.dto';
import { CalculateNutritionDto } from './dto/nutrition-calculator.dto';

@ApiTags('nutrition')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RolesGuard)
@Controller('nutrition')
export class NutritionController {
    constructor(private nutritionService: NutritionService) { }

    @Post()
    @Roles(Role.ADMIN)
    @ApiOperation({ summary: 'Create a new nutrition item' })
    @ApiBody({ type: CreateNutritionDto })
    @ApiResponse({ status: 201, description: 'Nutrition item created successfully' })
    @ApiResponse({ status: 400, description: 'Bad request' })
    @ApiResponse({ status: 403, description: 'Only admin can use it' })
    async createNutrition(@Body() createNutritionDto: Partial<Nutrition>) {
        return await this.nutritionService.createNutrition(createNutritionDto);
    }

    @Post('seed')
    @Roles(Role.ADMIN)
    @ApiOperation({ summary: 'Seed nutrition data with sample items' })
    @ApiResponse({ status: 201, description: 'Nutrition data seeded successfully' })
    @ApiResponse({ status: 403, description: 'Only admin can use it' })
    async seedNutritionData() {
        try {
            await seedNutrition();
            return { message: 'Nutrition data seeded successfully' };
        } catch (error) {
            throw new Error(`Failed to seed nutrition data: ${error.message}`);
        }
    }

    @Get('all')
    @ApiOperation({ summary: 'Get all nutrition items' })
    @ApiResponse({ status: 200, description: 'List of all nutrition items' })
    async getAllNutrition() {
        try {
            const nutritionItems = await this.nutritionService.getAllNutrition();
            return nutritionItems;
        } catch (error) {
            throw new HttpException(
                {
                    message: 'Failed to fetch nutrition items',
                    error: error.message,
                },
                HttpStatus.INTERNAL_SERVER_ERROR,
            );
        }
    }

    @Get('categories')
    @ApiOperation({ summary: 'Get all nutrition categories' })
    @ApiResponse({ status: 200, description: 'List of all nutrition categories' })
    async getAllCategories() {
        return await this.nutritionService.getAllCategories();
    }

    @Get('category/:category')
    @ApiOperation({ summary: 'Get nutrition items by category' })
    @ApiParam({ name: 'category', required: true, description: 'Category of nutrition items' })
    @ApiResponse({ status: 200, description: 'List of nutrition items in category' })
    async getNutritionByCategory(@Param('category') category: string) {
        return await this.nutritionService.getNutritionByCategory(category);
    }

    @Get('filter')
    @ApiOperation({ summary: 'Filter nutrition items by various criteria' })
    @ApiQuery({ name: 'category', required: false, description: 'Category to filter by' })
    @ApiQuery({ name: 'minProtein', required: false, description: 'Minimum protein content' })
    @ApiQuery({ name: 'maxProtein', required: false, description: 'Maximum protein content' })
    @ApiQuery({ name: 'minCalories', required: false, description: 'Minimum calorie content' })
    @ApiQuery({ name: 'maxCalories', required: false, description: 'Maximum calorie content' })
    @ApiResponse({ status: 200, description: 'List of filtered nutrition items' })
    async filterNutrition(
        @Query('category') category?: string,
        @Query('minProtein') minProtein?: number,
        @Query('maxProtein') maxProtein?: number,
        @Query('minCalories') minCalories?: number,
        @Query('maxCalories') maxCalories?: number
    ) {
        return await this.nutritionService.filterNutrition(
            category,
            minProtein,
            maxProtein,
            minCalories,
            maxCalories
        );
    }
    
    @Get('search')
    @ApiOperation({ summary: 'Search nutrition items by name' })
    @ApiQuery({ name: 'query', required: true, description: 'Name or part of the name to search for' })
    @ApiResponse({ status: 200, description: 'List of matching nutrition items' })
    async searchNutritionByName(@Query('query') query: string): Promise<Nutrition[]> {    
        if (!query) return this.nutritionService.getAllNutrition();
        return await this.nutritionService.searchNutritionByName(query);
    }

    // Meal Creation System Endpoints

    @Post('meals')
    @ApiOperation({ summary: 'Create a new meal' })
    @ApiBody({ type: CreateMealDto })
    @ApiResponse({ status: 201, description: 'Meal created successfully' })
    @ApiResponse({ status: 400, description: 'Bad request' })
    async createMeal(@Body() createMealDto: CreateMealDto) {
        return await this.nutritionService.createMeal(createMealDto);
    }

    @Get('meals')
    @ApiOperation({ summary: 'Get all meals' })
    @ApiQuery({ name: 'userId', required: false, description: 'Filter meals by user ID' })
    @ApiResponse({ status: 200, description: 'List of all meals' })
    async getAllMeals(@Query('userId') userId?: number) {
        return await this.nutritionService.getAllMeals(userId);
    }

    @Get('meals/:id')
    @ApiOperation({ summary: 'Get meal by ID' })
    @ApiParam({ name: 'id', description: 'ID of the meal' })
    @ApiResponse({ status: 200, description: 'Meal found' })
    @ApiResponse({ status: 404, description: 'Meal not found' })
    async getMealById(@Param('id', ParseIntPipe) id: number) {
        return await this.nutritionService.getMealById(id);
    }

    @Get('meal-templates')
    @ApiOperation({ summary: 'Get predefined meal templates' })
    @ApiResponse({ status: 200, description: 'Meal templates retrieved' })
    async getMealTemplates() {
        return await this.nutritionService.getMealTemplates();
    }

    // Nutrition Calculator Endpoints

    @Post('calculate')
    @ApiOperation({ summary: 'Calculate nutrition information for a set of items' })
    @ApiBody({ type: CalculateNutritionDto })
    @ApiResponse({ status: 200, description: 'Nutrition calculation completed' })
    @ApiResponse({ status: 400, description: 'Bad request' })
    async calculateNutrition(@Body() calculateDto: CalculateNutritionDto) {
        return await this.nutritionService.calculateNutrition(calculateDto);
    }

    @Get('recommend')
    @ApiOperation({ summary: 'Get nutrition recommendations based on targets' })
    @ApiQuery({ name: 'targetProtein', required: false, description: 'Target protein amount in grams' })
    @ApiQuery({ name: 'targetCalories', required: false, description: 'Target calories amount' })
    @ApiResponse({ status: 200, description: 'Nutrition recommendations retrieved' })
    async recommendNutrition(
        @Query('targetProtein') targetProtein?: number,
        @Query('targetCalories') targetCalories?: number
    ) {
        return await this.nutritionService.recommendNutrition(targetProtein, targetCalories);
    }

    @Get(':name')
    @ApiOperation({ summary: 'Get nutrition item by name' })
    @ApiResponse({ status: 200, description: 'Nutrition item found' })
    @ApiResponse({ status: 404, description: 'Nutrition item not found' })
    @ApiParam({ name: 'name', description: 'Name of the nutrition item' })
    async getNutritionByName(@Param('name') name: string) {
        const result = await this.nutritionService.getNutritionByName(name);
        if (!result) {
            throw new NotFoundException(`Nutrition item with name "${name}" not found`);
        }
        return result;
    }

    @Patch(':name')
    @Roles(Role.ADMIN)
    @ApiOperation({ summary: 'Update nutrition item by name' })
    @ApiResponse({ status: 200, description: 'Nutrition item updated successfully' })
    @ApiResponse({ status: 404, description: 'Nutrition item not found' })
    @ApiResponse({ status: 403, description: 'Only admin can use it' })
    @ApiParam({ name: 'name', description: 'Name of the nutrition item to update' })
    @ApiBody({ type: CreateNutritionDto, description: 'Updated nutrition item data' })
    async updateNutrition(@Param('name') name: string, @Body() updateNutritionDto: Partial<Nutrition>) {
        return this.nutritionService.updateNutrition(name, updateNutritionDto);
    }

    @Delete(':name')
    @Roles(Role.ADMIN)
    @ApiOperation({ summary: 'Delete nutrition item by name' })
    @ApiResponse({ status: 200, description: 'Nutrition item deleted successfully' })
    @ApiResponse({ status: 404, description: 'Nutrition item not found' })
    @ApiResponse({ status: 403, description: 'Only admin can use it' })
    @ApiParam({ name: 'name', description: 'Name of the nutrition item to delete' })
    async deleteNutrition(@Param('name') name: string): Promise<{ message: string }> {
        const result = await this.nutritionService.deleteNutrition(name);
        if (!result){
            throw new NotFoundException(`Nutrition item with name "${name}" not found`);
        }
        return { message: `Nutrition item with name "${name}" deleted successfully` };
    }

    @Patch('meals/:id')
    @ApiOperation({ summary: 'Update meal by ID' })
    @ApiParam({ name: 'id', description: 'ID of the meal to update' })
    @ApiBody({ type: UpdateMealDto })
    @ApiResponse({ status: 200, description: 'Meal updated successfully' })
    @ApiResponse({ status: 404, description: 'Meal not found' })
    async updateMeal(
        @Param('id', ParseIntPipe) id: number,
        @Body() updateMealDto: UpdateMealDto
    ) {
        return await this.nutritionService.updateMeal(id, updateMealDto);
    }

    @Delete('meals/:id')
    @ApiOperation({ summary: 'Delete meal by ID' })
    @ApiParam({ name: 'id', description: 'ID of the meal to delete' })
    @ApiResponse({ status: 200, description: 'Meal deleted successfully' })
    @ApiResponse({ status: 404, description: 'Meal not found' })
    async deleteMeal(@Param('id', ParseIntPipe) id: number) {
        return await this.nutritionService.deleteMeal(id);
    }
}
