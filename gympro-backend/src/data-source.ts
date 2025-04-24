import { DataSource } from 'typeorm';
import { User } from './user/user.entity'; 

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: 'localhost',
  port: 5432,
  username: 'postgres',
  password: 'mM112233445566!!',
  database: 'gympro_db',
  entities: [User],  // Add all your entity files
  synchronize: true, // Set to false in production
  logging: true,
});
