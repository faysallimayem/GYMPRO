import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ILike, Repository } from 'typeorm';
import { Supplement } from './supplement.entity';

@Injectable()
export class SupplementService {
  constructor(
    @InjectRepository(Supplement)
    private readonly supplementRepository: Repository<Supplement>,
  ) {}

  async createSupplement(data: Partial<Supplement>): Promise<Supplement> {
    const supplement = this.supplementRepository.create(data);
    return this.supplementRepository.save(supplement);
  }

  async getAllSupplements(): Promise<Supplement[]> {
    return this.supplementRepository.find();
  }

  async getSupplementById(id: number): Promise<Supplement> {
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
}