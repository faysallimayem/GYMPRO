// This is a simple script to trigger the nutrition seed update
require('ts-node/register');
require('./src/nutrition/nutrition.seed.ts').addNewNutritionItems()
  .then(() => console.log('Update completed successfully'))
  .catch(err => {
    console.error('Update failed:', err);
    process.exit(1);
  });
