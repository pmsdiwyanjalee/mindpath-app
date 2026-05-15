const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Appointment = sequelize.define('Appointment', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  patientId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  counsellorId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'counsellors',
      key: 'id'
    }
  },
  type: {
    type: DataTypes.ENUM('counselling', 'follow-up', 'group-session'),
    allowNull: false
  },
  date: {
    type: DataTypes.DATEONLY,
    allowNull: false
  },
  startTime: {
    type: DataTypes.TIME,
    allowNull: false
  },
  endTime: {
    type: DataTypes.TIME,
    allowNull: false
  },
  method: {
    type: DataTypes.ENUM('in-person', 'video', 'phone'),
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM('scheduled', 'confirmed', 'completed', 'cancelled', 'no-show'),
    defaultValue: 'scheduled'
  },
  notes: {
    type: DataTypes.TEXT,
    allowNull: true,
    validate: {
      len: [0, 500]
    }
  },
  location: {
    type: DataTypes.STRING,
    allowNull: true
  },
  meetingLink: {
    type: DataTypes.STRING,
    allowNull: true
  },
  reminderSent: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  updatedAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'appointments',
  timestamps: true,
  indexes: [
    {
      fields: ['patientId', 'date']
    },
    {
      fields: ['counsellorId', 'date']
    },
    {
      fields: ['status']
    }
  ]
});

// Define associations
Appointment.associate = (models) => {
  Appointment.belongsTo(models.User, { foreignKey: 'patientId', as: 'patient' });
  Appointment.belongsTo(models.Counsellor, { foreignKey: 'counsellorId', as: 'counsellor' });
};

module.exports = Appointment;