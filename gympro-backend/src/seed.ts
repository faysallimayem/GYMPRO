import { DataSource } from 'typeorm';
import { Exercise } from './exercise/exercise.entity';
import { AppDataSource } from './data-source';
import { seedNutrition } from './nutrition/nutrition.seed';

async function seedExercises() {
  await AppDataSource.initialize();
  const exerciseRepo = AppDataSource.getRepository(Exercise);

  const improvedExercises = [
    // Chest
    { 
      name: 'Push-up', 
      description: 'Classic bodyweight exercise for chest and triceps', 
      muscleGroup: 'chest',
      defaultSets: 3,
      defaultReps: 15,
      imageUrl: '/assets/images/img_rectangle_188.png'
    },
    { 
      name: 'Bench Press', 
      description: 'Major compound exercise for chest development', 
      muscleGroup: 'chest',
      defaultSets: 4,
      defaultReps: 10,
      imageUrl: '/assets/images/img_rectangle_188.png'
    },
    { 
      name: 'Incline Dumbbell Press', 
      description: 'Upper chest focused pressing movement', 
      muscleGroup: 'chest',
      defaultSets: 3,
      defaultReps: 12,
      imageUrl: '/assets/images/img_rectangle_188.png'
    },
    // Back
    { 
      name: 'Pull-up', 
      description: 'Upper body pulling exercise for back and biceps', 
      muscleGroup: 'back',
      defaultSets: 3,
      defaultReps: 8,
      imageUrl: '/assets/images/img_rectangle_194.png'
    },
    { 
      name: 'Bent Over Row', 
      description: 'Compound back exercise targeting middle back', 
      muscleGroup: 'back',
      defaultSets: 4,
      defaultReps: 12,
      imageUrl: '/assets/images/img_rectangle_194.png'
    },
    { 
      name: 'Lat Pulldown', 
      description: 'Machine exercise targeting latissimus dorsi', 
      muscleGroup: 'back',
      defaultSets: 3,
      defaultReps: 12,
      imageUrl: '/assets/images/img_rectangle_194.png'
    },
    // Legs
    { 
      name: 'Squat', 
      description: 'Fundamental lower body movement for quads and glutes', 
      muscleGroup: 'legs',
      defaultSets: 4,
      defaultReps: 8,
      imageUrl: '/assets/images/img_rectangle_190.png'
    },
    { 
      name: 'Deadlift', 
      description: 'Compound movement for posterior chain', 
      muscleGroup: 'legs',
      defaultSets: 4,
      defaultReps: 6,
      imageUrl: '/assets/images/img_rectangle_190.png'
    },
    { 
      name: 'Leg Press', 
      description: 'Machine exercise targeting quadriceps', 
      muscleGroup: 'legs',
      defaultSets: 3,
      defaultReps: 12,
      imageUrl: '/assets/images/img_rectangle_190.png'
    },
    // Shoulders
    { 
      name: 'Shoulder Press', 
      description: 'Overhead pressing movement for shoulder development', 
      muscleGroup: 'shoulders',
      defaultSets: 3,
      defaultReps: 10,
      imageUrl: '/assets/images/img_rectangle_194.png'
    },
    { 
      name: 'Lateral Raise', 
      description: 'Isolation exercise for lateral deltoids', 
      muscleGroup: 'shoulders',
      defaultSets: 3,
      defaultReps: 15,
      imageUrl: '/assets/images/img_rectangle_194.png'
    },
    { 
      name: 'Front Raise', 
      description: 'Targeted exercise for anterior deltoids', 
      muscleGroup: 'shoulders',
      defaultSets: 3,
      defaultReps: 12,
      imageUrl: '/assets/images/img_rectangle_194.png'
    },
    // Arms
    { 
      name: 'Bicep Curl', 
      description: 'Isolation exercise for biceps', 
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 12,
      imageUrl: '/assets/images/img_rectangle_188.png'
    },
    { 
      name: 'Tricep Dip', 
      description: 'Bodyweight exercise for triceps', 
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 10,
      imageUrl: '/assets/images/img_rectangle_188.png'
    },
    { 
      name: 'Hammer Curl', 
      description: 'Variation of bicep curl targeting brachialis and forearms', 
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 12,
      imageUrl: '/assets/images/img_rectangle_188.png'
    },
    // Core
    { 
      name: 'Plank', 
      description: 'Core stabilizing exercise', 
      muscleGroup: 'core',
      defaultSets: 3,
      defaultReps: 30, // seconds
      imageUrl: '/assets/images/img_rectangle_190.png'
    },
    { 
      name: 'Crunch', 
      description: 'Abdominal isolation exercise', 
      muscleGroup: 'core',
      defaultSets: 3,
      defaultReps: 20,
      imageUrl: '/assets/images/img_rectangle_190.png'
    },
    { 
      name: 'Russian Twist', 
      description: 'Rotational exercise for obliques', 
      muscleGroup: 'core',
      defaultSets: 3,
      defaultReps: 16,
      imageUrl: '/assets/images/img_rectangle_190.png'
    },
    // Full Body
    { 
      name: 'Burpee', 
      description: 'Full-body exercise combining squats, push-ups, and jumps', 
      muscleGroup: 'full body',
      defaultSets: 3,
      defaultReps: 15,
      imageUrl: '/assets/images/img_rectangle_192.png'
    },
    { 
      name: 'Mountain Climber', 
      description: 'Dynamic exercise engaging core, legs, and cardio', 
      muscleGroup: 'full body',
      defaultSets: 3,
      defaultReps: 20,
      imageUrl: '/assets/images/img_rectangle_192.png'
    },
    { 
      name: 'Kettlebell Swing', 
      description: 'Dynamic exercise for posterior chain and cardio', 
      muscleGroup: 'full body',
      defaultSets: 3,
      defaultReps: 15,
      imageUrl: '/assets/images/img_rectangle_192.png'
    },
  ];

  // First get all existing exercises
  const allExercises = await exerciseRepo.find();
  console.log(`Found ${allExercises.length} exercises in the database.`);
  
  // Update existing exercises with improved data based on the seed
  for (const existingExercise of allExercises) {
    // Find a matching improved exercise based on name and muscle group
    const improvedData = improvedExercises.find(
      e => e.name.toLowerCase() === existingExercise.name.toLowerCase() ||
      (e.muscleGroup === existingExercise.muscleGroup && 
        (existingExercise.name.includes('Exercise') || e.name.includes(existingExercise.name)))
    );

    // If we found a matching improved exercise
    if (improvedData) {
      console.log(`Updating exercise: ${existingExercise.name} -> ${improvedData.name}`);
      
      // Update all fields with the improved data
      existingExercise.name = improvedData.name;
      existingExercise.description = improvedData.description;
      existingExercise.defaultSets = improvedData.defaultSets;
      existingExercise.defaultReps = improvedData.defaultReps;
      existingExercise.imageUrl = improvedData.imageUrl;
      
      await exerciseRepo.save(existingExercise);
    } else {
      // If no matching improved exercise was found, set an imageUrl based on muscle group
      if (!existingExercise.imageUrl) {
        const muscleGroup = existingExercise.muscleGroup.toLowerCase();
        if (muscleGroup.includes('chest') || muscleGroup.includes('arm')) {
          existingExercise.imageUrl = '/assets/images/img_rectangle_188.png';
        } else if (muscleGroup.includes('leg') || muscleGroup.includes('core')) {
          existingExercise.imageUrl = '/assets/images/img_rectangle_190.png';
        } else if (muscleGroup.includes('back') || muscleGroup.includes('shoulder')) {
          existingExercise.imageUrl = '/assets/images/img_rectangle_194.png';
        } else if (muscleGroup.includes('full')) {
          existingExercise.imageUrl = '/assets/images/img_rectangle_192.png';
        } else {
          existingExercise.imageUrl = '/assets/images/img_image_84x98.png';
        }
        console.log(`Setting image for ${existingExercise.name} based on muscle group ${existingExercise.muscleGroup}`);
        await exerciseRepo.save(existingExercise);
      }
    }
  }

  // Add any missing exercises from the improved data
  for (const improvedExercise of improvedExercises) {
    const exists = await exerciseRepo.findOne({ 
      where: { name: improvedExercise.name }
    });
    
    if (!exists) {
      console.log(`Adding new exercise: ${improvedExercise.name}`);
      await exerciseRepo.save(improvedExercise);
    }
  }

  await AppDataSource.destroy();
  console.log('Exercise seeding complete!');
}

async function seedAll() {
  console.log('Starting complete database seeding...');
  
  try {
    // Seed exercises
    await seedExercises();
    
    // Seed nutrition items
    await seedNutrition();
    
    console.log('All seeding operations completed successfully!');
  } catch (error) {
    console.error('Error during seeding:', error);
    process.exit(1);
  }
}

// Check if this file is being run directly
if (require.main === module) {
  // If no specific arguments are passed, seed everything
  if (process.argv.length <= 2) {
    seedAll().catch((err) => {
      console.error('Seeding failed:', err);
      process.exit(1);
    });
  } 
  // If "exercises" argument is passed, only seed exercises
  else if (process.argv[2] === 'exercises') {
    seedExercises().catch((err) => {
      console.error('Exercise seeding failed:', err);
      process.exit(1);
    });
  }
  // If "nutrition" argument is passed, only seed nutrition
  else if (process.argv[2] === 'nutrition') {
    seedNutrition().catch((err) => {
      console.error('Nutrition seeding failed:', err);
      process.exit(1);
    });
  }
  else {
    console.log('Invalid argument. Use "exercises" or "nutrition" to seed specific data, or no argument to seed all.');
    process.exit(1);
  }
}

// Export the seed functions
export { seedExercises, seedNutrition, seedAll };