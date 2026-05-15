const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Resource = sequelize.define('Resource', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true
    }
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  category: {
    type: DataTypes.ENUM('article', 'video', 'audio', 'tool', 'guide'),
    allowNull: false
  },
  tags: {
    type: DataTypes.JSON,
    allowNull: true
  },
  authorId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  isPublished: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  publishedAt: {
    type: DataTypes.DATE,
    allowNull: true
  },
  viewCount: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  likeCount: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  mediaUrl: {
    type: DataTypes.STRING,
    allowNull: true
  },
  thumbnailUrl: {
    type: DataTypes.STRING,
    allowNull: true
  },
  readingTime: {
    type: DataTypes.INTEGER,
    allowNull: true,
    validate: {
      min: 0
    }
  },
  language: {
    type: DataTypes.ENUM('en', 'si', 'ta'),
    defaultValue: 'en'
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
  tableName: 'resources',
  timestamps: true,
  indexes: [
    {
      fields: ['category', 'isPublished']
    },
    {
      fields: ['authorId']
    },
    {
      fields: ['language']
    },
    {
      fields: ['publishedAt']
    }
  ]
});

// Define associations
Resource.associate = (models) => {
  Resource.belongsTo(models.User, { foreignKey: 'authorId', as: 'author' });
};

module.exports = Resource;