import { Entity, PrimaryGeneratedColumn, Column, ManyToMany, JoinTable, ManyToOne, JoinColumn } from 'typeorm';
import { Exercise } from '../exercise/exercise.entity';
import { User } from 'src/user/user.entity';
@Entity()
export class Workout {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    @Column({ nullable: true })
    description: string;

    @ManyToMany(() => Exercise)
    @JoinTable()
    exercises: Exercise[];

    @ManyToOne(() => User)
    @JoinColumn({ name:'createdBy'})
    createdBy: User;

    @Column({ nullable: true })
    duration: number; 
}