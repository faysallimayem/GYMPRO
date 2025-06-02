import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ILike, Repository, DataSource } from 'typeorm'; // Ensure ILike is imported
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
        private dataSource: DataSource
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
    }    async getPaginatedUsers(
        page = 1,
        limit = 10,
        search?: string,
        adminGymId?: number
    ): Promise<PaginatedResult<User>> {
        const skip = (page - 1) * limit;

        let finalWhereConditions: any[] = [];
        const searchSpecificConditions: any[] = [];

        // Add search conditions if search query is provided
        if (search) {
            searchSpecificConditions.push({ firstName: ILike(`%${search}%`) });
            searchSpecificConditions.push({ lastName: ILike(`%${search}%`) });
            searchSpecificConditions.push({ email: ILike(`%${search}%`) });
        }
        
        if (adminGymId) {
            // If admin has a gym, only show users belonging to that gym
            const gymCondition = { gym: { id: adminGymId } };
            if (searchSpecificConditions.length > 0) {
                finalWhereConditions = searchSpecificConditions.map(sc => ({ ...sc, ...gymCondition }));
            } else {
                finalWhereConditions.push(gymCondition);
            }
        } else {
            // If no gym specified, just use search conditions
            if (searchSpecificConditions.length > 0) {
                finalWhereConditions = searchSpecificConditions;
            }
        }

        const queryWhere = finalWhereConditions.length > 0 ? finalWhereConditions : {};

        try {
            const [items, total] = await this.userRepository.findAndCount({
                where: queryWhere,
                relations: ['gym', 'managedGym'], // Ensure 'gym' is loaded for filtering, 'managedGym' for admin context if needed
                skip,
                take: limit,
                order: {
                    id: 'DESC' // Order by newest first
                }
            });

            return {
                items,
                total,
                page,
                limit,
                totalPages: Math.ceil(total / limit),
            };
        } catch (error) {
            console.error('Error fetching paginated users:', error);
            throw error;
        }
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
            // Start a transaction for proper cleanup of related entities
            const queryRunner = this.dataSource.createQueryRunner();
            await queryRunner.connect();
            await queryRunner.startTransaction();
            
            try {
                // Delete access_log entries that reference this user first to resolve FK constraint
                await queryRunner.manager.query(
                    'DELETE FROM access_log WHERE user_id = $1',
                    [id]
                );
                
                // Delete related access codes that reference this user
                await queryRunner.manager.query(
                    'DELETE FROM access_code WHERE user_id = $1',
                    [id]
                );
                
                // Delete any class bookings for this user
                await queryRunner.manager.query(
                    'DELETE FROM class_bookings WHERE user_id = $1',
                    [id]
                );
                
                // Delete any subscriptions
                if (user.subscriptions && user.subscriptions.length > 0) {
                    await queryRunner.manager.query(
                        'DELETE FROM subscription WHERE "userId" = $1',
                        [id]
                    );
                }
                
                // Delete any offers made by this user
                await queryRunner.manager.query(
                    'DELETE FROM offer WHERE "userId" = $1',
                    [id]
                );
                
                // Delete any tenders created by this user
                await queryRunner.manager.query(
                    'DELETE FROM tender WHERE "adminId" = $1',
                    [id]
                );
                
                // Finally delete the user
                await queryRunner.manager.delete('user', { id });
                
                // Commit the transaction
                await queryRunner.commitTransaction();
                
                return user;
            } catch (error) {
                // Rollback in case of error
                await queryRunner.rollbackTransaction();
                console.error(`Error deleting user: ${error.message}`);
                throw new Error(`Failed to delete user: ${error.message}`);
            } finally {
                // Release the query runner
                await queryRunner.release();
            }
        } catch (error) {
            console.error(`Error deleting user: ${error.message}`);
            throw new Error(`Failed to delete user: ${error.message}`);
        }    }
    
    async getProfile(id: number): Promise<User | null> {
        console.log(`getProfile called with ID: ${id}, type: ${typeof id}`);
        
        try {
            if (isNaN(id) || id <= 0) {
                console.error(`Invalid user ID for getProfile: ${id}`);
                throw new NotFoundException(`Invalid user ID: ${id}`);
            }
            
            // Include both managedGym and gym relations
            const user = await this.userRepository.findOne({ 
                where: { id }, 
                relations: ['managedGym', 'gym'] 
            });
            
            if (!user) {
                console.error(`User with ID ${id} not found in getProfile`);
                throw new NotFoundException(`User with ID ${id} not found`);
            }
            
            console.log(`Successfully retrieved profile for user ID: ${id}`);
            return user;
        } catch (error) {
            console.error(`Error getting profile for user ${id}: ${error.message}`);
            throw error;
        }
    }

    async updateMembership(id: number, isGymMember: boolean, membershipExpiresAt?: Date): Promise<User> {
        // Find the user first to make sure they exist
        const user = await this.userRepository.findOne({ where: { id } });
        if (!user) {
            throw new NotFoundException(`User with ID ${id} not found`);
        }

        // Update membership details
        const updateData: Partial<User> = { isGymMember };
        
        // Only set the expiry date if provided
        if (membershipExpiresAt) {
            updateData.membershipExpiresAt = membershipExpiresAt;
        } else if (isGymMember && !user.membershipExpiresAt) {
            // Set default expiry to one year from now if becoming a member and no date provided
            const oneYearFromNow = new Date();
            oneYearFromNow.setFullYear(oneYearFromNow.getFullYear() + 1);
            updateData.membershipExpiresAt = oneYearFromNow;
        }

        console.log(`Updating user ${id} membership: isGymMember=${isGymMember}, expiresAt=${updateData.membershipExpiresAt}`);
        
        // Update the user
        await this.userRepository.update(id, updateData);
        
        // Return the updated user
        return this.getUserById(id);
    }

    async assignAdminToGym(adminId: number, gymId: number): Promise<User> {
        const admin = await this.userRepository.findOne({ where: { id: adminId }, relations: ['managedGym'] });
        if (!admin) throw new NotFoundException(`Admin with ID ${adminId} not found`);
        if (admin.role !== Role.ADMIN) throw new ConflictException('User is not an admin');
        admin.managedGym = { id: gymId } as any;
        return await this.userRepository.save(admin);
    }

    
}
