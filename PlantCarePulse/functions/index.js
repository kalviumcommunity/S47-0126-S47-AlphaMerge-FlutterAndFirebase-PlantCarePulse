const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * Callable Cloud Function: Plant Care Greeting
 * This function can be called directly from Flutter
 * Use case: Personalized welcome messages for plant care users
 */
exports.getPlantCareGreeting = functions.https.onCall((data, context) => {
  const plantName = data.plantName || "Plant";
  const userName = data.userName || "Gardener";
  
  const greetings = [
    `Hello ${userName}! Your ${plantName} is looking great today! 🌱`,
    `Welcome back ${userName}! Time to check on your ${plantName}! 🌿`,
    `Hi ${userName}! Don't forget to water your ${plantName}! 💧`,
    `Hey ${userName}! Your ${plantName} is thriving under your care! 🌺`,
  ];
  
  const randomGreeting = greetings[Math.floor(Math.random() * greetings.length)];
  
  return {
    message: randomGreeting,
    timestamp: admin.firestore.Timestamp.now(),
    plantName: plantName,
    userName: userName,
  };
});

/**
 * Callable Cloud Function: Calculate Next Watering Date
 * Calculates when a plant should be watered next based on care schedule
 */
exports.calculateNextWatering = functions.https.onCall((data, context) => {
  const wateringFrequency = data.wateringFrequency || 7; // days
  const lastWatered = data.lastWatered || new Date().toISOString();
  
  const lastWateredDate = new Date(lastWatered);
  const nextWateringDate = new Date(lastWateredDate);
  nextWateringDate.setDate(nextWateringDate.getDate() + wateringFrequency);
  
  const daysUntilWatering = Math.ceil(
    (nextWateringDate - new Date()) / (1000 * 60 * 60 * 24)
  );
  
  return {
    nextWateringDate: nextWateringDate.toISOString(),
    daysUntilWatering: daysUntilWatering,
    wateringFrequency: wateringFrequency,
    status: daysUntilWatering <= 0 ? "Water now!" : "On schedule",
  };
});

/**
 * Firestore Trigger: New Plant Added
 * Automatically runs when a new plant document is created
 * Use case: Initialize default care settings, send notifications, log analytics
 */
exports.onNewPlantAdded = functions.firestore
  .document("plants/{plantId}")
  .onCreate(async (snap, context) => {
    const plantData = snap.data();
    const plantId = context.params.plantId;
    
    console.log("New plant added:", plantId, plantData);
    
    // Add default care schedule if not provided
    const defaultCareSchedule = {
      wateringFrequency: plantData.wateringFrequency || 7,
      fertilizingFrequency: plantData.fertilizingFrequency || 30,
      lastWatered: plantData.lastWatered || admin.firestore.Timestamp.now(),
      lastFertilized: plantData.lastFertilized || admin.firestore.Timestamp.now(),
      createdAt: admin.firestore.Timestamp.now(),
      careRemindersEnabled: true,
    };
    
    // Update the document with default values
    await snap.ref.update({
      careSchedule: defaultCareSchedule,
      plantStatus: "healthy",
      totalCareActions: 0,
    });
    
    console.log("Plant initialized with default care schedule:", plantId);
    
    return null;
  });

/**
 * Firestore Trigger: Plant Care Action Logged
 * Runs when a care action (watering, fertilizing) is logged
 * Use case: Update plant statistics, track care history
 */
exports.onCareActionLogged = functions.firestore
  .document("plants/{plantId}/careHistory/{actionId}")
  .onCreate(async (snap, context) => {
    const actionData = snap.data();
    const plantId = context.params.plantId;
    
    console.log("Care action logged for plant:", plantId, actionData);
    
    // Get the plant document
    const plantRef = admin.firestore().collection("plants").doc(plantId);
    const plantDoc = await plantRef.get();
    
    if (!plantDoc.exists) {
      console.log("Plant not found:", plantId);
      return null;
    }
    
    // Update plant statistics
    const currentTotal = plantDoc.data().totalCareActions || 0;
    await plantRef.update({
      totalCareActions: currentTotal + 1,
      lastCareAction: actionData.actionType || "unknown",
      lastCareDate: admin.firestore.Timestamp.now(),
    });
    
    console.log("Plant statistics updated for:", plantId);
    
    return null;
  });

/**
 * Firestore Trigger: Plant Deleted
 * Cleanup function when a plant is removed
 */
exports.onPlantDeleted = functions.firestore
  .document("plants/{plantId}")
  .onDelete(async (snap, context) => {
    const plantId = context.params.plantId;
    const plantData = snap.data();
    
    console.log("Plant deleted:", plantId, plantData.name);
    
    // Archive the deleted plant data
    await admin.firestore().collection("deletedPlants").doc(plantId).set({
      ...plantData,
      deletedAt: admin.firestore.Timestamp.now(),
    });
    
    console.log("Plant archived:", plantId);
    
    return null;
  });
