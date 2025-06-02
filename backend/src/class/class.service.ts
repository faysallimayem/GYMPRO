import { Injectable, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, MoreThanOrEqual, LessThanOrEqual } from 'typeorm';
import { GymClass, ClassType } from './class.entity';
import { CreateClassDto } from './dto/create-class.dto';
import { UpdateClassDto } from './dto/update-class.dto';
import { User } from '../user/user.entity';
import { Gym } from '../gym/gym.entity';

@Injectable()
export class ClassService {
  constructor(
    @InjectRepository(GymClass)
    private classRepository: Repository<GymClass>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(Gym)
    private gymRepository: Repository<Gym>,
  ) {}

  // Create a new gym class
  async create(createClassDto: CreateClassDto, userId?: string): Promise<GymClass> {
    console.log('Creating class with data:', JSON.stringify(createClassDto, null, 2));
    
    const newClass = this.classRepository.create({
      ...createClassDto,
      date: new Date(createClassDto.date),
    });

    // Set the gym if gymId is provided
    if (createClassDto.gymId) {
      const gym = await this.gymRepository.findOne({ where: { id: createClassDto.gymId } });
      if (!gym) {
        throw new NotFoundException(`Gym with ID ${createClassDto.gymId} not found`);
      }
      newClass.gym = gym;
    }
    
    // Set the creator if a userId is provided
    if (userId) {
      const user = await this.userRepository.findOne({ where: { id: parseInt(userId) } });
      if (user) {
        newClass.createdBy = user;
      }
    }

    try {
      const result = await this.classRepository.save(newClass);
      console.log('Class saved successfully:', JSON.stringify(result, null, 2));
      return result;
    } catch (error) {
      console.error('Error saving class:', error);
      throw error;
    }
  }

  // Get all gym classes with optional filters
  async findAll(date?: string, classType?: string): Promise<GymClass[]> {
    const queryBuilder = this.classRepository.createQueryBuilder('class')
      .leftJoinAndSelect('class.bookedUsers', 'bookedUsers');

    // Apply date filter if provided
    if (date) {
      const searchDate = new Date(date);
      // Reset hours to get just the date
      searchDate.setHours(0, 0, 0, 0);
      const nextDay = new Date(searchDate);
      nextDay.setDate(nextDay.getDate() + 1);
      
      queryBuilder.andWhere('class.date >= :startDate', { startDate: searchDate })
        .andWhere('class.date < :endDate', { endDate: nextDay });
    }

    // Apply class type filter if provided
    if (classType) {
      console.log(`Filtering by class type: ${classType}`);
      
      // Convert from frontend format if needed
      let mappedClassType = classType;
      if (classType === 'CARDIO') mappedClassType = ClassType.Cardio;
      if (classType === 'STRENGTH') mappedClassType = ClassType.Strength;
      if (classType === 'YOGA') mappedClassType = ClassType.Yoga;
      
      console.log(`Mapped class type: ${mappedClassType}`);
      
      // Only apply the filter if it's a valid enum value
      if (Object.values(ClassType).includes(mappedClassType as ClassType)) {
        queryBuilder.andWhere('class.classType = :classType', { classType: mappedClassType });
      } else {
        console.log(`Invalid class type: ${classType}, not applying filter`);
      }
    }

    // Order by date and start time
    queryBuilder.orderBy('class.date', 'ASC')
      .addOrderBy('class.startTime', 'ASC');

    return queryBuilder.getMany();
  }

  // Get a single gym class by ID
  async findOne(id: string): Promise<GymClass> {
    const gymClass = await this.classRepository.findOne({
      where: { id },
      relations: ['bookedUsers'],
    });

    if (!gymClass) {
      throw new NotFoundException(`Gym class with ID ${id} not found`);
    }

    return gymClass;
  }

  // Update a gym class
  async update(id: string, updateClassDto: UpdateClassDto): Promise<GymClass> {
    const gymClass = await this.findOne(id);

    // Handle date format conversion if date is provided
    if (updateClassDto.date) {
      updateClassDto.date = new Date(updateClassDto.date).toISOString();
    }

    // Check capacity against booked spots
    if (updateClassDto.capacity && updateClassDto.capacity < gymClass.bookedSpots) {
      throw new BadRequestException(
        `Cannot reduce capacity below current booked spots (${gymClass.bookedSpots})`,
      );
    }

    // Update the class properties
    Object.assign(gymClass, updateClassDto);

    return this.classRepository.save(gymClass);
  }

  // Delete a gym class
  async remove(id: string): Promise<void> {
    const result = await this.classRepository.delete(id);
    
    if (result.affected === 0) {
      throw new NotFoundException(`Gym class with ID ${id} not found`);
    }
  }

  // Book a class for a user
  async bookClass(classId: string, userId: string): Promise<GymClass> {
    const gymClass = await this.findOne(classId);
    const user = await this.userRepository.findOne({ where: { id: parseInt(userId) } });

    if (!user) {
      throw new NotFoundException(`User with ID ${userId} not found`);
    }

    // Check if the class is full
    if (gymClass.isFull) {
      throw new BadRequestException(`This class is full`);
    }

    // Check if user already booked this class
    const isAlreadyBooked = gymClass.bookedUsers.some(
      bookedUser => bookedUser.id === parseInt(userId)
    );

    if (isAlreadyBooked) {
      throw new ConflictException(`User already booked this class`);
    }

    // Add user to booked users
    gymClass.bookedUsers.push(user);
    gymClass.bookedSpots += 1;

    return this.classRepository.save(gymClass);
  }

  // Cancel a booking
  async cancelBooking(classId: string, userId: string): Promise<GymClass> {
    const gymClass = await this.findOne(classId);
    
    // Check if user has booked this class
    const userIndex = gymClass.bookedUsers.findIndex(
      bookedUser => bookedUser.id === parseInt(userId)
    );

    if (userIndex === -1) {
      throw new NotFoundException(`User has not booked this class`);
    }

    // Remove user from booked users
    gymClass.bookedUsers.splice(userIndex, 1);
    gymClass.bookedSpots -= 1;

    return this.classRepository.save(gymClass);
  }  // Get classes booked by a specific user
  async getUserBookings(userId: string): Promise<GymClass[]> {
    try {
      console.log(`Getting bookings for user with ID: ${userId}`);
      
      // Check if user exists
      const user = await this.userRepository.findOne({ 
        where: { id: parseInt(userId) }
      });

      if (!user) {
        throw new NotFoundException(`User with ID ${userId} not found`);
      }
      
      // Find classes where this user is in the bookedUsers list
      const classes = await this.classRepository
        .createQueryBuilder('class')
        .leftJoinAndSelect('class.bookedUsers', 'bookedUsers')
        .where('bookedUsers.id = :userId', { userId: parseInt(userId) })
        .orderBy('class.date', 'ASC')
        .addOrderBy('class.startTime', 'ASC')
        .getMany();
      
      console.log(`Found ${classes.length} bookings for user ID ${userId}`);
      
      // Return the classes as-is - frontend already knows these are the user's bookings
      return classes;
    } catch (error) {
      console.error('Error getting user bookings:', error);
      throw error;
    }
  }
}