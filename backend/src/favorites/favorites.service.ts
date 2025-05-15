import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { FavoriteExercise, FavoriteWorkout } from './favorite.entity';
import { User } from '../user/user.entity';
import { Exercise } from '../exercise/exercise.entity';
import { Workout } from '../workout/workout.entity';

@Injectable()
export class FavoritesService {
  constructor(
    @InjectRepository(FavoriteExercise)
    private favoriteExerciseRepository: Repository<FavoriteExercise>,
    @InjectRepository(FavoriteWorkout)
    private favoriteWorkoutRepository: Repository<FavoriteWorkout>,
    @InjectRepository(Exercise)
    private exerciseRepository: Repository<Exercise>,
    @InjectRepository(Workout)
    private workoutRepository: Repository<Workout>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  // Add an exercise to user's favorites
  async addFavoriteExercise(userId: number, exerciseId: number): Promise<FavoriteExercise> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException(`User with ID ${userId} not found`);
    }

    const exercise = await this.exerciseRepository.findOne({ where: { id: exerciseId } });
    if (!exercise) {
      throw new NotFoundException(`Exercise with ID ${exerciseId} not found`);
    }

    // Check if already a favorite
    const existingFavorite = await this.favoriteExerciseRepository.findOne({
      where: {
        user: { id: userId },
        exercise: { id: exerciseId },
      },
      relations: ['user', 'exercise'],
    });

    if (existingFavorite) {
      throw new ConflictException('This exercise is already in favorites');
    }

    const favorite = new FavoriteExercise();
    favorite.user = user;
    favorite.exercise = exercise;

    return this.favoriteExerciseRepository.save(favorite);
  }

  // Remove exercise from favorites
  async removeFavoriteExercise(userId: number, exerciseId: number): Promise<void> {
    const favorite = await this.favoriteExerciseRepository.findOne({
      where: {
        user: { id: userId },
        exercise: { id: exerciseId },
      },
      relations: ['user', 'exercise'],
    });

    if (!favorite) {
      throw new NotFoundException('Favorite exercise not found');
    }

    await this.favoriteExerciseRepository.remove(favorite);
  }

  // Get all favorite exercises for a user
  async getUserFavoriteExercises(userId: number): Promise<Exercise[]> {
    const favorites = await this.favoriteExerciseRepository.find({
      where: { user: { id: userId } },
      relations: ['exercise'],
    });

    return favorites.map(favorite => favorite.exercise);
  }

  // Add a workout to user's favorites
  async addFavoriteWorkout(userId: number, workoutId: number): Promise<FavoriteWorkout> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException(`User with ID ${userId} not found`);
    }

    const workout = await this.workoutRepository.findOne({ 
      where: { id: workoutId },
      relations: ['exercises'], // Include exercises to have complete data
    });
    if (!workout) {
      throw new NotFoundException(`Workout with ID ${workoutId} not found`);
    }

    // Check if already a favorite
    const existingFavorite = await this.favoriteWorkoutRepository.findOne({
      where: {
        user: { id: userId },
        workout: { id: workoutId },
      },
      relations: ['user', 'workout'],
    });

    if (existingFavorite) {
      throw new ConflictException('This workout is already in favorites');
    }

    const favorite = new FavoriteWorkout();
    favorite.user = user;
    favorite.workout = workout;

    return this.favoriteWorkoutRepository.save(favorite);
  }

  // Remove workout from favorites
  async removeFavoriteWorkout(userId: number, workoutId: number): Promise<void> {
    const favorite = await this.favoriteWorkoutRepository.findOne({
      where: {
        user: { id: userId },
        workout: { id: workoutId },
      },
      relations: ['user', 'workout'],
    });

    if (!favorite) {
      throw new NotFoundException('Favorite workout not found');
    }

    await this.favoriteWorkoutRepository.remove(favorite);
  }

  // Get all favorite workouts for a user
  async getUserFavoriteWorkouts(userId: number): Promise<Workout[]> {
    const favorites = await this.favoriteWorkoutRepository.find({
      where: { user: { id: userId } },
      relations: ['workout', 'workout.exercises'],
    });

    return favorites.map(favorite => favorite.workout);
  }
}