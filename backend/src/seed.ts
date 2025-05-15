import { DataSource } from 'typeorm';
import { Exercise } from './exercise/exercise.entity';
import { AppDataSource } from './data-source';
import { seedNutrition } from './nutrition/nutrition.seed';
import { GymClass, ClassType } from './class/class.entity';
import { User } from './user/user.entity';
import { Role } from './user/role.enum';

async function seedExercises() {
  await AppDataSource.initialize();
  const exerciseRepo = AppDataSource.getRepository(Exercise);
  const improvedExercises = [
    // Chest      
    { 
      name: 'Push-up', 
      description: 'Ultimate bodyweight exercise for chest and triceps', 
      muscleGroup: 'chest',
      defaultSets: 4,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=IODxDxX7oi4',
      imageUrl: '/assets/images/push_ups.jpg'
    },
    { 
      name: 'Bench Press', 
      description: 'Major compound exercise for chest development', 
      muscleGroup: 'chest',
      defaultSets: 4,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=rT7DgCr-3pg',
      imageUrl: '/assets/images/bench_press.jpg'
    },
    { 
      name: 'Incline Dumbbell Press', 
      description: 'Upper chest focused pressing movement', 
      muscleGroup: 'chest',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=0G2_XV7slIg',
      imageUrl: '/assets/images/incline_dumbel_press.jpg'
    },
    { 
      name: 'Decline Bench Press', 
      description: 'Lower chest focused pressing movement',
      muscleGroup: 'chest',
      defaultSets: 3,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=LfyQBUKR8SE',
      imageUrl: '/assets/images/Decline_Bench-Press.jpg'
    },
    { 
      name: 'Chest Fly', 
      description: 'Isolation exercise for chest stretching and contraction',
      muscleGroup: 'chest',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=eozdVDA78K0',
      imageUrl: '/assets/images/chest_fly.jpg'
    },
    { 
      name: 'Cable Crossover', 
      description: 'Isolation cable exercise for chest definition',
      muscleGroup: 'chest',
      defaultSets: 3,
      defaultReps: 15,
      videoUrl: 'https://www.youtube.com/watch?v=taI4XduLpTk',
      imageUrl: '/assets/images/Cable-Crossover.jpg'
    },
    { 
      name: 'Dips', 
      description: 'Compound bodyweight exercise for lower chest and triceps',
      muscleGroup: 'chest',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=2z8JmcrW-As',
      imageUrl: '/assets/images/dips.jpg'
    },
    
    // Back
    { 
      name: 'Pull-up', 
      description: 'Upper body pulling exercise for back and biceps', 
      muscleGroup: 'back',
      defaultSets: 3,
      defaultReps: 8,
      videoUrl: 'https://www.youtube.com/watch?v=eGo4IYlbE5g',
      imageUrl: '/assets/images/Pull-up.jpg'
    },
    { 
      name: 'Bent Over Row', 
      description: 'Compound back exercise targeting middle back', 
      muscleGroup: 'back',
      defaultSets: 4,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=FWJR5Ve8bnQ',
      imageUrl: '/assets/images/Bent_Over Row.avif'
    },
    { 
      name: 'Lat Pulldown', 
      description: 'Machine exercise targeting latissimus dorsi', 
      muscleGroup: 'back',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=CAwf7n6Luuc',
      imageUrl: '/assets/images/Lat_Pulldown.jpg'
    },
    { 
      name: 'T-Bar Row', 
      description: 'Compound exercise for middle and upper back thickness',
      muscleGroup: 'back',
      defaultSets: 3,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=j3Igk5nyZE4',
      imageUrl: '/assets/images/T-Bar_Row.jpg'
    },
    { 
      name: 'Cable Row', 
      description: 'Seated cable exercise for back width and thickness',
      muscleGroup: 'back',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=GZbfZ033f74',
      imageUrl: '/assets/images/Cable_row.png'
    },
    { 
      name: 'Single-Arm Dumbbell Row', 
      description: 'Unilateral back exercise for balance and strength',
      muscleGroup: 'back',
      defaultSets: 3,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=pYcpY20QaE8',
      imageUrl: '/assets/images/Single-Arm_Dumbbell_Row.jpg'
    },
    { 
      name: 'Chin-up', 
      description: 'Supinated grip pull-up variation targeting biceps and back',
      muscleGroup: 'back',
      defaultSets: 3,
      defaultReps: 8,
      videoUrl: 'https://www.youtube.com/watch?v=b-ztMQpj8yc',
      imageUrl: '/assets/images/chin_up.jpg'
    },
    
    // Legs
    { 
      name: 'Squat', 
      description: 'Fundamental lower body movement for quads and glutes', 
      muscleGroup: 'legs',
      defaultSets: 4,
      defaultReps: 8,
      videoUrl: 'https://www.youtube.com/watch?v=bEv6CCg2BC8',
      imageUrl: '/assets/images/Squat.jpg'
    },
    { 
      name: 'Deadlift', 
      description: 'Compound movement for posterior chain', 
      muscleGroup: 'legs',
      defaultSets: 4,
      defaultReps: 6,
      videoUrl: 'https://www.youtube.com/watch?v=op9kVnSso6Q',
      imageUrl: '/assets/images/Deadlift.jpg'
    },
    { 
      name: 'Leg Press', 
      description: 'Machine exercise targeting quadriceps', 
      muscleGroup: 'legs',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=IZxyjW7MPJQ',
      imageUrl: '/assets/images/Leg_Press.jpg'
    },
    { 
      name: 'Lunges', 
      description: 'Unilateral lower body exercise for quads and glutes',
      muscleGroup: 'legs',
      defaultSets: 3,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=QOVaHwm-Q6U',
      imageUrl: '/assets/images/Lunges.png'
    },
    { 
      name: 'Romanian Deadlift', 
      description: 'Hamstring-focused hip hinge movement',
      muscleGroup: 'legs',
      defaultSets: 3,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=JCXUYuzwNrM',
      imageUrl: '/assets/images/Romanian_Deadlift.jpg'
    },
    { 
      name: 'Leg Extension', 
      description: 'Isolation machine exercise for quadriceps',
      muscleGroup: 'legs',
      defaultSets: 3,
      defaultReps: 15,
      videoUrl: 'https://www.youtube.com/watch?v=YyvSfVjQeL0',
      imageUrl: '/assets/images/Leg_Extension.webp'
    },
    { 
      name: 'Leg Curl', 
      description: 'Isolation machine exercise for hamstrings',
      muscleGroup: 'legs',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=1Tq3QdYUuHs',
      imageUrl: '/assets/images/Leg_Curl.jpg'
    },
    { 
      name: 'Calf Raises', 
      description: 'Isolation exercise for calf muscles',
      muscleGroup: 'legs',
      defaultSets: 4,
      defaultReps: 15,
      videoUrl: 'https://www.youtube.com/watch?v=gwLzBJYoWlI',
      imageUrl: '/assets/images/Calf_Raises.jpg'
    },
    { 
      name: 'Hip Thrust', 
      description: 'Glute-focused exercise for lower body strength',
      muscleGroup: 'legs',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=SEdqd1n0cvg',
      imageUrl: '/assets/images/Hip_Thrust.jpg'
    },
    
    // Shoulders
    { 
      name: 'Shoulder Press', 
      description: 'Overhead pressing movement for shoulder development', 
      muscleGroup: 'shoulders',
      defaultSets: 3,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=qEwKCR5JCog',
      imageUrl: '/assets/images/Shoulder_Press.avif'
    },
    { 
      name: 'Lateral Raise', 
      description: 'Isolation exercise for lateral deltoids', 
      muscleGroup: 'shoulders',
      defaultSets: 3,
      defaultReps: 15,
      videoUrl: 'https://www.youtube.com/watch?v=3VcKaXpzqRo',
      imageUrl: '/assets/images/Lateral_Raise.jpg'
    },
    { 
      name: 'Front Raise', 
      description: 'Targeted exercise for anterior deltoids', 
      muscleGroup: 'shoulders',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=sxZeBUEEOKY',
      imageUrl: '/assets/images/Front_raise.jpg'
    },
    { 
      name: 'Reverse Fly', 
      description: 'Isolation exercise for posterior deltoids',
      muscleGroup: 'shoulders',
      defaultSets: 3,
      defaultReps: 15,
      videoUrl: 'https://www.youtube.com/watch?v=Fk4AenJFhNM',
      imageUrl: '/assets/images/Reverse_Fly.jpg'
    },
    { 
      name: 'Upright Row', 
      description: 'Compound exercise for traps and shoulders',
      muscleGroup: 'shoulders',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=VL0pDggWDqk',
      imageUrl: '/assets/images/Upright Row.gif'
    },
    { 
      name: 'Face Pull', 
      description: 'Rotator cuff and rear delt exercise for shoulder health',
      muscleGroup: 'shoulders',
      defaultSets: 3,
      defaultReps: 15,
      videoUrl: 'https://www.youtube.com/watch?v=eIq5CB9JfKE',
      imageUrl: '/assets/images/Face_Pull.jpeg'
    },
    { 
      name: 'Arnold Press', 
      description: 'Rotational shoulder press variation for complete development',
      muscleGroup: 'shoulders',
      defaultSets: 3,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=6Z15_WdXmVw',
      imageUrl: '/assets/images/Arnold Press.jpg'
    },
    
    // Arms
    { 
      name: 'Bicep Curl', 
      description: 'Isolation exercise for biceps', 
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=ykJmrZ5v0Oo',
      imageUrl: '/assets/images/Biceps curl.jpg'
    },
    { 
      name: 'Tricep Dip', 
      description: 'Bodyweight exercise for triceps', 
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=6kALZikXxLc',
      imageUrl: '/assets/images/Tricep_Dips.jpg'
    },
    { 
      name: 'Hammer Curl', 
      description: 'Variation of bicep curl targeting brachialis and forearms', 
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=zC3nLlEvin4',
      imageUrl: '/assets/images/Hammer Curl.jpg'
    },
    { 
      name: 'Tricep Pushdown', 
      description: 'Cable exercise isolating the triceps',
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=2-LAMcpzODU',
      imageUrl: '/assets/images/Tricep_Pushdown.jpg'
    },
    { 
      name: 'Preacher Curl', 
      description: 'Supported bicep curl variation for peak contraction',
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=fIWP-FRFNU0',
      imageUrl: '/assets/images/Preacher_Curl.jpg'
    },
    { 
      name: 'Skull Crushers', 
      description: 'Lying tricep extension for tricep development',
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=d_KZxkY_0cM',
      imageUrl: '/assets/images/Skull_Crushers.jpg'
    },
    { 
      name: 'Concentration Curl', 
      description: 'Seated isolation exercise for bicep peak',
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=Jvj2wV0vOYU',
      imageUrl: '/assets/images/Concentration Curl.jpg'
    },
    { 
      name: 'Overhead Tricep Extension', 
      description: 'Isolation exercise focusing on tricep long head',
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=_gsUck-7M74',
      imageUrl: '/assets/images/Overhead Tricep Extension.jpg'
    },
    { 
      name: 'Wrist Curl', 
      description: 'Forearm-focused exercise for grip strength',
      muscleGroup: 'arms',
      defaultSets: 3,
      defaultReps: 15,
      videoUrl: 'https://www.youtube.com/watch?v=L9Y7V_IJLJQ',
      imageUrl: '/assets/images/Wrist_Curl.jpg'
    },
    
    // Core
    { 
      name: 'Plank', 
      description: 'Core stabilizing exercise', 
      muscleGroup: 'core',
      defaultSets: 3,
      defaultReps: 30, // seconds
      videoUrl: 'https://www.youtube.com/watch?v=ASdvN_XEl_c',
      imageUrl: '/assets/images/Plank.jpg'
    },
    { 
      name: 'Crunch', 
      description: 'Abdominal isolation exercise', 
      muscleGroup: 'core',
      defaultSets: 3,
      defaultReps: 20,
      videoUrl: 'https://www.youtube.com/watch?v=Xyd_fa5zoEU',
      imageUrl: '/assets/images/Crunch.jpg'
    },
    { 
      name: 'Russian Twist', 
      description: 'Rotational exercise for obliques', 
      muscleGroup: 'core',
      defaultSets: 3,
      defaultReps: 16,
      videoUrl: 'https://www.youtube.com/watch?v=wkD8rjkodUI',
      imageUrl: '/assets/images/Russian_Twist.jpg'
    },
    { 
      name: 'Leg Raises', 
      description: 'Lower abdominal focused exercise',
      muscleGroup: 'core',
      defaultSets: 3,
      defaultReps: 15,
      videoUrl: 'https://www.youtube.com/watch?v=l4kQd9eWclE',
      imageUrl: '/assets/images/Leg_Raises.jpg'
    },
    { 
      name: 'Bicycle Crunches', 
      description: 'Dynamic exercise targeting rectus abdominis and obliques',
      muscleGroup: 'core',
      defaultSets: 3,
      defaultReps: 20,
      videoUrl: 'https://www.youtube.com/watch?v=9FGilxCbdz8',
      imageUrl: '/assets/images/Bicycle_Crunches.jpg'
    },
    { 
      name: 'Hanging Leg Raise', 
      description: 'Advanced exercise for lower abs and hip flexors',
      muscleGroup: 'core',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=hdng3Nm1x_E',
      imageUrl: '/assets/images/Hanging_Leg_ Raise.jpg'
    },
    { 
      name: 'Ab Rollout', 
      description: 'Advanced exercise for entire core using wheel or barbell',
      muscleGroup: 'core',
      defaultSets: 3,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=rqiTPdK1c_I',
      imageUrl: '/assets/images/Ab_Rollout.jpg'
    },
    
    // Full Body
    { 
      name: 'Burpee', 
      description: 'Full-body exercise combining squats, push-ups, and jumps', 
      muscleGroup: 'full body',
      defaultSets: 3,
      defaultReps: 15,
      videoUrl: 'https://www.youtube.com/watch?v=TU8QYVW0gDU',
      imageUrl: '/assets/images/Burpee.jpg'
    },
    { 
      name: 'Mountain Climber', 
      description: 'Dynamic exercise engaging core, legs, and cardio', 
      muscleGroup: 'full body',
      defaultSets: 3,
      defaultReps: 20,
      videoUrl: 'https://www.youtube.com/watch?v=nmwgirgXLYM',
      imageUrl: '/assets/images/Mountain_Climbers.jpg'
    },
    { 
      name: 'Kettlebell Swing', 
      description: 'Dynamic exercise for posterior chain and cardio', 
      muscleGroup: 'full body',
      defaultSets: 3,
      defaultReps: 15,
      videoUrl: 'https://www.youtube.com/watch?v=YSxHifyI6s8',
      imageUrl: '/assets/images/Kettlebell_Swing.jpg'
    },
    { 
      name: 'Thruster', 
      description: 'Compound movement combining front squat and overhead press',
      muscleGroup: 'full body',
      defaultSets: 3,
      defaultReps: 12,
      videoUrl: 'https://www.youtube.com/watch?v=L219ltL15zk',
      imageUrl: '/assets/images/Thruster.jpg'
    },
    { 
      name: 'Clean and Press', 
      description: 'Olympic weightlifting movement for power and strength',
      muscleGroup: 'full body',
      defaultSets: 4,
      defaultReps: 6,
      videoUrl: 'https://www.youtube.com/watch?v=bAsS_TsQgL4',
      imageUrl: '/assets/images/Clean_and_Press.jpg'
    },
    { 
      name: 'Turkish Get-Up', 
      description: 'Complex movement pattern for mobility and stability',
      muscleGroup: 'full body',
      defaultSets: 3,
      defaultReps: 5,
      videoUrl: 'https://www.youtube.com/watch?v=jFK8FOiLa_M',
      imageUrl: '/assets/images/Turkish_Get-Up.jpg'
    },
    { 
      name: 'Box Jump', 
      description: 'Plyometric exercise for lower body power',
      muscleGroup: 'full body',
      defaultSets: 3,
      defaultReps: 10,
      videoUrl: 'https://www.youtube.com/watch?v=52r_Ul5k03g',
      imageUrl: '/assets/images/box_jump.jpg'
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
      existingExercise.videoUrl = improvedData.videoUrl || existingExercise.videoUrl;
      
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
        } else if (muscleGroup.includes('full') || muscleGroup.includes('cardio') || muscleGroup.includes('stretch')) {
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

async function seedGymClasses(connection) {
  const gymClassRepository = connection.getRepository(GymClass);
  const userRepository = connection.getRepository(User);
  
  // Find admin and coach users to assign as creators
  const admin = await userRepository.findOne({ where: { role: Role.ADMIN } });
  const coaches = await userRepository.find({ where: { role: Role.COACH } });
  
  if (!admin || coaches.length === 0) {
    console.log('Admin or coaches not found, cannot seed gym classes');
    return;
  }
  
  // Current date for classes
  const today = new Date();
  const tomorrow = new Date(today);
  tomorrow.setDate(tomorrow.getDate() + 1);
  
  // Sample gym classes
  const gymClasses = [
    {
      className: 'Morning Spinning',
      startTime: '08:00',
      endTime: '09:00',
      instructor: 'Emma Wilson',
      instructorImageUrl: '',
      duration: 45,
      capacity: 20,
      bookedSpots: 8,
      classType: ClassType.CARDIO,
      date: today,
      createdBy: admin
    },
    {
      className: 'Yoga Flow',
      startTime: '10:00',
      endTime: '11:00',
      instructor: 'Katty Perry',
      instructorImageUrl: '',
      duration: 60,
      capacity: 15,
      bookedSpots: 7,
      classType: ClassType.YOGA,
      date: today,
      createdBy: coaches[0]
    },
    {
      className: 'CrossFit',
      startTime: '13:00',
      endTime: '14:00',
      instructor: 'Emma Wilson',
      instructorImageUrl: '',
      duration: 45,
      capacity: 12,
      bookedSpots: 12,
      classType: ClassType.STRENGTH,
      date: today,
      createdBy: coaches[0]
    },
    {
      className: 'HIIT',
      startTime: '14:00',
      endTime: '15:00',
      instructor: 'Emily Waterson',
      instructorImageUrl: '',
      duration: 30,
      capacity: 15,
      bookedSpots: 15,
      classType: ClassType.CARDIO,
      date: today,
      createdBy: admin
    },
    {
      className: 'Body Pump',
      startTime: '16:00',
      endTime: '17:00',
      instructor: 'Emma Wilson',
      instructorImageUrl: '',
      duration: 45,
      capacity: 20,
      bookedSpots: 20,
      classType: ClassType.STRENGTH,
      date: today,
      createdBy: coaches[0]
    },
    {
      className: 'Pilates',
      startTime: '17:00',
      endTime: '18:00',
      instructor: 'Emma Wilson',
      instructorImageUrl: '',
      duration: 45,
      capacity: 15,
      bookedSpots: 10,
      classType: ClassType.YOGA,
      date: today,
      createdBy: admin
    },
    {
      className: 'Body Jump',
      startTime: '18:00',
      endTime: '19:00',
      instructor: 'Emma Jhonson',
      instructorImageUrl: '',
      duration: 50,
      capacity: 10,
      bookedSpots: 9,
      classType: ClassType.CARDIO,
      date: today,
      createdBy: coaches[0]
    },
    // Tomorrow's classes
    {
      className: 'Morning Yoga',
      startTime: '09:00',
      endTime: '10:00',
      instructor: 'Katty Perry',
      instructorImageUrl: '',
      duration: 60,
      capacity: 15,
      bookedSpots: 3,
      classType: ClassType.YOGA,
      date: tomorrow,
      createdBy: admin
    },
    {
      className: 'Power Lifting',
      startTime: '11:00',
      endTime: '12:30',
      instructor: 'John Strong',
      instructorImageUrl: '',
      duration: 90,
      capacity: 10,
      bookedSpots: 5,
      classType: ClassType.STRENGTH,
      date: tomorrow,
      createdBy: coaches[0]
    },
    {
      className: 'Zumba',
      startTime: '14:00',
      endTime: '15:00',
      instructor: 'Maria Rodriguez',
      instructorImageUrl: '',
      duration: 60,
      capacity: 25,
      bookedSpots: 12,
      classType: ClassType.CARDIO,
      date: tomorrow,
      createdBy: admin
    }
  ];
  
  for (const gymClassData of gymClasses) {
    const existingClass = await gymClassRepository.findOne({
      where: {
        className: gymClassData.className,
        date: gymClassData.date,
        startTime: gymClassData.startTime
      }
    });
    
    if (!existingClass) {
      await gymClassRepository.save(gymClassData);
      console.log(`Created gym class: ${gymClassData.className}`);
    } else {
      console.log(`Gym class already exists: ${gymClassData.className}`);
    }
  }
  
  console.log('Gym classes seeded successfully');
}

async function seedAll() {
  console.log('Starting complete database seeding...');
  
  try {
    // Seed exercises
    await seedExercises();
    
    // Seed nutrition items
    await seedNutrition();
    
    // Seed gym classes
    await seedGymClasses(AppDataSource);
    
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