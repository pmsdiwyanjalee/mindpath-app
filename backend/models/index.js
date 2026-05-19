const sequelize = require('../config/database');

// Import all models
const User = require('./User');
const Counsellor = require('./Counsellor');
const Appointment = require('./Appointment');
const Resource = require('./Resource');
const Chat = require('./Chat');
const Message = require('./Message');

// Define associations
const models = {
  User,
  Counsellor,
  Appointment,
  Resource,
  Chat,
  Message
};

// Apply associations
Object.keys(models).forEach(modelName => {
  if (models[modelName].associate) {
    models[modelName].associate(models);
  }
});

// Sync database (create tables)
const syncDatabase = async () => {
  try {
    await sequelize.sync({ alter: true }); // Use { force: true } to drop and recreate tables
    console.log('Database synchronized successfully');
  } catch (error) {
    console.error('Error synchronizing database:', error);
    throw error;
  }
};

module.exports = {
  sequelize,
  syncDatabase,
  ...models
};