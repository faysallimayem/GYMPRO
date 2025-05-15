import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { User } from './user/user.entity';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserModule } from './user/user.module';
import { AuthModule } from './auth/auth.module';
import { ExerciseModule } from './exercise/exercise.module';
import { WorkoutModule } from './workout/workout.module';
import { Exercise } from './exercise/exercise.entity';
import { Workout } from './workout/workout.entity';
import { NutritionModule } from './nutrition/nutrition.module';
import { Nutrition } from './nutrition/nutrition.entity';
import { Meal } from './nutrition/meal.entity';
import { MealItem } from './nutrition/meal-item.entity';
import { FavoritesModule } from './favorites/favorites.module';
import { FavoriteExercise, FavoriteWorkout } from './favorites/favorite.entity';
import { SubscriptionModule } from './subscription/subscription.module';
import { Subscription } from './subscription/subscription.entity';
import { SupplementModule } from './supplement/supplement.module';
import { Supplement } from './supplement/supplement.entity';
import { ChatModule } from './chat/chat.module';
import { Conversation } from './chat/conversation.entity';
import { Message } from './chat/message.entity';
import { ClassModule } from './class/class.module';
import { GymClass } from './class/class.entity';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }), 
    TypeOrmModule.forRoot({
      type: 'postgres', 
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT || '5432'),
      username: process.env.DB_USERNAME || 'postgres',
      password: process.env.DB_PASSWORD || 'mM112233445566!!',
      database: process.env.DB_NAME || 'gympro_db',
      logging: true,
      entities: [
        User, 
        Exercise, 
        Workout, 
        Nutrition, 
        Meal, 
        MealItem, 
        Subscription, 
        Supplement, 
        Conversation, 
        Message, 
        FavoriteExercise, 
        FavoriteWorkout,
        GymClass
      ], 
      synchronize: true, 
    }), 
    UserModule, 
    AuthModule, 
    ExerciseModule, 
    WorkoutModule, 
    NutritionModule, 
    FavoritesModule, 
    SubscriptionModule, 
    SupplementModule, 
    ChatModule,
    ClassModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
