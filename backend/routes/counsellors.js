const express = require('express');
const { Counsellor, User } = require('../models');
const auth = require('../middleware/auth');

const router = express.Router();

// Get all counsellors
router.get('/', async (req, res) => {
  try {
    const counsellors = await Counsellor.findAll({
      where: { isVerified: true },
      include: [{
        model: User,
        as: 'user',
        attributes: ['fullName', 'email', 'profilePicture']
      }],
      attributes: { exclude: ['verificationDocuments'] }
    });
    res.json(counsellors);
  } catch (error) {
    console.error('Counsellors fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Get counsellor by ID
router.get('/:id', async (req, res) => {
  try {
    const counsellor = await Counsellor.findByPk(req.params.id, {
      include: [{
        model: User,
        as: 'user',
        attributes: ['fullName', 'email', 'profilePicture', 'phone']
      }],
      attributes: { exclude: ['verificationDocuments'] }
    });

    if (!counsellor) {
      return res.status(404).json({ error: 'Counsellor not found' });
    }

    res.json(counsellor);
  } catch (error) {
    console.error('Counsellor fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Create counsellor profile (for counsellors)
router.post('/', auth, async (req, res) => {
  try {
    if (req.user.role !== 'counsellor') {
      return res.status(403).json({ error: 'Access denied' });
    }

    const counsellorData = {
      userId: req.user.userId,
      ...req.body
    };

    const counsellor = await Counsellor.create(counsellorData);
    const counsellorWithUser = await Counsellor.findByPk(counsellor.id, {
      include: [{
        model: User,
        as: 'user',
        attributes: ['fullName', 'email']
      }]
    });

    res.status(201).json(counsellorWithUser);
  } catch (error) {
    console.error('Counsellor creation error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Update counsellor profile
router.put('/', auth, async (req, res) => {
  try {
    if (req.user.role !== 'counsellor') {
      return res.status(403).json({ error: 'Access denied' });
    }

    const [updatedRowsCount, updatedRows] = await Counsellor.update(
      { ...req.body, updatedAt: new Date() },
      { where: { userId: req.user.userId }, returning: true }
    );

    if (updatedRowsCount === 0) {
      return res.status(404).json({ error: 'Counsellor profile not found' });
    }

    const counsellor = await Counsellor.findOne({
      where: { userId: req.user.userId },
      include: [{
        model: User,
        as: 'user',
        attributes: ['fullName', 'email']
      }]
    });

    res.json(counsellor);
  } catch (error) {
    console.error('Counsellor update error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;