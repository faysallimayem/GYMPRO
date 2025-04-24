import { Entity, PrimaryGeneratedColumn, Column, TableInheritance } from 'typeorm';
import { Role } from './role.enum';

@Entity('user') 
 
export class User {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    nom: string;

    @Column()
    prenom: string;

    @Column({ unique: true })
    email: string;

    @Column()
    mot_de_passe: string;

    @Column()
    age: number;

    @Column({nullable: true })
    hauteur: number;

    @Column({nullable: true })
    poids: number;

    @Column({})
    sexe: string;

    @Column({
        type: 'enum',
        enum: Role,
        default: Role.CLIENT, 
        nullable: false,
    })
    role: Role;
}
