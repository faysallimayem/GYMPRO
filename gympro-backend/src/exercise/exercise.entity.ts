import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Exercise {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    @Column({ nullable: true })
    description: string;

    @Column()
    muscleGroup: string;

    @Column({ nullable: true })
    videoUrl: string; 
    
    @Column({ default: 3 })
    defaultSets: number;
    
    @Column({ default: 12 })
    defaultReps: number;
    
    @Column({ nullable: true })
    imageUrl: string;
}
