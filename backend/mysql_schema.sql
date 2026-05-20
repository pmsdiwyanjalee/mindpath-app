-- MySQL schema for MindPath application
-- Run this script in a MySQL server to create the database and tables.

CREATE DATABASE IF NOT EXISTS `mindpath`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `mindpath`;

CREATE TABLE IF NOT EXISTS `users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fullName` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `role` ENUM('patient','counsellor','admin') NOT NULL DEFAULT 'patient',
  `phone` VARCHAR(50) DEFAULT NULL,
  `dateOfBirth` DATE DEFAULT NULL,
  `profilePicture` VARCHAR(255) DEFAULT NULL,
  `sobrietyStartDate` DATE DEFAULT NULL,
  `emergencyContact` JSON DEFAULT NULL,
  `preferences` JSON DEFAULT NULL,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `lastLogin` DATETIME DEFAULT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `counsellors` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `userId` INT UNSIGNED NOT NULL,
  `licenseNumber` VARCHAR(255) NOT NULL,
  `institution` VARCHAR(255) NOT NULL,
  `specialty` VARCHAR(255) NOT NULL,
  `experience` INT NOT NULL DEFAULT 0,
  `qualifications` JSON DEFAULT NULL,
  `certifications` JSON DEFAULT NULL,
  `bio` TEXT DEFAULT NULL,
  `rating` DECIMAL(3,2) NOT NULL DEFAULT 0.00,
  `reviewCount` INT NOT NULL DEFAULT 0,
  `availability` JSON DEFAULT NULL,
  `languages` JSON DEFAULT NULL,
  `isVerified` TINYINT(1) NOT NULL DEFAULT 0,
  `verificationDocuments` JSON DEFAULT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `counsellors_licenseNumber_unique` (`licenseNumber`),
  KEY `counsellors_userId_idx` (`userId`),
  KEY `counsellors_isVerified_idx` (`isVerified`),
  CONSTRAINT `counsellors_user_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `appointments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `patientId` INT UNSIGNED NOT NULL,
  `counsellorId` INT UNSIGNED NOT NULL,
  `type` ENUM('counselling','follow-up','group-session') NOT NULL,
  `date` DATE NOT NULL,
  `startTime` TIME NOT NULL,
  `endTime` TIME NOT NULL,
  `method` ENUM('in-person','video','phone') NOT NULL,
  `status` ENUM('scheduled','confirmed','completed','cancelled','no-show') NOT NULL DEFAULT 'scheduled',
  `notes` TEXT DEFAULT NULL,
  `location` VARCHAR(255) DEFAULT NULL,
  `meetingLink` VARCHAR(500) DEFAULT NULL,
  `reminderSent` TINYINT(1) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `appointments_patientId_date_idx` (`patientId`,`date`),
  KEY `appointments_counsellorId_date_idx` (`counsellorId`,`date`),
  KEY `appointments_status_idx` (`status`),
  CONSTRAINT `appointments_patient_fk` FOREIGN KEY (`patientId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `appointments_counsellor_fk` FOREIGN KEY (`counsellorId`) REFERENCES `counsellors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `resources` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `content` TEXT NOT NULL,
  `category` ENUM('article','video','audio','tool','guide') NOT NULL,
  `tags` JSON DEFAULT NULL,
  `authorId` INT UNSIGNED DEFAULT NULL,
  `isPublished` TINYINT(1) NOT NULL DEFAULT 0,
  `publishedAt` DATETIME DEFAULT NULL,
  `viewCount` INT NOT NULL DEFAULT 0,
  `likeCount` INT NOT NULL DEFAULT 0,
  `mediaUrl` VARCHAR(500) DEFAULT NULL,
  `thumbnailUrl` VARCHAR(500) DEFAULT NULL,
  `readingTime` INT DEFAULT NULL,
  `language` ENUM('en','si','ta') NOT NULL DEFAULT 'en',
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `resources_category_isPublished_idx` (`category`,`isPublished`),
  KEY `resources_authorId_idx` (`authorId`),
  KEY `resources_language_idx` (`language`),
  KEY `resources_publishedAt_idx` (`publishedAt`),
  CONSTRAINT `resources_author_fk` FOREIGN KEY (`authorId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `chats` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `participants` JSON NOT NULL,
  `lastMessage` JSON DEFAULT NULL,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `chats_isActive_idx` (`isActive`),
  KEY `chats_updatedAt_idx` (`updatedAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `messages` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `chatId` INT UNSIGNED NOT NULL,
  `senderId` INT UNSIGNED NOT NULL,
  `content` TEXT NOT NULL,
  `messageType` ENUM('text','image','file') NOT NULL DEFAULT 'text',
  `isRead` TINYINT(1) NOT NULL DEFAULT 0,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `messages_chatId_timestamp_idx` (`chatId`,`timestamp`),
  KEY `messages_senderId_idx` (`senderId`),
  KEY `messages_isRead_idx` (`isRead`),
  CONSTRAINT `messages_chat_fk` FOREIGN KEY (`chatId`) REFERENCES `chats` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `messages_sender_fk` FOREIGN KEY (`senderId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
