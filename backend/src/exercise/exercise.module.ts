import { Module } from '@nestjs/common';
import { ExerciseService } from './exercise.service';
import { ExerciseController } from './exercise.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Exercise } from './exercise.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Exercise])],
  providers: [ExerciseService],
  controllers: [ExerciseController],
  exports: [ExerciseService, TypeOrmModule.forFeature([Exercise])],
}) 
export class ExerciseModule {}
