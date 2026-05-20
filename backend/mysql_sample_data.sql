USE `mindpath`;

-- Insert sample users
INSERT INTO `users` (`fullName`, `email`, `password`, `role`, `phone`, `dateOfBirth`, `profilePicture`, `sobrietyStartDate`, `emergencyContact`, `preferences`, `isActive`, `lastLogin`)
VALUES
('Alice Johnson', 'alice@example.com', 'password123', 'patient', '+1234567890', '1990-04-12', NULL, NULL, JSON_OBJECT('name', 'John Doe', 'phone', '+1987654321'), JSON_OBJECT('language', 'en', 'notifications', true, 'theme', 'light'), 1, NOW()),
('Dr. Luna Wells', 'luna@example.com', 'securepass', 'counsellor', '+1098765432', '1984-09-22', NULL, NULL, JSON_OBJECT('name', 'Emergency Contact', 'phone', '+1122334455'), JSON_OBJECT('language', 'en', 'notifications', true, 'theme', 'dark'), 1, NOW());

-- Insert sample counsellor profile
INSERT INTO `counsellors` (`userId`, `licenseNumber`, `institution`, `specialty`, `experience`, `qualifications`, `certifications`, `bio`, `rating`, `reviewCount`, `availability`, `languages`, `isVerified`, `verificationDocuments`)
VALUES
((SELECT `id` FROM `users` WHERE `email` = 'luna@example.com'), 'LIC-2026-1234', 'MindPath Institute', 'Mental Health Counseling', 7, JSON_ARRAY('MSc Psychology', 'PhD Clinical Practice'), JSON_ARRAY('CBT', 'Mindfulness'), 'Experienced counsellor specializing in anxiety, depression, and life transition support.', 4.9, 120, JSON_OBJECT('monday', '10:00-16:00', 'wednesday', '12:00-18:00'), JSON_ARRAY('en', 'si', 'ta'), 1, JSON_OBJECT('documents', JSON_ARRAY('license.pdf', 'certification.pdf')));

-- Insert sample appointment
INSERT INTO `appointments` (`patientId`, `counsellorId`, `type`, `date`, `startTime`, `endTime`, `method`, `status`, `notes`, `location`, `meetingLink`, `reminderSent`)
VALUES
((SELECT `id` FROM `users` WHERE `email` = 'alice@example.com'), (SELECT `id` FROM `counsellors` WHERE `licenseNumber` = 'LIC-2026-1234'), 'counselling', '2026-05-29', '14:00:00', '15:00:00', 'video', 'scheduled', 'Initial intake session.', 'Online', 'https://meet.example.com/mindpath-1', 0);

-- Insert sample resource
INSERT INTO `resources` (`title`, `content`, `category`, `tags`, `authorId`, `isPublished`, `publishedAt`, `viewCount`, `likeCount`, `mediaUrl`, `thumbnailUrl`, `readingTime`, `language`)
VALUES
('Managing Anxiety During Transitions', 'A guide to managing anxiety with mindfulness, journaling, and routine adjustments.', 'article', JSON_ARRAY('anxiety', 'transition', 'mindfulness'), (SELECT `id` FROM `users` WHERE `email` = 'luna@example.com'), 1, '2026-05-20 12:00:00', 250, 35, NULL, NULL, 8, 'en');

-- Insert sample chat and message
INSERT INTO `chats` (`participants`, `lastMessage`, `isActive`)
VALUES
(JSON_ARRAY((SELECT `id` FROM `users` WHERE `email` = 'alice@example.com'), (SELECT `id` FROM `counsellors` WHERE `licenseNumber` = 'LIC-2026-1234')), JSON_OBJECT('senderId', (SELECT `id` FROM `users` WHERE `email` = 'luna@example.com'), 'content', 'Hello, I look forward to our session.'), 1);

INSERT INTO `messages` (`chatId`, `senderId`, `content`, `messageType`, `isRead`)
VALUES
((SELECT `id` FROM `chats` ORDER BY `id` DESC LIMIT 1), (SELECT `id` FROM `users` WHERE `email` = 'luna@example.com'), 'Hello Alice, I look forward to our appointment next week.', 'text', 0);
