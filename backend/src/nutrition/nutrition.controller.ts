import { Controller, Get, Post, Put, Patch, Delete, Body, Param, Query, ParseIntPipe, UseGuards, HttpException, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { NutritionService } from './nutrition.service';
import { Nutrition } from './nutrition.entity';
import { Meal } from './meal.entity';
import { CreateMealDto } from './dto/create-meal.dto';
import { UpdateMealDto } from './dto/update-meal.dto';
import { AuthGuard } from '@nestjs/passport/dist/auth.guard';
import { RolesGuard } from 'src/auth/roles.guard';

@ApiTags('nutrition')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RolesGuard)
@Controller('nutrition')
export class NutritionController {
  constructor(private readonly nutritionService: NutritionService) {}

  @Get()
  @ApiOperation({ summary: 'Get all nutrition items' })
  async getAllNutritionItems(): Promise<Nutrition[]> {
    return this.nutritionService.getAllNutrition();
  }

  @Get('category/:category')
  @ApiOperation({ summary: 'Get nutrition items by category' })
  @ApiResponse({ status: 200, description: 'Return all nutrition items for a specific category' })
  async getNutritionItemsByCategory(
    @Param('category') category: string
  ): Promise<Nutrition[]> {
    return this.nutritionService.getNutritionByCategory(category);
  }
  @Get('search/:term')
  @ApiOperation({ summary: 'Search nutrition items' })
  @ApiResponse({ status: 200, description: 'Return nutrition items matching search term' })
  async searchNutritionItems(
    @Param('term') searchTerm: string
  ): Promise<Nutrition[]> {
    return this.nutritionService.searchNutritionByName(searchTerm);
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
  async getAllCategories(): Promise<string[]> {
    return this.nutritionService.getAllCategories();
  }

  // Meal endpoints
  @Post('meals')
  @ApiOperation({ summary: 'Create a new meal' })
  @ApiResponse({ status: 201, description: 'Meal has been created successfully' })
  async createMeal(@Body() createMealDto: CreateMealDto): Promise<Meal> {
    try {
      return await this.nutritionService.createMeal(createMealDto);
    } catch (error) {
      throw new HttpException(
        {
          message: 'Failed to create meal',
          error: error.message,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('meals')
  @ApiOperation({ summary: 'Get all meals' })
  @ApiResponse({ status: 200, description: 'Return all meals' })
  async getAllMeals(@Query('userId') userId?: number): Promise<Meal[]> {
    return this.nutritionService.getAllMeals(userId);
  }

  @Get('meals/:id')
  @ApiOperation({ summary: 'Get meal by id' })
  @ApiResponse({ status: 200, description: 'Return the meal' })
  @ApiResponse({ status: 404, description: 'Meal not found' })
  async getMealById(@Param('id', ParseIntPipe) id: number): Promise<Meal> {
    return this.nutritionService.getMealById(id);
  }

  @Patch('meals/:id')
  @ApiOperation({ summary: 'Update a meal' })
  @ApiResponse({ status: 200, description: 'Meal has been updated successfully' })
  async updateMeal(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateMealDto: UpdateMealDto,
  ): Promise<Meal> {
    return this.nutritionService.updateMeal(id, updateMealDto);
  }
  @Delete('meals/:id')
  @ApiOperation({ summary: 'Delete a meal' })
  @ApiResponse({ status: 200, description: 'Meal has been deleted successfully' })
  async deleteMeal(@Param('id', ParseIntPipe) id: number): Promise<any> {
    return this.nutritionService.deleteMeal(id);
  }

  @Get('meal-templates')
  @ApiOperation({ summary: 'Get meal templates' })
  @ApiResponse({ status: 200, description: 'Return meal templates' })
  async getMealTemplates(): Promise<any> {
    try {
      // Create meal templates using categories
      const templates = {
        'Breakfast': await this.nutritionService.getNutritionByCategory('CarbSource'),
        'Lunch': await this.nutritionService.getNutritionByCategory('ProteinSource'),
        'Dinner': await this.nutritionService.getNutritionByCategory('FatSource'),
        'Snack': await this.nutritionService.getNutritionByCategory('Fruit')
      };
      
      // Filter out any null values (in case some nutrition items weren't found)
      Object.keys(templates).forEach(key => {
        templates[key] = templates[key].filter(item => item !== null);
      });
      
      return templates;
    } catch (error) {
      throw new HttpException(
        {
          message: 'Failed to fetch meal templates',
          error: error.message,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
    
  @Get(':name')
  @ApiOperation({ summary: 'Get nutrition item by name' })
  @ApiResponse({ status: 404, description: 'Nutrition item not found' })
  async getNutritionItemByName(
    @Param('name') name: string
  ): Promise<Nutrition | null> {
    return this.nutritionService.getNutritionByName(name);
  }
}