import { Module } from '@nestjs/common';
import { NutritionService } from './nutrition.service';
import { NutritionController } from './nutrition.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Nutrition } from './nutrition.entity';

@Module({
  imports:[TypeOrmModule.forFeature([Nutrition])],  
  providers: [NutritionService],
  controllers: [NutritionController]
})
export class NutritionModule {}
