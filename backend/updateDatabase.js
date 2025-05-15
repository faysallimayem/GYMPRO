/**
 * Script to update the database with corrected image paths
 */

const { exec } = require('child_process');
const path = require('path');

console.log('Running seed script to update exercise data...');

// Run the seed script with the exercises argument
exec('npx ts-node src/seed.ts exercises', (error, stdout, stderr) => {
  if (error) {
    console.error(`Error: ${error.message}`);
    return;
  }
  if (stderr) {
    console.error(`stderr: ${stderr}`);
    return;
  }
  console.log(`stdout: ${stdout}`);
  console.log('Database update completed successfully!');
});
