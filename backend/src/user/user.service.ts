import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ILike, Repository } from 'typeorm';
import { User } from './user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { Role } from './role.enum';

// Export the interface so it can be used in the controller
export interface PaginatedResult<T> {
  items: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

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
    
    async getPaginatedUsers(
        page = 1,
        limit = 10,
        search?: string,
    ): Promise<PaginatedResult<User>> {
        const skip = (page - 1) * limit;
        
        // Set up search criteria if search term is provided
        const whereCondition = search
            ? [
                { firstName: ILike(`%${search}%`) },
                { lastName: ILike(`%${search}%`) },
                { email: ILike(`%${search}%`) },
              ]
            : {};
            
        const [users, total] = await this.userRepository.findAndCount({
            where: whereCondition,
            skip,
            take: limit,
            order: { id: 'ASC' },
        });
        
        const totalPages = Math.ceil(total / limit);
        
        return {
            items: users,
            total,
            page,
            limit,
            totalPages,
        };
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
    
    async updateUserRole(id: number, role: Role): Promise<User> {
        await this.userRepository.update(id, { role });
        return this.getUserById(id);
    }
    
    async updateUserDetails(id: number, userData: Partial<User>): Promise<User> {
        const user = await this.userRepository.findOne({ where: { id } });
        if (!user) {
            throw new NotFoundException(`User with ID ${id} not found`);
        }

        // Update user fields
        await this.userRepository.update(id, userData);
        
        // Return updated user
        return this.getUserById(id);
    }
      async deleteUser(id: number): Promise<User|null> {
        // Load the user with all relations to ensure it exists
        const user = await this.userRepository.findOne({
            where: { id },
            relations: ['subscriptions']
        });
        
        if (!user) {
            throw new NotFoundException(`User with ID ${id} not found`);
        }
        
        try {
            // First manually delete related records if needed
            // We rely on the cascade delete feature defined in entities
            
            // Use the simpler remove method which properly handles cascades
            // This is more reliable than the query builder for complex relationships
            await this.userRepository.remove(user);
            
            return user;
        } catch (error) {
            console.error(`Error deleting user: ${error.message}`);
            throw new Error(`Failed to delete user: ${error.message}`);
        }
    }

    async getProfile(id: number): Promise<User | null> {
        console.log(id);
        return await this.userRepository.findOne({ where: { id } });
    }
}
