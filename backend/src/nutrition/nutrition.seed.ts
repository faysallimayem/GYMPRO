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
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Eggs',
      protein: 13,
      calories: 155,
      fat: 11,
      carbohydrates: 1.1,
      imageUrl: 'https://images.unsplash.com/photo-1506976785307-8732e854ad03?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Turkey Breast',
      protein: 29,
      calories: 135,
      fat: 1,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1606728035253-49e8a23146de?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Cottage Cheese',
      protein: 11,
      calories: 82,
      fat: 2.3,
      carbohydrates: 3.4,
      imageUrl: 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Lean Beef',
      protein: 26,
      calories: 250,
      fat: 15,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1615937657715-bc7b4b7962fd?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Tuna (Canned)',
      protein: 25,
      calories: 110,
      fat: 1,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1580253092452-8431f7c25c4b?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Edamame',
      protein: 11,
      calories: 120,
      fat: 5,
      carbohydrates: 10,
      imageUrl: 'https://images.unsplash.com/photo-1621684553831-bc520d65c0a3?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Ground Turkey',
      protein: 22,
      calories: 170,
      fat: 9,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1615937691194-97dbd3f3dc29?q=80&w=500',
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
    {
      name: 'Whole Wheat Bread',
      protein: 4,
      calories: 81,
      fat: 1.1,
      carbohydrates: 13.8,
      imageUrl: 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?q=80&w=500',
      category: 'CarbSource'
    },
    {
      name: 'Lentils',
      protein: 9,
      calories: 116,
      fat: 0.4,
      carbohydrates: 20,
      imageUrl: 'https://images.unsplash.com/photo-1611575619251-93788739daa7?q=80&w=500',
      category: 'CarbSource'
    },
    {
      name: 'Chickpeas',
      protein: 8.9,
      calories: 164,
      fat: 2.6,
      carbohydrates: 27,
      imageUrl: 'https://images.unsplash.com/photo-1515543904379-3d757abe62bb?q=80&w=500',
      category: 'CarbSource'
    },
    {
      name: 'Pasta (Whole Wheat)',
      protein: 5.3,
      calories: 124,
      fat: 0.9,
      carbohydrates: 26.5,
      imageUrl: 'https://images.unsplash.com/photo-1551462147-37885acc36f1?q=80&w=500',
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
    {
      name: 'Walnuts',
      protein: 4.3,
      calories: 185,
      fat: 18.5,
      carbohydrates: 3.9,
      imageUrl: 'https://images.unsplash.com/photo-1596363202112-61843eef8e68?q=80&w=500',
      category: 'FatSource'
    },
    {
      name: 'Chia Seeds',
      protein: 4.4,
      calories: 137,
      fat: 8.6,
      carbohydrates: 11.9,
      imageUrl: 'https://images.unsplash.com/photo-1682011335200-c17b7f9a0522?q=80&w=500',
      category: 'FatSource'
    },
    {
      name: 'Flaxseeds',
      protein: 5.2,
      calories: 150,
      fat: 11.8,
      carbohydrates: 8.2,
      imageUrl: 'https://images.unsplash.com/photo-1615485925873-7ecad93bbe7f?q=80&w=500',
      category: 'FatSource'
    },
    {
      name: 'Coconut Oil',
      protein: 0,
      calories: 117,
      fat: 13.5,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1575386667256-47a95be97480?q=80&w=500',
      category: 'FatSource'
    },
    {
      name: 'Peanut Butter',
      protein: 8,
      calories: 190,
      fat: 16,
      carbohydrates: 7,
      imageUrl: 'https://images.unsplash.com/photo-1501012343570-2c8b775b1ce7?q=80&w=500',
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
    {
      name: 'Strawberries',
      protein: 0.7,
      calories: 32,
      fat: 0.3,
      carbohydrates: 7.7,
      imageUrl: 'https://images.unsplash.com/photo-1518635017498-87f514b751ba?q=80&w=500',
      category: 'Fruit'
    },
    {
      name: 'Orange',
      protein: 0.9,
      calories: 47,
      fat: 0.1,
      carbohydrates: 11.8,
      imageUrl: 'https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?q=80&w=500',
      category: 'Fruit'
    },
    {
      name: 'Mango',
      protein: 0.8,
      calories: 60,
      fat: 0.4,
      carbohydrates: 15,
      imageUrl: 'https://images.unsplash.com/photo-1553279768-5a06689a6154?q=80&w=500',
      category: 'Fruit'
    },
    {
      name: 'Pineapple',
      protein: 0.5,
      calories: 50,
      fat: 0.1,
      carbohydrates: 13.1,
      imageUrl: 'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?q=80&w=500',
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
    {
      name: 'Bell Pepper',
      protein: 0.9,
      calories: 20,
      fat: 0.2,
      carbohydrates: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?q=80&w=500',
      category: 'Vegetable'
    },
    {
      name: 'Carrots',
      protein: 0.9,
      calories: 41,
      fat: 0.2,
      carbohydrates: 9.6,
      imageUrl: 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?q=80&w=500',
      category: 'Vegetable'
    },
    {
      name: 'Asparagus',
      protein: 2.2,
      calories: 20,
      fat: 0.1,
      carbohydrates: 3.9,
      imageUrl: 'https://images.unsplash.com/photo-1558818261-43a6f4e09235?q=80&w=500',
      category: 'Vegetable'
    },
    {
      name: 'Zucchini',
      protein: 1.2,
      calories: 17,
      fat: 0.3,
      carbohydrates: 3.1,
      imageUrl: 'https://images.unsplash.com/photo-1589621316382-008455b857cd?q=80&w=500',
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
    {
      name: 'Feta Cheese',
      protein: 4,
      calories: 74,
      fat: 6,
      carbohydrates: 1.2,
      imageUrl: 'https://images.unsplash.com/photo-1626957341926-98752fc2ba90?q=80&w=500',
      category: 'Dairy'
    },
    {
      name: 'Butter',
      protein: 0.1,
      calories: 102,
      fat: 11.5,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?q=80&w=500',
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
    },
    {
      name: 'Black Coffee',
      protein: 0.3,
      calories: 2,
      fat: 0,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=500',
      category: 'Beverage'
    },
    {
      name: 'Orange Juice',
      protein: 0.7,
      calories: 45,
      fat: 0.2,
      carbohydrates: 10.4,
      imageUrl: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?q=80&w=500',
      category: 'Beverage'
    },
    
    // Grains and Cereals
    {
      name: 'Granola',
      protein: 4,
      calories: 120,
      fat: 6,
      carbohydrates: 15,
      imageUrl: 'https://images.unsplash.com/photo-1565887164384-0b748c9e4772?q=80&w=500',
      category: 'Grain'
    },
    {
      name: 'Cereal (Bran Flakes)',
      protein: 3,
      calories: 90,
      fat: 0.5,
      carbohydrates: 22,
      imageUrl: 'https://images.unsplash.com/photo-1557149559-d74af2cd12fa?q=80&w=500',
      category: 'Grain'
    },
    
    // Pre-workout Foods
    {
      name: 'Energy Bar',
      protein: 10,
      calories: 200,
      fat: 6,
      carbohydrates: 25,
      imageUrl: 'https://images.unsplash.com/photo-1571748982800-fa51082c2224?q=80&w=500',
      category: 'PreWorkout'
    },
    {
      name: 'BCAA Supplement',
      protein: 5,
      calories: 40,
      fat: 0,
      carbohydrates: 5,
      imageUrl: 'https://images.unsplash.com/photo-1506617420156-8e4536971650?q=80&w=500',
      category: 'PreWorkout'
    },
    
    // Supplements
    {
      name: 'Whey Protein Isolate',
      protein: 27,
      calories: 113,
      fat: 0.5,
      carbohydrates: 2,
      imageUrl: 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?q=80&w=500',
      category: 'Supplement'
    },
    {
      name: 'Creatine Monohydrate',
      protein: 0,
      calories: 5,
      fat: 0,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1466637574441-749b8f19452f?q=80&w=500',
      category: 'Supplement'
    },
    
    // Snacks
    {
      name: 'Hummus',
      protein: 4,
      calories: 70,
      fat: 5,
      carbohydrates: 6,
      imageUrl: 'https://images.unsplash.com/photo-1612343318802-b6dd8256d3cd?q=80&w=500',
      category: 'Snack'
    },
    {
      name: 'Quest Protein Bar',
      protein: 21,
      calories: 200,
      fat: 8,
      carbohydrates: 22,
      imageUrl: 'https://images.unsplash.com/photo-1593295956859-ae3d35bd1c7f?q=80&w=500',
      category: 'Snack'
    },
    {
      name: 'Rice Cakes',
      protein: 1,
      calories: 35,
      fat: 0,
      carbohydrates: 7,
      imageUrl: 'https://images.unsplash.com/photo-1559814048-149b70465756?q=80&w=500',
      category: 'Snack'
    },
    {
      name: 'Dark Chocolate (70%)',
      protein: 2,
      calories: 170,
      fat: 12,
      carbohydrates: 13,
      imageUrl: 'https://images.unsplash.com/photo-1614088685112-0223413062c1?q=80&w=500',
      category: 'Snack'
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

// Function to add new nutrition items without duplicating existing ones
async function addNewNutritionItems() {
  await AppDataSource.initialize();
  const nutritionRepo = AppDataSource.getRepository(Nutrition);
  
  // Define new nutrition items to add
  const newItems = [
    // More Protein Sources
    {
      name: 'Shrimp',
      protein: 24,
      calories: 99,
      fat: 0.3,
      carbohydrates: 0.2,
      imageUrl: 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Tilapia',
      protein: 26,
      calories: 128,
      fat: 3,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1594041680534-e8c8cdebd659?q=80&w=500',
      category: 'ProteinSource'
    },
    {
      name: 'Bison',
      protein: 28,
      calories: 143,
      fat: 2.4,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1628467679058-41e532afec94?q=80&w=500',
      category: 'ProteinSource'
    },
    
    // More Carb Sources
    {
      name: 'Black Beans',
      protein: 8.9,
      calories: 132,
      fat: 0.6,
      carbohydrates: 24,
      imageUrl: 'https://images.unsplash.com/photo-1595475207225-428b62bda831?q=80&w=500',
      category: 'CarbSource'
    },
    {
      name: 'Wild Rice',
      protein: 4,
      calories: 101,
      fat: 0.3,
      carbohydrates: 21,
      imageUrl: 'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?q=80&w=500',
      category: 'CarbSource'
    },
    {
      name: 'Couscous',
      protein: 3.8,
      calories: 112,
      fat: 0.2,
      carbohydrates: 23,
      imageUrl: 'https://images.unsplash.com/photo-1621236597179-a8764866d658?q=80&w=500',
      category: 'CarbSource'
    },
    
    // More Fat Sources
    {
      name: 'Macadamia Nuts',
      protein: 2.2,
      calories: 204,
      fat: 21.5,
      carbohydrates: 3.9,
      imageUrl: 'https://images.unsplash.com/photo-1616663394801-fd8ff45dc7e1?q=80&w=500',
      category: 'FatSource'
    },
    {
      name: 'Brazil Nuts',
      protein: 4.1,
      calories: 186,
      fat: 19,
      carbohydrates: 3.3,
      imageUrl: 'https://images.unsplash.com/photo-1573851552177-7e0b59718b3f?q=80&w=500',
      category: 'FatSource'
    },
    
    // More Fruits
    {
      name: 'Kiwi',
      protein: 1.1,
      calories: 61,
      fat: 0.5,
      carbohydrates: 14.7,
      imageUrl: 'https://images.unsplash.com/photo-1618897996318-5a901fa6ca71?q=80&w=500',
      category: 'Fruit'
    },
    {
      name: 'Watermelon',
      protein: 0.6,
      calories: 30,
      fat: 0.2,
      carbohydrates: 7.6,
      imageUrl: 'https://images.unsplash.com/photo-1589984662646-e7b2e4962f18?q=80&w=500',
      category: 'Fruit'
    },
    
    // More Vegetables
    {
      name: 'Brussels Sprouts',
      protein: 3.4,
      calories: 43,
      fat: 0.3,
      carbohydrates: 9,
      imageUrl: 'https://images.unsplash.com/photo-1572977438086-87bc97670e16?q=80&w=500',
      category: 'Vegetable'
    },
    {
      name: 'Cauliflower',
      protein: 1.9,
      calories: 25,
      fat: 0.3,
      carbohydrates: 5,
      imageUrl: 'https://images.unsplash.com/photo-1568584711271-6c929fb49b60?q=80&w=500',
      category: 'Vegetable'
    },
    
    // More Beverages
    {
      name: 'Coconut Water',
      protein: 0.7,
      calories: 46,
      fat: 0.5,
      carbohydrates: 9,
      imageUrl: 'https://images.unsplash.com/photo-1595231776515-ddffb1f4eb73?q=80&w=500',
      category: 'Beverage'
    },
    {
      name: 'Almond Milk',
      protein: 1.1,
      calories: 39,
      fat: 2.5,
      carbohydrates: 3.3,
      imageUrl: 'https://images.unsplash.com/photo-1600718374662-0483d2b9da44?q=80&w=500',
      category: 'Beverage'
    },
    
    // More Snacks
    {
      name: 'Greek Yogurt with Honey',
      protein: 15,
      calories: 180,
      fat: 5,
      carbohydrates: 20,
      imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=500',
      category: 'Snack'
    },
    {
      name: 'Beef Jerky',
      protein: 33,
      calories: 116,
      fat: 1.4,
      carbohydrates: 3.1,
      imageUrl: 'https://images.unsplash.com/photo-1504669676169-1939398108e2?q=80&w=500',
      category: 'Snack'
    },
    
    // More Supplements
    {
      name: 'Casein Protein',
      protein: 24,
      calories: 120,
      fat: 1.5,
      carbohydrates: 3,
      imageUrl: 'https://images.unsplash.com/photo-1616750819840-6242d02be50f?q=80&w=500',
      category: 'Supplement'
    },
    {
      name: 'Fish Oil Capsules',
      protein: 0,
      calories: 10,
      fat: 1,
      carbohydrates: 0,
      imageUrl: 'https://images.unsplash.com/photo-1577307890988-31d6ee784474?q=80&w=500',
      category: 'Supplement'
    },

    // Pre/Post Workout
    {
      name: 'Pre-Workout Supplement',
      protein: 0,
      calories: 5,
      fat: 0,
      carbohydrates: 1,
      imageUrl: 'https://images.unsplash.com/photo-1612532275214-e4ca76d0e4d1?q=80&w=500',
      category: 'PreWorkout'
    },
    {
      name: 'Post-Workout Recovery Drink',
      protein: 20,
      calories: 160,
      fat: 2,
      carbohydrates: 15,
      imageUrl: 'https://images.unsplash.com/photo-1567003778566-8bbe56ea4133?q=80&w=500',
      category: 'Supplement'
    }
  ];
  
  console.log('Checking for existing nutrition items before adding new ones...');
  
  // Add only new items that don't already exist (check by name)
  let addedCount = 0;
  for (const item of newItems) {
    const existingItem = await nutritionRepo.findOne({ where: { name: item.name } });
    if (!existingItem) {
      console.log(`Adding new nutrition item: ${item.name}`);
      await nutritionRepo.save(item);
      addedCount++;
    } else {
      console.log(`Skipping existing item: ${item.name}`);
    }
  }
  
  console.log(`Added ${addedCount} new nutrition items to the database.`);
  await AppDataSource.destroy();
  console.log('Nutrition update complete!');
}

// Execute this function if called with the 'update' argument
if (require.main === module && process.argv[2] === 'update') {
  addNewNutritionItems().catch((err) => {
    console.error('Nutrition update failed:', err);
    process.exit(1);
  });
}

// Export the seed function to be used in other files
export { seedNutrition, addNewNutritionItems };