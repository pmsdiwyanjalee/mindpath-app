const express = require('express');
const { User, Counsellor, Appointment, Resource } = require('../models');
const auth = require('../middleware/auth');

const router = express.Router();

// All admin routes require admin role
router.use(auth, (req, res, next) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Admin access required' });
  }
  next();
});

// Dashboard analytics
router.get('/analytics', async (req, res) => {
  try {
    const totalUsers = await User.count();
    const totalCounsellors = await Counsellor.count({ where: { isVerified: true } });
    const totalAppointments = await Appointment.count();
    const totalResources = await Resource.count({ where: { isPublished: true } });

    const recentAppointments = await Appointment.findAll({
      include: [
        {
          model: User,
          as: 'patient',
          attributes: ['fullName']
        },
        {
          model: Counsellor,
          as: 'counsellor',
          include: [{
            model: User,
            as: 'user',
            attributes: ['fullName']
          }]
        }
      ],
      order: [['createdAt', 'DESC']],
      limit: 10
    });

    res.json({
      totalUsers,
      totalCounsellors,
      totalAppointments,
      totalResources,
      recentAppointments
    });
  } catch (error) {
    console.error('Analytics fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Manage counsellors
router.get('/counsellors', async (req, res) => {
  try {
    const counsellors = await Counsellor.findAll({
      include: [{
        model: User,
        as: 'user',
        attributes: ['fullName', 'email', 'isActive']
      }],
      order: [['createdAt', 'DESC']]
    });
    res.json(counsellors);
  } catch (error) {
    console.error('Counsellors fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Verify counsellor
router.put('/counsellors/:id/verify', async (req, res) => {
  try {
    const [updatedRowsCount, updatedRows] = await Counsellor.update(
      { isVerified: true, updatedAt: new Date() },
      { where: { id: req.params.id }, returning: true }
    );

    if (updatedRowsCount === 0) {
      return res.status(404).json({ error: 'Counsellor not found' });
    }

    const counsellor = await Counsellor.findByPk(req.params.id, {
      include: [{
        model: User,
        as: 'user',
        attributes: ['fullName', 'email']
      }]
    });

    res.json(counsellor);
  } catch (error) {
    console.error('Counsellor verification error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Manage users
router.get('/users', async (req, res) => {
  try {
    const users = await User.findAll({
      attributes: { exclude: ['password'] },
      order: [['createdAt', 'DESC']]
    });
    res.json(users);
  } catch (error) {
    console.error('Users fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Update user status
router.put('/users/:id/status', async (req, res) => {
  try {
    const { isActive } = req.body;
    const [updatedRowsCount, updatedRows] = await User.update(
      { isActive, updatedAt: new Date() },
      { where: { id: req.params.id }, returning: true }
    );

    if (updatedRowsCount === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = await User.findByPk(req.params.id, {
      attributes: { exclude: ['password'] }
    });

    res.json(user);
  } catch (error) {
    console.error('User status update error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Support tickets (simplified - could be expanded)
router.get('/support-tickets', async (req, res) => {
  try {
    // For now, return empty array - can be expanded with a SupportTicket model
    res.json([]);
  } catch (error) {
    console.error('Support tickets fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;