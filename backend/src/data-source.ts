import { DataSource } from 'typeorm';
import { User } from './user/user.entity'; 
import { Exercise } from './exercise/exercise.entity';
import { Workout } from './workout/workout.entity';
import { Nutrition } from './nutrition/nutrition.entity';
import { Supplement } from './supplement/supplement.entity';
import { Subscription } from './subscription/subscription.entity';
import { Message } from './chat/message.entity';
import { Conversation } from './chat/conversation.entity';
import { Meal } from './nutrition/meal.entity';
import { MealItem } from './nutrition/meal-item.entity';
import { GymClass } from './class/class.entity';
import { Gym } from './gym/gym.entity';
import { Tender } from './tender/tender.entity';
import { Offer } from './tender/offer.entity';


export const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  username: process.env.DB_USERNAME || 'postgres',
  password: process.env.DB_PASSWORD || 'faysallimayem123', 
  database: process.env.DB_NAME || 'gympro_db',
  entities: [User,Exercise,Workout,Nutrition,Supplement,Subscription,Message,Conversation,Meal,MealItem,GymClass,Gym,Tender,Offer],  // Add all your entity files
  synchronize: true, // Set to false in production
  logging: true,
});
