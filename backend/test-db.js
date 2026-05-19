const { sequelize, syncDatabase } = require('./models');

async function testConnection() {
  try {
    await sequelize.authenticate();
    console.log('✅ SQLite database connected successfully.');

    await syncDatabase();
    console.log('✅ Database tables synchronized successfully.');

    console.log('✅ Database setup completed successfully!');
  } catch (error) {
    console.error('❌ Database setup failed:', error.message);
    process.exit(1);
  } finally {
    await sequelize.close();
  }
}

testConnection();