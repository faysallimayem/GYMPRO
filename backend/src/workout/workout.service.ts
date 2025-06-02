import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Workout } from './workout.entity';
import { User } from 'src/user/user.entity';
import { CreateWorkoutDto } from './dto/create-workout.dto';
import { UpdateWorkoutDto } from './dto/update-workout.dto';
import { Exercise } from 'src/exercise/exercise.entity';

@Injectable()
export class WorkoutService {
    constructor(
        @InjectRepository(Workout)
        private workoutRepository: Repository<Workout>,
        @InjectRepository(Exercise)
        private exerciseRepository: Repository<Exercise>
    ) {}

    async createWorkout(createWorkoutDto: CreateWorkoutDto, user: User): Promise<Workout> {
        const workout = this.workoutRepository.create({
            ...createWorkoutDto,
            createdBy: user,
        });
        
        if (createWorkoutDto.exercises && createWorkoutDto.exercises.length > 0) {
            const exercises = await Promise.all(
                createWorkoutDto.exercises.map(async (exerciseDto) => {
                    const exercise = await this.exerciseRepository.findOne({ 
                        where: { id: exerciseDto.id } 
                    });
                    
                    if (!exercise) {
                        throw new NotFoundException(`Exercise with ID ${exerciseDto.id} not found`);
                    }
                    
                    return exercise;
                })
            );
            
            workout.exercises = exercises;
        }
            
        return await this.workoutRepository.save(workout);
    }

    async findAll(): Promise<Workout[]> {
        return await this.workoutRepository.find({
            relations: ['exercises', 'createdBy']
        });
    }
    
    async findById(id: number): Promise<Workout> {
        const workout = await this.workoutRepository.findOne({
            where: { id },
            relations: ['exercises']
        });
        
        if (!workout) {
            throw new NotFoundException(`Workout with ID ${id} not found`);
        }
        
        return workout;
    }
    
