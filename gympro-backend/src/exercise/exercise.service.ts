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



}
