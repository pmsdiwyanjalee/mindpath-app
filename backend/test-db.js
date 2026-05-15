const { sequelize } = require('./models');

async function testConnection() {
  try {
    await sequelize.authenticate();
    console.log('✅ MySQL connection has been established successfully.');

    // Test creating tables
    await sequelize.sync({ force: false });
    console.log('✅ Database tables synchronized successfully.');

  } catch (error) {
    console.error('❌ Unable to connect to the database:', error);
  } finally {
    await sequelize.close();
  }
}

testConnection();