import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import { CreateUserDto } from './dto/create-user.dto';

@Injectable()
export class UserService {
    constructor(
        @InjectRepository(User) private userRepository: Repository<User>,
    ) {}

    async create(createUserDto: CreateUserDto): Promise<User> {
        const existingUser = await this.userRepository.findOne({ where: { email: createUserDto.email } });

        if (existingUser) {
            throw new ConflictException('This email is already registered.');
        }

        const user = this.userRepository.create(createUserDto);
        return await this.userRepository.save(user);

    }

    async getAllUsers(): Promise<User[]> {
        return await this.userRepository.find();
    }

    async getUserById(id: number): Promise<User> {
        try {
            return await this.userRepository.findOneOrFail({ where: { id } });
        } catch (error) {
            throw new NotFoundException(`User with ID ${id} not found`);
        }
    }

    async getByEmail(email: string): Promise<User | null> {
        return await this.userRepository.findOne({ where: { email } });
    }

    async updateUser(id: number, userData: Partial<User>): Promise<User> {
        await this.userRepository.update(id, userData);
        return this.getUserById(id);
    }

    async deleteUser(id: number): Promise<User|null> {
        const user = await this.userRepository.findOne({where:{id}});
        if (!user) {
            throw new NotFoundException(`User with ID ${id} not found`);
        }
        await this.userRepository.delete(user); 
        return user;
    }

    async getProfile(id: number): Promise<User | null> {
        console.log(id);
        return await this.userRepository.findOne({ where: { id } });
    }
}    
