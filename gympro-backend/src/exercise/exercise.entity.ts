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

    @Column({default: 'beginner'})
    difficulty: 'beginner' | 'intermediate' | 'advanced';

    @Column({ nullable: true })
    videoUrl: string; 
     
    
    
}
