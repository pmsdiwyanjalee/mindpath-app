const express = require('express');
const { Appointment, User, Counsellor } = require('../models');
const auth = require('../middleware/auth');

const router = express.Router();

// Get user's appointments
router.get('/', auth, async (req, res) => {
  try {
    const appointments = await Appointment.findAll({
      where: {
        [require('sequelize').Op.or]: [
          { patientId: req.user.userId },
          { counsellorId: req.user.userId }
        ]
      },
      include: [
        {
          model: User,
          as: 'patient',
          attributes: ['fullName', 'email']
        },
        {
          model: Counsellor,
          as: 'counsellor',
          attributes: ['specialty'],
          include: [{
            model: User,
            as: 'user',
            attributes: ['fullName']
          }]
        }
      ],
      order: [['appointmentDate', 'ASC']]
    });

    res.json(appointments);
  } catch (error) {
    console.error('Appointments fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Create appointment
router.post('/', auth, async (req, res) => {
  try {
    const appointmentData = {
      ...req.body,
      patientId: req.user.role === 'patient' ? req.user.userId : req.body.patientId
    };

    const appointment = await Appointment.create(appointmentData);

    const populatedAppointment = await Appointment.findByPk(appointment.id, {
      include: [
        {
          model: User,
          as: 'patient',
          attributes: ['fullName', 'email']
        },
        {
          model: Counsellor,
          as: 'counsellor',
          attributes: ['specialty'],
          include: [{
            model: User,
            as: 'user',
            attributes: ['fullName']
          }]
        }
      ]
    });

    res.status(201).json(populatedAppointment);
  } catch (error) {
    console.error('Appointment creation error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Update appointment
router.put('/:id', auth, async (req, res) => {
  try {
    const appointment = await Appointment.findByPk(req.params.id);

    if (!appointment) {
      return res.status(404).json({ error: 'Appointment not found' });
    }

    // Check permissions
    if (req.user.role !== 'admin' &&
        appointment.patientId !== req.user.userId &&
        appointment.counsellorId !== req.user.userId) {
      return res.status(403).json({ error: 'Access denied' });
    }

    const [updatedRowsCount, updatedRows] = await Appointment.update(
      { ...req.body, updatedAt: new Date() },
      { where: { id: req.params.id }, returning: true }
    );

    if (updatedRowsCount === 0) {
      return res.status(404).json({ error: 'Appointment not found' });
    }

    const updatedAppointment = await Appointment.findByPk(req.params.id, {
      include: [
        {
          model: User,
          as: 'patient',
          attributes: ['fullName', 'email']
        },
        {
          model: Counsellor,
          as: 'counsellor',
          attributes: ['specialty'],
          include: [{
            model: User,
            as: 'user',
            attributes: ['fullName']
          }]
        }
      ]
    });

    res.json(updatedAppointment);
  } catch (error) {
    console.error('Appointment update error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Delete appointment
router.delete('/:id', auth, async (req, res) => {
  try {
    const appointment = await Appointment.findByPk(req.params.id);

    if (!appointment) {
      return res.status(404).json({ error: 'Appointment not found' });
    }

    // Check permissions
    if (req.user.role !== 'admin' &&
        appointment.patientId !== req.user.userId) {
      return res.status(403).json({ error: 'Access denied' });
    }

    await appointment.destroy();
    res.json({ message: 'Appointment deleted' });
  } catch (error) {
    console.error('Appointment deletion error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;

module.exports = router;