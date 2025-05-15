import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, ManyToMany, JoinTable, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { User } from '../user/user.entity';

// Class types enum - values must match exactly with database
export enum ClassType {
  // The string values are what gets saved in the database
  Cardio = 'Cardio',
  Strength = 'Strength',
  Yoga = 'Yoga'
}

@Entity('classes')
export class GymClass {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  className: string;

  @Column()
  startTime: string;

  @Column()
  endTime: string;

  @Column()
  instructor: string;

  @Column({ nullable: true })
  instructorImageUrl: string;

  @Column()
  duration: number;

  @Column()
  capacity: number;

  @Column({ default: 0 })
  bookedSpots: number;

  @Column({
    type: 'enum',
    enum: ClassType,
    default: ClassType.Cardio
  })
  classType: ClassType;

  @Column({ type: 'date' })
  date: Date;

  @ManyToOne(() => User, { nullable: true })
  createdBy: User;

  @ManyToMany(() => User)
  @JoinTable({
    name: 'class_bookings',
    joinColumn: { name: 'class_id', referencedColumnName: 'id' },
    inverseJoinColumn: { name: 'user_id', referencedColumnName: 'id' }
  })
  bookedUsers: User[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  // Helper methods
  get spotsLeft(): number {
    return this.capacity - this.bookedSpots;
  }

  get isFull(): boolean {
    return this.spotsLeft <= 0;
  }
} 