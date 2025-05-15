import { Injectable, OnModuleInit, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../user/user.entity';
import { WorkoutService } from './workout.service';
import { Exercise } from '../exercise/exercise.entity';
import { Workout } from './workout.entity';

@Injectable()
export class WorkoutInitializationService implements OnModuleInit {
  private readonly logger = new Logger(WorkoutInitializationService.name);

  constructor(
    private readonly workoutService: WorkoutService,
    @InjectRepository(User) private readonly userRepository: Repository<User>,
    @InjectRepository(Exercise) private readonly exerciseRepository: Repository<Exercise>,
    @InjectRepository(Workout) private readonly workoutRepository: Repository<Workout>
  ) {}

  async onModuleInit() {
    this.logger.log('Initializing default workouts...');
    await this.initializeDefaultWorkouts();
  }

  async initializeDefaultWorkouts() {
    try {
      // Check if workouts already exist
      const workoutCount = await this.workoutRepository.count();
      if (workoutCount > 0) {
        this.logger.log(`${workoutCount} workouts already exist. Skipping initialization.`);
        return;
      }
      
      // Find any existing user to associate with the workouts
      const anyUser = await this.userRepository.findOne({});
      
      if (!anyUser) {
        this.logger.warn('No users found in the database. Cannot create workouts without a user.');
        return;
      }
      
      // Create default exercises if none exist
      let exercises = await this.exerciseRepository.find();
      if (exercises.length === 0) {
        exercises = await this.createBasicExercises();
      }
      
      // Create sample workouts
      const workouts: Workout[] = [];
      
      // Upper body workout
      const upperBodyExercises = exercises.filter(e => 
        ['chest', 'shoulders', 'arms', 'back'].includes(e.muscleGroup?.toLowerCase() || '')
      ).slice(0, 5);
      
      const upperBodyWorkout = this.workoutRepository.create({
        name: 'Upper Body Blast',
        description: 'Complete upper body workout focusing on chest, shoulders, and arms',
        duration: 45,
        createdBy: anyUser,
        exercises: upperBodyExercises
      });
      
      const savedUpperBody = await this.workoutRepository.save(upperBodyWorkout);
      workouts.push(savedUpperBody);
      
      // Lower body workout
      const lowerBodyExercises = exercises.filter(e => 
        ['legs', 'quads', 'hamstrings', 'calves'].includes(e.muscleGroup?.toLowerCase() || '')
      ).slice(0, 4);
      
      const lowerBodyWorkout = this.workoutRepository.create({
        name: 'Leg Day Challenge',
        description: 'Intense workout targeting quads, hamstrings, and calves',
        duration: 40,
        createdBy: anyUser,
        exercises: lowerBodyExercises
      });
      
      const savedLowerBody = await this.workoutRepository.save(lowerBodyWorkout);
      workouts.push(savedLowerBody);
      
      // Full body workout
      const fullBodyWorkout = this.workoutRepository.create({
        name: 'Full Body Complete',
        description: 'Comprehensive workout targeting all major muscle groups',
        duration: 60,
        createdBy: anyUser,
        exercises: exercises.slice(0, Math.min(6, exercises.length))
      });
      
      const savedFullBody = await this.workoutRepository.save(fullBodyWorkout);
      workouts.push(savedFullBody);
      
      // Back workout
      const backExercises = exercises.filter(e => 
        ['back', 'shoulders'].includes(e.muscleGroup?.toLowerCase() || '')
      ).slice(0, 4);
      
      const backWorkout = this.workoutRepository.create({
        name: 'Back & Shoulders Blast',
        description: 'Focused workout for building a stronger back and broader shoulders',
        duration: 50,
        createdBy: anyUser,
        exercises: backExercises
      });
      
      const savedBackWorkout = await this.workoutRepository.save(backWorkout);
      workouts.push(savedBackWorkout);
      
      this.logger.log(`Successfully created ${workouts.length} default workouts`);
      
    } catch (error) {
      this.logger.error(`Failed to initialize default workouts: ${error.message}`);
    }
  }
  
  private async createBasicExercises(): Promise<Exercise[]> {
    const basicExercises = [
      {
        name: 'Push-up',
        description: 'Classic bodyweight exercise for chest and triceps',
        muscleGroup: 'chest',
        difficulty: 'beginner' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Bench Press',
        description: 'Major compound exercise for chest development',
        muscleGroup: 'chest',
        difficulty: 'intermediate' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Incline Dumbbell Press',
        description: 'Upper chest focused pressing movement',
        muscleGroup: 'chest',
        difficulty: 'intermediate' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Squat',
        description: 'Fundamental lower body movement for quads and glutes',
        muscleGroup: 'legs',
        difficulty: 'intermediate' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Deadlift',
        description: 'Compound movement for posterior chain',
        muscleGroup: 'legs',
        difficulty: 'advanced' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Leg Press',
        description: 'Machine exercise targeting quadriceps',
        muscleGroup: 'legs',
        difficulty: 'beginner' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Pull-up',
        description: 'Upper body pulling exercise for back and biceps',
        muscleGroup: 'back',
        difficulty: 'intermediate' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Bent Over Row',
        description: 'Compound back exercise targeting middle back',
        muscleGroup: 'back',
        difficulty: 'intermediate' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Lat Pulldown',
        description: 'Machine exercise targeting latissimus dorsi',
        muscleGroup: 'back',
        difficulty: 'beginner' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Burpee',
        description: 'Full-body exercise combining squats, push-ups, and jumps',
        muscleGroup: 'full body',
        difficulty: 'intermediate' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Mountain Climber',
        description: 'Dynamic exercise engaging core, legs, and cardio',
        muscleGroup: 'full body',
        difficulty: 'beginner' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Kettlebell Swing',
        description: 'Dynamic exercise for posterior chain and cardio',
        muscleGroup: 'full body',
        difficulty: 'intermediate' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Shoulder Press',
        description: 'Overhead pressing movement for shoulder development',
        muscleGroup: 'shoulders',
        difficulty: 'intermediate' as 'beginner' | 'intermediate' | 'advanced'
      },
      {
        name: 'Plank',
        description: 'Core stabilizing exercise',
        muscleGroup: 'core',
        difficulty: 'beginner' as 'beginner' | 'intermediate' | 'advanced'
      }
    ];
    
    const savedExercises: Exercise[] = [];
    
    for (const exerciseData of basicExercises) {
      const exercise = this.exerciseRepository.create(exerciseData);
      savedExercises.push(await this.exerciseRepository.save(exercise));
    }
    
    return savedExercises;
  }
}