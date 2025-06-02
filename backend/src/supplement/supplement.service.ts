import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ILike, Repository } from 'typeorm';
import { Supplement } from './supplement.entity';
import { Gym } from '../gym/gym.entity';

@Injectable()
export class SupplementService {
  constructor(
    @InjectRepository(Supplement)
    private readonly supplementRepository: Repository<Supplement>,
    @InjectRepository(Gym)
    private readonly gymRepository: Repository<Gym>,
  ) {}

  async createSupplement(data: Partial<Supplement> & { gymId: number }): Promise<Supplement> {
    const gym = await this.gymRepository.findOne({ where: { id: data.gymId } });
    if (!gym) throw new NotFoundException('Gym not found');
    const supplement = this.supplementRepository.create({ ...data, gym });
    return this.supplementRepository.save(supplement);
  }

  async getAllSupplements(): Promise<Supplement[]> {
    return this.supplementRepository.find();
  }

  async getSupplementById(id: number): Promise<Supplement> {
    if (!id || isNaN(Number(id))) {
      throw new NotFoundException('Invalid supplement ID');
    }
    const supplement = await this.supplementRepository.findOne({ where: { id } });
    if (!supplement) {
      throw new NotFoundException(`Supplement with ID ${id} not found`);
    }
    return supplement;
  }

  async searchSupplementsByName(name: string): Promise<Supplement[]> {
    return this.supplementRepository.find({ where: { name: ILike(`%${name}%`) } });

  }  

  async updateSupplement(id: number, data: Partial<Supplement>): Promise<Supplement> {
    const supplement = await this.getSupplementById(id);
    Object.assign(supplement, data);
    return this.supplementRepository.save(supplement);
  }

  async deleteSupplement(id: number): Promise<void> {
    const result = await this.supplementRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Supplement with ID ${id} not found`);
    }
  }

  async getSupplementsByGymId(gymId: number): Promise<Supplement[]> {
    return this.supplementRepository.find({ where: { gym: { id: gymId } }, relations: ['gym'] });
  }
}