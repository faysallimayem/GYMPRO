import { Entity, PrimaryGeneratedColumn, Column, TableInheritance, OneToMany } from 'typeorm';
import { Role } from './role.enum';
import { Subscription } from '../subscription/subscription.entity';

@Entity('user') 
 
export class User {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({ name: 'nom' })
    lastName: string;

    @Column({ name: 'prenom' })
    firstName: string;

    @Column({ unique: true })
    email: string;

    @Column({ name: 'mot_de_passe' })
    password: string;

    @Column({nullable: true})
    age: number;

    @Column({ name: 'hauteur', nullable: true })
    height: number;

    @Column({ name: 'poids', nullable: true })
    weight: number;

    @Column({ name: 'sexe' })
    gender: string;    @OneToMany(() => Subscription, (subscription) => subscription.user, {
        cascade: true,
        onDelete: 'CASCADE'
    })
    subscriptions: Subscription[];

    @Column({
        type: 'enum',
        enum: Role,
        default: Role.CLIENT, 
        nullable: false,
    })
    role: Role;
}
