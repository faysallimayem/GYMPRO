import { Module } from '@nestjs/common';
import { NutritionService } from './nutrition.service';
import { NutritionController } from './nutrition.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Nutrition } from './nutrition.entity';
import { Meal } from './meal.entity';
import { MealItem } from './meal-item.entity';

@Module({
  imports:[TypeOrmModule.forFeature([Nutrition, Meal, MealItem])],  
  providers: [NutritionService],
  controllers: [NutritionController]
})
export class NutritionModule {}