    async createDefaultWorkouts(user: User): Promise<Workout[]> {
        // Check if user already has workouts
        const existingWorkouts = await this.findAll();
        if (existingWorkouts.length > 0) {
            return existingWorkouts;
        }
        
        // Get some exercises to add to workouts
        const exercises = await this.exerciseRepository.find({ take: 10 });
        
        if (exercises.length === 0) {
            // Create basic exercises if none exist
            const basicExercises = await this.createBasicExercises();
            exercises.push(...basicExercises);
        }
        
        // Create sample workouts
        const workouts: Workout[] = [];
        
        // Upper body workout
        const upperBodyWorkout = this.workoutRepository.create({
            name: 'Upper Body Blast',
            description: 'Complete upper body workout focusing on chest, shoulders, and arms',
            duration: 45,
            createdBy: user,
            exercises: exercises.filter(e => 
                ['chest', 'shoulders', 'arms', 'back'].includes(e.muscleGroup?.toLowerCase() || '')
            ).slice(0, 5)
        });
        workouts.push(await this.workoutRepository.save(upperBodyWorkout));
        
        // Lower body workout
        const lowerBodyWorkout = this.workoutRepository.create({
            name: 'Leg Day Challenge',
            description: 'Intense workout targeting quads, hamstrings, and calves',
            duration: 40,
            createdBy: user,
            exercises: exercises.filter(e => 
                ['legs', 'quads', 'hamstrings', 'calves'].includes(e.muscleGroup?.toLowerCase() || '')
            ).slice(0, 4)
        });
        workouts.push(await this.workoutRepository.save(lowerBodyWorkout));
        
        // Full body workout
        const fullBodyWorkout = this.workoutRepository.create({
            name: 'Full Body Complete',
            description: 'Comprehensive workout targeting all major muscle groups',
            duration: 60,
            createdBy: user,
            exercises: exercises.slice(0, Math.min(6, exercises.length))
        });
        workouts.push(await this.workoutRepository.save(fullBodyWorkout));
        
        return workouts;
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
                name: 'Squat',
                description: 'Fundamental lower body movement for quads and glutes',
                muscleGroup: 'legs',
                difficulty: 'beginner' as 'beginner' | 'intermediate' | 'advanced'
            },
            {
                name: 'Plank',
                description: 'Core stabilizing exercise',
                muscleGroup: 'core',
                difficulty: 'beginner' as 'beginner' | 'intermediate' | 'advanced'
            },
            {
                name: 'Bench Press',
                description: 'Major compound exercise for chest development',
                muscleGroup: 'chest',
                difficulty: 'intermediate' as 'beginner' | 'intermediate' | 'advanced'
            },
            {
                name: 'Deadlift',
                description: 'Compound movement for back and posterior chain',
                muscleGroup: 'back',
                difficulty: 'advanced' as 'beginner' | 'intermediate' | 'advanced'
            },
            {
                name: 'Shoulder Press',
                description: 'Overhead pressing movement for shoulder development',
                muscleGroup: 'shoulders',
                difficulty: 'intermediate' as 'beginner' | 'intermediate' | 'advanced'
            }
        ];
        
        const savedExercises: Exercise[] = [];
        
        for (const exerciseData of basicExercises) {
            const exercise = this.exerciseRepository.create(exerciseData);
            savedExercises.push(await this.exerciseRepository.save(exercise));
        }
        
        return savedExercises;
    }

    async updateWorkout(id: number, updateWorkoutDto: UpdateWorkoutDto, user: User): Promise<Workout> {
        const workout = await this.workoutRepository.findOne({
            where: { id },
            relations: ['createdBy', 'exercises'],
        });
        
        if (!workout) {
            throw new NotFoundException(`Workout with ID ${id} not found`);
        }
        
        // Verify ownership
        if (workout.createdBy.id !== user.id) {
            throw new ForbiddenException('You can only update your own workouts');
        }
        
        // Update basic fields if provided
        if (updateWorkoutDto.name) workout.name = updateWorkoutDto.name;
        if (updateWorkoutDto.description) workout.description = updateWorkoutDto.description;
        if (updateWorkoutDto.duration) workout.duration = updateWorkoutDto.duration;
        
        // Update exercises if provided
        if (updateWorkoutDto.exercises && updateWorkoutDto.exercises.length > 0) {
            const exercises = await Promise.all(
                updateWorkoutDto.exercises.map(async (exerciseDto) => {
                    const exercise = await this.exerciseRepository.findOne({ 
                        where: { id: exerciseDto.id } 
                    });
                    
                    if (!exercise) {
                        throw new NotFoundException(`Exercise with ID ${exerciseDto.id} not found`);
                    }
                    
                    return exercise;
                })
            );
            
            workout.exercises = exercises;
        }
        
        return await this.workoutRepository.save(workout);
    }
    
    async deleteWorkout(id: number, user: User): Promise<void> {
        const workout = await this.workoutRepository.findOne({
            where: { id },
            relations: ['createdBy'],
        });
        
        if (!workout) {
            throw new NotFoundException(`Workout with ID ${id} not found`);
        }
        
        // Verify ownership
        if (workout.createdBy.id !== user.id) {
            throw new ForbiddenException('You can only delete your own workouts');
        }
        
        await this.workoutRepository.remove(workout);
    }

    async findByMuscleGroup(muscleGroup: string): Promise<Workout[]> {
        return await this.workoutRepository.createQueryBuilder('workout')
            .innerJoinAndSelect('workout.exercises', 'exercise')
            .innerJoinAndSelect('workout.createdBy', 'user')
            .where('LOWER(exercise.muscleGroup) LIKE LOWER(:muscleGroup)', { muscleGroup: `%${muscleGroup}%` })
            .getMany();
    }

    private async createSampleWorkoutsForMuscleGroup(muscleGroup: string, user: User): Promise<Workout[]> {
        console.log(`Creating sample workouts for muscle group: ${muscleGroup}`);
        
        // Get or create exercises for the muscle group
        let exercises = await this.exerciseRepository.find({ 
            where: { 
                muscleGroup: muscleGroup.toLowerCase()
            }
        });
        
        // If no exercises found for this muscle group, create some
        if (exercises.length === 0) {
            exercises = await this.createSampleExercisesForMuscleGroup(muscleGroup);
        }
        
        // Create a workout for this muscle group
        const workout = this.workoutRepository.create({
            name: this.getWorkoutNameForMuscleGroup(muscleGroup),
            description: `A comprehensive ${muscleGroup} workout for all fitness levels`,
            duration: 45,
            createdBy: user,
            exercises: exercises
        });
        
        await this.workoutRepository.save(workout);
        return [workout];
    }
    
    private async createSampleExercisesForMuscleGroup(muscleGroup: string): Promise<Exercise[]> {
        const lowerMuscleGroup = muscleGroup.toLowerCase();
        const exercises: Exercise[] = [];
        
        if (lowerMuscleGroup.includes('chest')) {
            const chestExercises = [
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
                }
            ];
            
            for (const exerciseData of chestExercises) {
                const exercise = this.exerciseRepository.create(exerciseData);
                exercises.push(await this.exerciseRepository.save(exercise));
            }
        } else if (lowerMuscleGroup.includes('back')) {
            const backExercises = [
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
                }
            ];
            
            for (const exerciseData of backExercises) {
                const exercise = this.exerciseRepository.create(exerciseData);
                exercises.push(await this.exerciseRepository.save(exercise));
            }
        } else if (lowerMuscleGroup.includes('leg')) {
            const legExercises = [
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
                }
            ];
            
            for (const exerciseData of legExercises) {
                const exercise = this.exerciseRepository.create(exerciseData);
                exercises.push(await this.exerciseRepository.save(exercise));
            }
        } else {
            // For full body or other muscle groups
            const fullBodyExercises = [
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
                }
            ];
            
            for (const exerciseData of fullBodyExercises) {
                const exercise = this.exerciseRepository.create(exerciseData);
                exercises.push(await this.exerciseRepository.save(exercise));
            }
        }
        
        return exercises;
    }
    
    private getWorkoutNameForMuscleGroup(muscleGroup: string): string {
        const lowerMuscleGroup = muscleGroup.toLowerCase();
        
        if (lowerMuscleGroup.includes('chest')) {
            return 'Ultimate Chest & Arms Workout';
        } else if (lowerMuscleGroup.includes('back')) {
            return 'Back & Shoulders Blast';
        } else if (lowerMuscleGroup.includes('leg')) {
            return 'Legs & Core Power';
        } else {
            return 'Full Body Circuit';
        }
    }

    async createSampleWorkoutsForTesting(): Promise<Workout[]> {
        const exercises = await this.exerciseRepository.find();

        if (exercises.length === 0) {
            throw new Error('No exercises found. Please add exercises first.');
        }

        const sampleWorkouts: Workout[] = [];

        const workout1 = this.workoutRepository.create({
            name: 'Chest & Triceps Blast',
            description: 'A workout focusing on chest and triceps strength.',
            duration: 45,
            exercises: exercises.filter(e => e.muscleGroup === 'chest' || e.muscleGroup === 'triceps').slice(0, 4),
        });
        sampleWorkouts.push(await this.workoutRepository.save(workout1));

        const workout2 = this.workoutRepository.create({
            name: 'Leg Day Challenge',
            description: 'An intense workout targeting quads and hamstrings.',
            duration: 50,
            exercises: exercises.filter(e => e.muscleGroup === 'legs').slice(0, 4),
        });
        sampleWorkouts.push(await this.workoutRepository.save(workout2));

        const workout3 = this.workoutRepository.create({
            name: 'Full Body Circuit',
            description: 'A comprehensive workout for all major muscle groups.',
            duration: 60,
            exercises: exercises.slice(0, 6),
        });
        sampleWorkouts.push(await this.workoutRepository.save(workout3));

        return sampleWorkouts;
    }

    async getBasicWorkouts(): Promise<Workout[]> {
        // Return only a limited set of workouts with basic information for non-members
        return await this.workoutRepository.find({
            select: ['id', 'name', 'description', 'duration'],
            take: 5, // Limit to just a few workouts
            relations: ['exercises'],
        });
    }

    async getBasicWorkoutsByMuscleGroup(muscleGroup: string): Promise<Workout[]> {
        // Find workouts that include exercises for the specified muscle group
        // but limit the detail for non-members
        const workouts = await this.workoutRepository
            .createQueryBuilder('workout')
            .leftJoinAndSelect('workout.exercises', 'exercise')
            .where('exercise.muscleGroup = :muscleGroup', { muscleGroup })
            .select(['workout.id', 'workout.name', 'workout.description', 'workout.duration'])
            .take(3) // Limit to just a few workouts
            .getMany();
        
        return workouts;
    }
}
