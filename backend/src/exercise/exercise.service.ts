import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Exercise } from './exercise.entity';

@Injectable()
export class ExerciseService {
    constructor( 
        @InjectRepository(Exercise)
        private exerciseRepository: Repository<Exercise>,
    ) {}

    async createExercise(creatExerciseDto: Partial<Exercise>): Promise<Exercise> {
        const newExercise = this.exerciseRepository.create(creatExerciseDto);
        return await this.exerciseRepository.save(newExercise);
    }
    async getAllExercises(): Promise<Exercise[]> {
        return await this.exerciseRepository.find();
    }
    async getExerciseById(id: number): Promise<Exercise | null> {
        
        return await this.exerciseRepository.findOne({ where: { id } });
    }

    async deleteExercise(id: number): Promise<void> {
        await this.exerciseRepository.delete(id);
    }

    async getExercisesByMuscleGroup(muscleGroup: string): Promise<Exercise[]> {
        // Handle combined muscle groups like "chest-arms"
        if (muscleGroup.includes('-')) {
            const groups = muscleGroup.split('-');
            const exercisesPromises = groups.map(group => 
                this.exerciseRepository
                    .createQueryBuilder('exercise')
                    .where('LOWER(exercise.muscleGroup) LIKE LOWER(:muscleGroup)', { muscleGroup: `%${group.toLowerCase()}%` })
                    .getMany()
            );
            
            // Get exercises for all requested muscle groups
            const results = await Promise.all(exercisesPromises);
            
            // Flatten and remove duplicates
            const allExercises = results.flat();
            const uniqueExercises: Exercise[] = [];
            const exerciseNames = new Set<string>();
            
            for (const exercise of allExercises) {
                if (!exerciseNames.has(exercise.name.toLowerCase())) {
                    exerciseNames.add(exercise.name.toLowerCase());
                    uniqueExercises.push(exercise);
                }
            }
            
            return uniqueExercises;
        }
        
        // Handle single muscle group (existing logic)
        const allExercises = await this.exerciseRepository
            .createQueryBuilder('exercise')
            .where('LOWER(exercise.muscleGroup) LIKE LOWER(:muscleGroup)', { muscleGroup: `%${muscleGroup.toLowerCase()}%` })
            .getMany();
        
        // Filter out duplicates by name - keep only the first occurrence of each exercise name
        const uniqueExercises: Exercise[] = [];
        const exerciseNames = new Set<string>();
        
        for (const exercise of allExercises) {
            if (!exerciseNames.has(exercise.name.toLowerCase())) {
                exerciseNames.add(exercise.name.toLowerCase());
                uniqueExercises.push(exercise);
            }
        }
        
        return uniqueExercises;
    }

}
