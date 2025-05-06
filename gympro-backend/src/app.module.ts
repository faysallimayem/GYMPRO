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
import { FavoritesModule } from './favorites/favorites.module';
import { FavoriteExercise, FavoriteWorkout } from './favorites/favorite.entity';
import { Meal } from './nutrition/meal.entity';
import { MealItem } from './nutrition/meal-item.entity';


@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }), 
    TypeOrmModule.forRoot({
      type: 'postgres', 
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT ?? '5432', 10),
      username: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD || 'mM112233445566!!',
      database: process.env.DB_NAME || 'gympro_db',
      entities: [User, Exercise, Workout, Nutrition, FavoriteExercise, FavoriteWorkout, Meal, MealItem], 
      synchronize: true, 
    }), UserModule, AuthModule, ExerciseModule, WorkoutModule, NutritionModule, FavoritesModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
