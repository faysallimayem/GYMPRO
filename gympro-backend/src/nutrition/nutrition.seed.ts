import { DataSource } from 'typeorm';
import { Nutrition } from './nutrition.entity';
import { AppDataSource } from '../data-source';

async function seedNutrition() {
  await AppDataSource.initialize();
  const nutritionRepo = AppDataSource.getRepository(Nutrition);

  const nutritionItems = [
    // Protein Sources
    {
      name: 'Grilled Chicken Breast',
      protein: 31,
      calories: 165,
      fat: 3.6,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Salmon',
      protein: 25.4,
      calories: 208,
      fat: 12,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Greek Yogurt',
      protein: 10,
      calories: 59,
      fat: 0.4,
      carbohydrates: 3.6,
      imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Tofu',
      protein: 8,
      calories: 76,
      fat: 4.8,
      carbohydrates: 1.9,
      imageUrl: 'https://images.unsplash.com/photo-1604322329938-321e7716395a?q=80&w=500',
      category: 'ProteinSource'
    },
    
    // Carb Sources
    {
      name: 'Quinoa',
      protein: 4.4,
      calories: 120,
      fat: 1.9,
      carbohydrates: 21.3,
      imageUrl: 'https://images.unsplash.com/photo-1604152135912-04a022e23696?q=80&w=500',
      category: 'CarbSource'
    },
    {
      name: 'Brown Rice',
      protein: 2.6,
      calories: 112,
      fat: 0.9,
      carbohydrates: 23.5,
      imageUrl: 'https://images.unsplash.com/photo-1536304929831-ee1ca9d44906?q=80&w=500',
      category: 'CarbSource'
    },
    {
      name: 'Sweet Potato',
      protein: 1.6,
      calories: 86,
      fat: 0.1,
      carbohydrates: 20.1,
      imageUrl: 'https://images.unsplash.com/photo-1596097635121-14b8177be5b0?q=80&w=500',
      category: 'CarbSource'
    },
    {
      name: 'Oatmeal',
      protein: 2.4,
      calories: 68,
      fat: 1.4,
      carbohydrates: 12,
      imageUrl: 'https://images.unsplash.com/photo-1571748982798-7868d082432e?q=80&w=500',
      category: 'CarbSource'
    },
    
    // Fat Sources
    {
      name: 'Avocado',
      protein: 2,
      calories: 160,
      fat: 14.7,
      carbohydrates: 8.5,
      imageUrl: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=500',
      category: 'FatSource'
    },
    {
      name: 'Olive Oil',
      protein: 0,
      calories: 119,
      fat: 13.5,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?q=80&w=500',
      category: 'FatSource'
    },
    {
      name: 'Almonds',
      protein: 6,
      calories: 164,
      fat: 14,
      carbohydrates: 6.1,
      imageUrl: 'https://images.unsplash.com/photo-1508061125172-a4d2453a83ca?q=80&w=500',
      category: 'FatSource'
    },
    
    // Fruits
    {
      name: 'Apple',
      protein: 0.3,
      calories: 52,
      fat: 0.2,
      carbohydrates: 13.8,
      imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?q=80&w=500',
      category: 'Fruit'
    },
    {
      name: 'Banana',
      protein: 1.1,
      calories: 89,
      fat: 0.3,
      carbohydrates: 22.8,
      imageUrl: 'https://images.unsplash.com/photo-1603833665858-e61d17a86224?q=80&w=500',
      category: 'Fruit'
    },
    {
      name: 'Blueberries',
      protein: 0.7,
      calories: 57,
      fat: 0.3,
      carbohydrates: 14.5,
      imageUrl: 'https://images.unsplash.com/photo-1498557850523-fd3d118b962e?q=80&w=500',
      category: 'Fruit'
    },
    
    // Vegetables
    {
      name: 'Broccoli',
      protein: 2.8,
      calories: 34,
      fat: 0.4,
      carbohydrates: 6.6,
      imageUrl: 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?q=80&w=500',
      category: 'Vegetable'
    },
    {
      name: 'Spinach',
      protein: 2.9,
      calories: 23,
      fat: 0.4,
      carbohydrates: 3.6,
      imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?q=80&w=500',
      category: 'Vegetable'
    },
    {
      name: 'Kale',
      protein: 4.3,
      calories: 49,
      fat: 0.9,
      carbohydrates: 8.8,
      imageUrl: 'https://images.unsplash.com/photo-1600333859399-268c6b541756?q=80&w=500',
      category: 'Vegetable'
    },
    
    // Dairy
    {
      name: 'Milk (2%)',
      protein: 3.4,
      calories: 50,
      fat: 2,
      carbohydrates: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?q=80&w=500',
      category: 'Dairy'
    },
    {
      name: 'Cheddar Cheese',
      protein: 7,
      calories: 113,
      fat: 9.3,
      carbohydrates: 0.4,
      imageUrl: 'https://images.unsplash.com/photo-1552767059-ce182ead6c1b?q=80&w=500',
      category: 'Dairy'
    },
    
    // Beverages
    {
      name: 'Green Tea',
      protein: 0,
      calories: 2,
      fat: 0,
      carbohydrates: 0.5,
      imageUrl: 'https://images.unsplash.com/photo-1556881286-fc6915169721?q=80&w=500',
      category: 'Beverage'
    },
    {
      name: 'Protein Shake',
      protein: 25,
      calories: 150,
      fat: 2,
      carbohydrates: 5,
      imageUrl: 'https://images.unsplash.com/photo-1540075335095-f4b22670d0c0?q=80&w=500',
      category: 'Beverage'
    }
  ];

  // First check if we already have nutrition items
  const existingCount = await nutritionRepo.count();
  console.log(`Found ${existingCount} nutrition items in the database.`);

  if (existingCount > 0) {
    console.log('Nutrition items already exist. Skipping seeding to avoid duplicates.');
  } else {
    // Add all nutrition items
    for (const item of nutritionItems) {
      console.log(`Adding nutrition item: ${item.name}`);
      await nutritionRepo.save(item);
    }
    console.log(`Added ${nutritionItems.length} nutrition items to the database.`);
  }

  await AppDataSource.destroy();
  console.log('Nutrition seeding complete!');
}

// Execute the seed function if this file is run directly
if (require.main === module) {
  seedNutrition().catch((err) => {
    console.error('Nutrition seeding failed:', err);
    process.exit(1);
  });
}

// Export the seed function to be used in other files
export { seedNutrition };