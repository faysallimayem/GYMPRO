import { DataSource } from 'typeorm';
import { User } from './user/user.entity'; 
import { Workout } from './workout/workout.entity';
import { Exercise } from './exercise/exercise.entity';
import { Nutrition } from './nutrition/nutrition.entity';
import { Meal } from './nutrition/meal.entity';
import { MealItem } from './nutrition/meal-item.entity';

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: 'localhost',
  port: 5432,
  username: 'postgres',
  password: 'mM112233445566!!', // Updated password to match the one used in the PostgreSQL server
  database: 'gympro_db',
  entities: [User, Workout, Exercise, Nutrition, Meal, MealItem],  // Add all your entity files
  synchronize: true, // Set to false in production
  logging: true,
});
