import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Nutrition } from './nutrition.entity';
import { Meal } from './meal.entity';

@Entity('meal_item') // Explicitly specifying the table name
export class MealItem {
  @PrimaryGeneratedColumn()
  id: number;
  
  @ManyToOne(() => Nutrition, { eager: true })
  @JoinColumn()
  nutrition: Nutrition;
  
  @Column()
  nutritionId: number;
  
  @Column({ default: 1 })
  quantity: number;
  
  @Column({ default: 'serving' })
  unit: string;
  
  @ManyToOne(() => Meal, meal => meal.items, { onDelete: 'CASCADE' })
  meal: Meal;
}