import { Entity, PrimaryGeneratedColumn, Column, OneToMany, JoinColumn } from 'typeorm';
import { MealItem } from './meal-item.entity';

@Entity()
export class Meal {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;
  
  @Column({ nullable: true })
  description: string;
  
  @Column({ type: 'float', default: 0 })
  totalCalories: number;
  
  @Column({ type: 'float', default: 0 })
  totalProtein: number;
  
  @Column({ type: 'float', default: 0 })
  totalFat: number;
  
  @Column({ type: 'float', default: 0 })
  totalCarbohydrates: number;
  
  @Column({ default: () => 'CURRENT_TIMESTAMP' })
  createdAt: Date;
  
  @Column({ nullable: true })
  userId: number;
  
  @OneToMany(() => MealItem, mealItem => mealItem.meal, { 
    cascade: true,
    eager: true 
  })
  items: MealItem[];
}