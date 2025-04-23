import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ILike, Not, Repository } from 'typeorm';
import { Nutrition } from './nutrition.entity';


@Injectable()
export class NutritionService {
    constructor(
        @InjectRepository(Nutrition)
        private nutritionRepository: Repository<Nutrition>,
    ) {}


async createNutrition(createNutritionDto: Partial<Nutrition>): Promise<Nutrition> {
    const newNutrition = this.nutritionRepository.create(createNutritionDto);
    return await this.nutritionRepository.save(newNutrition);
}

async getAllNutrition(): Promise<Nutrition[]> {
    return await this.nutritionRepository.find();
}

async getNutritionByName(name: string): Promise<Nutrition | null> {
    return await this.nutritionRepository.findOne({ where: { name } });

}


async updateNutrition(name: string, updateNutritionDto: Partial<Nutrition>): Promise<Nutrition | null> {
    const existingNutrition = await this.nutritionRepository.findOne({ where: { name } });
    if (!existingNutrition) throw new NotFoundException(`Nutrition with name ${name} not found`);
    Object.assign(existingNutrition, updateNutritionDto);
    return await this.nutritionRepository.save(existingNutrition);
}      

async deleteNutrition(name: string): Promise<{ message: string }> {
    const result = await this.nutritionRepository.delete({name});
    if (result.affected === 0) throw new NotFoundException(`Nutrition with name ${name} not found`);
    return {message: `Nutrition with id ${name} deleted successfully`};
}

async searchNutritionByName(query: string): Promise<Nutrition[]> {
    return await this.nutritionRepository.find({
        where: {
            name: ILike('%${query}%'), 
        },
    });
}






}