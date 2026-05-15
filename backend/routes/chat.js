const express = require('express');
const { Chat, Message, User } = require('../models');
const auth = require('../middleware/auth');
const { Op } = require('sequelize');

const router = express.Router();

// Get user's chats
router.get('/', auth, async (req, res) => {
  try {
    const chats = await Chat.findAll({
      where: {
        [Op.and]: [
          { isActive: true },
          {
            [Op.or]: [
              { participant1Id: req.user.userId },
              { participant2Id: req.user.userId }
            ]
          }
        ]
      },
      include: [
        {
          model: User,
          as: 'participant1',
          attributes: ['fullName', 'email', 'profilePicture']
        },
        {
          model: User,
          as: 'participant2',
          attributes: ['fullName', 'email', 'profilePicture']
        },
        {
          model: Message,
          as: 'messages',
          limit: 1,
          order: [['createdAt', 'DESC']],
          include: [{
            model: User,
            as: 'sender',
            attributes: ['fullName']
          }]
        }
      ],
      order: [['updatedAt', 'DESC']]
    });

    res.json(chats);
  } catch (error) {
    console.error('Chats fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Get chat by ID with messages
router.get('/:id', auth, async (req, res) => {
  try {
    const chat = await Chat.findByPk(req.params.id, {
      include: [
        {
          model: User,
          as: 'participant1',
          attributes: ['fullName', 'email', 'profilePicture']
        },
        {
          model: User,
          as: 'participant2',
          attributes: ['fullName', 'email', 'profilePicture']
        },
        {
          model: Message,
          as: 'messages',
          include: [{
            model: User,
            as: 'sender',
            attributes: ['fullName', 'profilePicture']
          }],
          order: [['createdAt', 'ASC']]
        }
      ]
    });

    if (!chat) {
      return res.status(404).json({ error: 'Chat not found' });
    }

    // Check if user is participant
    if (chat.participant1Id !== req.user.userId && chat.participant2Id !== req.user.userId) {
      return res.status(403).json({ error: 'Access denied' });
    }

    res.json(chat);
  } catch (error) {
    console.error('Chat fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Create new chat
router.post('/', auth, async (req, res) => {
  try {
    const { participantId, initialMessage } = req.body;

    // Check if chat already exists
    const existingChat = await Chat.findOne({
      where: {
        [Op.or]: [
          {
            [Op.and]: [
              { participant1Id: req.user.userId },
              { participant2Id: participantId }
            ]
          },
          {
            [Op.and]: [
              { participant1Id: participantId },
              { participant2Id: req.user.userId }
            ]
          }
        ],
        isActive: true
      }
    });

    if (existingChat) {
      const chatWithMessages = await Chat.findByPk(existingChat.id, {
        include: [
          {
            model: User,
            as: 'participant1',
            attributes: ['fullName', 'email', 'profilePicture']
          },
          {
            model: User,
            as: 'participant2',
            attributes: ['fullName', 'email', 'profilePicture']
          },
          {
            model: Message,
            as: 'messages',
            include: [{
              model: User,
              as: 'sender',
              attributes: ['fullName']
            }],
            order: [['createdAt', 'ASC']]
          }
        ]
      });
      return res.json(chatWithMessages);
    }

    const chatData = {
      participant1Id: req.user.userId,
      participant2Id: participantId,
      isActive: true
    };

    const chat = await Chat.create(chatData);

    // Create initial message if provided
    if (initialMessage) {
      await Message.create({
        chatId: chat.id,
        senderId: req.user.userId,
        content: initialMessage,
        messageType: 'text'
      });
    }

    const populatedChat = await Chat.findByPk(chat.id, {
      include: [
        {
          model: User,
          as: 'participant1',
          attributes: ['fullName', 'email', 'profilePicture']
        },
        {
          model: User,
          as: 'participant2',
          attributes: ['fullName', 'email', 'profilePicture']
        },
        {
          model: Message,
          as: 'messages',
          include: [{
            model: User,
            as: 'sender',
            attributes: ['fullName']
          }],
          order: [['createdAt', 'ASC']]
        }
      ]
    });

    res.status(201).json(populatedChat);
  } catch (error) {
    console.error('Chat creation error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Send message
router.post('/:id/messages', auth, async (req, res) => {
  try {
    const { content, messageType = 'text' } = req.body;

    const chat = await Chat.findByPk(req.params.id);

    if (!chat) {
      return res.status(404).json({ error: 'Chat not found' });
    }

    // Check if user is participant
    if (chat.participant1Id !== req.user.userId && chat.participant2Id !== req.user.userId) {
      return res.status(403).json({ error: 'Access denied' });
    }

    const message = await Message.create({
      chatId: req.params.id,
      senderId: req.user.userId,
      content,
      messageType
    });

    // Update chat's updatedAt
    await chat.update({ updatedAt: new Date() });

    const messageWithSender = await Message.findByPk(message.id, {
      include: [{
        model: User,
        as: 'sender',
        attributes: ['fullName', 'profilePicture']
      }]
    });

    res.status(201).json(messageWithSender);
  } catch (error) {
    console.error('Message creation error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Mark messages as read
router.put('/:id/read', auth, async (req, res) => {
  try {
    const chat = await Chat.findByPk(req.params.id);

    if (!chat) {
      return res.status(404).json({ error: 'Chat not found' });
    }

    // Check if user is participant
    if (chat.participant1Id !== req.user.userId && chat.participant2Id !== req.user.userId) {
      return res.status(403).json({ error: 'Access denied' });
    }

    // Mark messages from other participants as read
    const otherParticipantId = chat.participant1Id === req.user.userId
      ? chat.participant2Id
      : chat.participant1Id;

    await Message.update(
      { isRead: true },
      {
        where: {
          chatId: req.params.id,
          senderId: otherParticipantId,
          isRead: false
        }
      }
    );

    res.json({ message: 'Messages marked as read' });
  } catch (error) {
    console.error('Mark as read error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;