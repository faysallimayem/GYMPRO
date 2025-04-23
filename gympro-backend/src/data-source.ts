import { DataSource } from 'typeorm';
import { User } from './user/user.entity'; 

export const AppDataSource = new DataSource({
  type: 'mysql',
  host: 'localhost',
  port: 3306,
  username: 'root',
  password: 'Faysallimayem123!',
  database: 'gympro_db',
  entities: [User],  // Add all your entity files
  synchronize: true, // Set to false in production
  logging: true,
});
