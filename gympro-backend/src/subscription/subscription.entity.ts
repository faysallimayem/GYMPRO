import {Entity, Column, PrimaryGeneratedColumn, ManyToOne, CreateDateColumn, UpdateDateColumn} from 'typeorm';
import { User } from 'src/user/user.entity';

@Entity('subscription')
export class Subscription {
    @PrimaryGeneratedColumn()
    id: number;

    @ManyToOne(() => User, (user) => user.subscriptions, { onDelete: 'CASCADE' })
    user: User; 

    @Column()
    planName: string;

    @Column('decimal', { precision: 10, scale: 2 })
    price: number;

    @Column()
    durationInDays: number;

    @Column({default: 'active'})
    status: string;
    
    @CreateDateColumn()
    startDate: Date;

    @Column({ nullable: true })
    endDate: Date;

   
}