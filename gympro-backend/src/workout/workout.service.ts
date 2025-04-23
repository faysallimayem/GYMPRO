import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Workout } from './workout.entity';
import { User } from 'src/user/user.entity';
import { CreateWorkoutDto } from './dto/create-workout.dto';

@Injectable()
export class WorkoutService {
    constructor(@InjectRepository(Workout)
    private workoutRepository: Repository<Workout>,
) {}

    async createWorkout(createWorkoutDto: CreateWorkoutDto, user:User): Promise<Workout> {
    const workout = this.workoutRepository.create({
        ...createWorkoutDto,
        createdBy: user,
    });
        
    return await this.workoutRepository.save(workout);
}

    async findAll(id:number): Promise<Workout[]> {
        return await this.workoutRepository.find({where: {createdBy: {id: id}}});
    }
}
