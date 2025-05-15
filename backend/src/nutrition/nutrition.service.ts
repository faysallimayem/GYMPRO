import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ILike, Not, Repository } from 'typeorm';
import { Nutrition } from './nutrition.entity';
import { Meal } from './meal.entity';
import { MealItem } from './meal-item.entity';
import { CreateMealDto } from './dto/create-meal.dto';
import { UpdateMealDto } from './dto/update-meal.dto';
import { CalculateNutritionDto } from './dto/nutrition-calculator.dto';

@Injectable()
export class NutritionService {
    constructor(
        @InjectRepository(Nutrition)
        private nutritionRepository: Repository<Nutrition>,
        @InjectRepository(Meal)
        private mealRepository: Repository<Meal>,
        @InjectRepository(MealItem)
        private mealItemRepository: Repository<MealItem>,
    ) {}

async createNutrition(createNutritionDto: Partial<Nutrition>): Promise<Nutrition> {
    const newNutrition = this.nutritionRepository.create(createNutritionDto);
    return await this.nutritionRepository.save(newNutrition);
}

async getAllNutrition(): Promise<Nutrition[]> {
    return await this.nutritionRepository.find();
}

async getNutritionByName(name: string): Promise<Nutrition | null> {
    return await this.nutritionRepository.findOne({ where: { name } });
}

async getNutritionByCategory(category: string): Promise<Nutrition[]> {
    return await this.nutritionRepository.find({ where: { category } });
}

async filterNutrition(
    category?: string, 
    minProtein?: number, 
    maxProtein?: number,
    minCalories?: number,
    maxCalories?: number
): Promise<Nutrition[]> {
    const query = this.nutritionRepository.createQueryBuilder('nutrition');
    
    if (category) {
        query.andWhere('nutrition.category = :category', { category });
    }
    
    if (minProtein !== undefined) {
        query.andWhere('nutrition.protein >= :minProtein', { minProtein });
    }
    
    if (maxProtein !== undefined) {
        query.andWhere('nutrition.protein <= :maxProtein', { maxProtein });
    }
    
    if (minCalories !== undefined) {
        query.andWhere('nutrition.calories >= :minCalories', { minCalories });
    }
    
    if (maxCalories !== undefined) {
        query.andWhere('nutrition.calories <= :maxCalories', { maxCalories });
    }
    
    return await query.getMany();
}

async updateNutrition(name: string, updateNutritionDto: Partial<Nutrition>): Promise<Nutrition | null> {
    const existingNutrition = await this.nutritionRepository.findOne({ where: { name } });
    if (!existingNutrition) throw new NotFoundException(`Nutrition with name ${name} not found`);
    Object.assign(existingNutrition, updateNutritionDto);
    return await this.nutritionRepository.save(existingNutrition);
}      

async deleteNutrition(name: string): Promise<{ message: string }> {
    const result = await this.nutritionRepository.delete({name});
    if (result.affected === 0) throw new NotFoundException(`Nutrition with name ${name} not found`);
    return {message: `Nutrition with id ${name} deleted successfully`};
}

async searchNutritionByName(query: string): Promise<Nutrition[]> {
    return await this.nutritionRepository.find({
        where: {
            name: ILike(`%${query}%`), 
        },
    });
}

async getAllCategories(): Promise<string[]> {
    const results = await this.nutritionRepository
        .createQueryBuilder('nutrition')
        .select('DISTINCT nutrition.category')
        .getRawMany();
    
    return results.map(result => result.category);
}

// Meal Creation System

async createMeal(createMealDto: CreateMealDto): Promise<Meal> {
    const meal = new Meal();
    meal.name = createMealDto.name;
    meal.description = createMealDto.description || null as any;
    meal.userId = createMealDto.userId || null as any;
    
    // First save the meal to get an ID
    const savedMeal = await this.mealRepository.save(meal);
    
    // Process each meal item
    if (createMealDto.items && createMealDto.items.length > 0) {
        const mealItems: MealItem[] = [];
        
        for (const itemDto of createMealDto.items) {
            const nutrition = await this.nutritionRepository.findOne({
                where: { id: itemDto.nutritionId }
            });
            
            if (!nutrition) {
                throw new NotFoundException(`Nutrition item with ID ${itemDto.nutritionId} not found`);
            }
            
            const mealItem = new MealItem();
            mealItem.nutritionId = nutrition.id;
            mealItem.nutrition = nutrition;
            mealItem.quantity = itemDto.quantity || 1;
            mealItem.unit = itemDto.unit || 'serving';
            mealItem.meal = savedMeal;
            
            mealItems.push(await this.mealItemRepository.save(mealItem));
        }
        
        savedMeal.items = mealItems;
        
        // Calculate meal nutrition totals
        await this.updateMealNutritionTotals(savedMeal.id);
    }
    
    return this.getMealById(savedMeal.id);
}

async getMealById(id: number): Promise<Meal> {
    const meal = await this.mealRepository.findOne({
        where: { id },
        relations: ['items', 'items.nutrition']
    });
    
    if (!meal) {
        throw new NotFoundException(`Meal with ID ${id} not found`);
    }
    
    return meal;
}

async getAllMeals(userId?: number): Promise<Meal[]> {
    const query = this.mealRepository.createQueryBuilder('meal')
        .leftJoinAndSelect('meal.items', 'items')
        .leftJoinAndSelect('items.nutrition', 'nutrition');
    
    if (userId) {
        query.where('meal.userId = :userId', { userId });
    }
    
    return await query.getMany();
}

async updateMeal(id: number, updateMealDto: UpdateMealDto): Promise<Meal> {
    const meal = await this.getMealById(id);
    
    if (updateMealDto.name) meal.name = updateMealDto.name;
    if (updateMealDto.description !== undefined) meal.description = updateMealDto.description;
    
    // Handle meal items if provided
    if (updateMealDto.items) {
        // Remove old meal items
        await this.mealItemRepository.delete({ meal: { id: meal.id } });
        
        // Add new meal items
        for (const itemDto of updateMealDto.items) {
            const nutrition = await this.nutritionRepository.findOne({
                where: { id: itemDto.nutritionId }
            });
            
            if (!nutrition) {
                throw new NotFoundException(`Nutrition item with ID ${itemDto.nutritionId} not found`);
            }
            
            const mealItem = new MealItem();
            mealItem.nutritionId = nutrition.id;
            mealItem.nutrition = nutrition;
            mealItem.quantity = itemDto.quantity || 1;
            mealItem.unit = itemDto.unit || 'serving';
            mealItem.meal = meal;
            
            await this.mealItemRepository.save(mealItem);
        }
    }
    
    await this.mealRepository.save(meal);
    await this.updateMealNutritionTotals(id);
    
    return this.getMealById(id);
}

async deleteMeal(id: number): Promise<{ message: string }> {
    const result = await this.mealRepository.delete(id);
    
    if (result.affected === 0) {
        throw new NotFoundException(`Meal with ID ${id} not found`);
    }
    
    return { message: `Meal with ID ${id} deleted successfully` };
}

private async updateMealNutritionTotals(mealId: number): Promise<void> {
    const meal = await this.mealRepository.findOne({
        where: { id: mealId },
        relations: ['items', 'items.nutrition']
    });
    
    if (!meal) {
        throw new NotFoundException(`Meal with ID ${mealId} not found`);
    }
    
    // Calculate totals
    let totalCalories = 0;
    let totalProtein = 0;
    let totalFat = 0;
    let totalCarbohydrates = 0;
    
    for (const item of meal.items) {
        totalCalories += item.nutrition.calories * item.quantity;
        totalProtein += item.nutrition.protein * item.quantity;
        totalFat += item.nutrition.fat * item.quantity;
        totalCarbohydrates += item.nutrition.carbohydrates * item.quantity;
    }
    
    // Update meal totals
    meal.totalCalories = totalCalories;
    meal.totalProtein = totalProtein;
    meal.totalFat = totalFat;
    meal.totalCarbohydrates = totalCarbohydrates;
    
    await this.mealRepository.save(meal);
}

// Nutrition Calculator

async calculateNutrition(calculateDto: CalculateNutritionDto): Promise<{
    totalCalories: number;
    totalProtein: number;
    totalFat: number;
    totalCarbohydrates: number;
    targetComparison?: {
        caloriePercentage?: number;
        proteinPercentage?: number;
        fatPercentage?: number;
        carbohydratesPercentage?: number;
    };
    items: Array<{
        nutrition: Nutrition;
        quantity: number;
        unit: string;
        itemCalories: number;
        itemProtein: number;
        itemFat: number;
        itemCarbohydrates: number;
    }>;
}> {
    let totalCalories = 0;
    let totalProtein = 0;
    let totalFat = 0;
    let totalCarbohydrates = 0;
    
    // Define the type for detailed items
    const detailedItems: Array<{
        nutrition: Nutrition;
        quantity: number;
        unit: string;
        itemCalories: number;
        itemProtein: number;
        itemFat: number;
        itemCarbohydrates: number;
    }> = [];
    
    // Calculate nutrition for each item
    for (const item of calculateDto.items) {
        const nutrition = await this.nutritionRepository.findOne({
            where: { id: item.nutritionId }
        });
        
        if (!nutrition) {
            throw new NotFoundException(`Nutrition with ID ${item.nutritionId} not found`);
        }
        
        const quantity = item.quantity || 1;
        const itemCalories = nutrition.calories * quantity;
        const itemProtein = nutrition.protein * quantity;
        const itemFat = nutrition.fat * quantity;
        const itemCarbohydrates = nutrition.carbohydrates * quantity;
        
        totalCalories += itemCalories;
        totalProtein += itemProtein;
        totalFat += itemFat;
        totalCarbohydrates += itemCarbohydrates;
        
        detailedItems.push({
            nutrition,
            quantity,
            unit: item.unit || 'serving',
            itemCalories,
            itemProtein,
            itemFat,
            itemCarbohydrates
        });
    }
    
    // Compare with targets if provided
    const targetComparison: {
        caloriePercentage?: number;
        proteinPercentage?: number;
        fatPercentage?: number;
        carbohydratesPercentage?: number;
    } = {};
    
    if (calculateDto.targetCalories) {
        targetComparison.caloriePercentage = (totalCalories / calculateDto.targetCalories) * 100;
    }
    
    if (calculateDto.targetProtein) {
        targetComparison.proteinPercentage = (totalProtein / calculateDto.targetProtein) * 100;
    }
    
    if (calculateDto.targetFat) {
        targetComparison.fatPercentage = (totalFat / calculateDto.targetFat) * 100;
    }
    
    if (calculateDto.targetCarbohydrates) {
        targetComparison.carbohydratesPercentage = (totalCarbohydrates / calculateDto.targetCarbohydrates) * 100;
    }
    
    return {
        totalCalories,
        totalProtein,
        totalFat,
        totalCarbohydrates,
        targetComparison: Object.keys(targetComparison).length ? targetComparison : undefined,
        items: detailedItems
    };
}

// Recommend nutrition items based on nutrition goals
async recommendNutrition(targetProtein?: number, targetCalories?: number): Promise<Nutrition[]> {
    const query = this.nutritionRepository.createQueryBuilder('nutrition');
    
    // Base ordering logic
    if (targetProtein && targetCalories) {
        // Prioritize items that help meet both protein and calorie targets
        query.orderBy('ABS(nutrition.protein - :targetProtein)', 'ASC')
            .addOrderBy('ABS(nutrition.calories - :targetCalories)', 'ASC')
            .setParameters({ targetProtein, targetCalories });
    } else if (targetProtein) {
        // Prioritize protein-rich items
        query.orderBy('nutrition.protein', 'DESC')
            .addOrderBy('nutrition.protein / nutrition.calories', 'DESC');  // Protein efficiency
    } else if (targetCalories) {
        // Prioritize balanced items for calorie target
        query.orderBy('ABS(nutrition.calories - :targetCalories)', 'ASC')
            .setParameters({ targetCalories });
    } else {
        // Default sorting for balanced nutrition
        query.orderBy('(nutrition.protein + nutrition.carbohydrates) / nutrition.calories', 'DESC');
    }
    
    // Limit to reasonable number of recommendations
    query.limit(10);
    
    return await query.getMany();
}

async getMealTemplates(): Promise<{ [key: string]: Nutrition[] }> {
    // Pre-defined meal templates for common scenarios
    const templates = {
        'Breakfast': await this.nutritionRepository.find({
            where: [
                { name: ILike('%oat%') },
                { name: ILike('%egg%') },
                { name: ILike('%yogurt%') },
                { name: ILike('%bread%') }
            ],
            take: 10
        }),
        'Pre-Workout': await this.nutritionRepository.find({
            where: [
                { name: ILike('%banana%') },
                { name: ILike('%oat%') },
                { name: ILike('%rice%') }
            ],
            take: 10
        }),
        'Post-Workout': await this.findNutritionByHighProtein(10),
        'Dinner': await this.nutritionRepository.find({
            where: [
                { name: ILike('%chicken%') },
                { name: ILike('%beef%') },
                { name: ILike('%fish%') },
                { name: ILike('%rice%') },
                { name: ILike('%potato%') }
            ],
            take: 10
        })
    };
    
    return templates;
}

private async findNutritionByHighProtein(limit: number): Promise<Nutrition[]> {
    return this.nutritionRepository.find({
        order: {
            protein: 'DESC'
        },
        take: limit
    });
}
}