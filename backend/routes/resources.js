const express = require('express');
const { Resource, User } = require('../models');
const auth = require('../middleware/auth');
const { Op } = require('sequelize');

const router = express.Router();

// Get all published resources
router.get('/', async (req, res) => {
  try {
    const { category, language, search } = req.query;
    let whereClause = { isPublished: true };

    if (category) whereClause.category = category;
    if (language) whereClause.language = language;
    if (search) {
      whereClause[Op.or] = [
        { title: { [Op.iLike]: `%${search}%` } },
        { content: { [Op.iLike]: `%${search}%` } },
        { tags: { [Op.contains]: [search] } }
      ];
    }

    const resources = await Resource.findAll({
      where: whereClause,
      include: [{
        model: User,
        as: 'author',
        attributes: ['fullName']
      }],
      order: [['publishedAt', 'DESC']]
    });

    res.json(resources);
  } catch (error) {
    console.error('Resources fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Get resource by ID
router.get('/:id', async (req, res) => {
  try {
    const resource = await Resource.findByPk(req.params.id, {
      include: [{
        model: User,
        as: 'author',
        attributes: ['fullName']
      }]
    });

    if (!resource || !resource.isPublished) {
      return res.status(404).json({ error: 'Resource not found' });
    }

    // Increment view count
    await resource.increment('viewCount', { by: 1 });

    res.json(resource);
  } catch (error) {
    console.error('Resource fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Create resource (admin/counsellor only)
router.post('/', auth, async (req, res) => {
  try {
    if (!['admin', 'counsellor'].includes(req.user.role)) {
      return res.status(403).json({ error: 'Access denied' });
    }

    const resourceData = {
      ...req.body,
      authorId: req.user.userId
    };

    const resource = await Resource.create(resourceData);

    const populatedResource = await Resource.findByPk(resource.id, {
      include: [{
        model: User,
        as: 'author',
        attributes: ['fullName']
      }]
    });

    res.status(201).json(populatedResource);
  } catch (error) {
    console.error('Resource creation error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Update resource
router.put('/:id', auth, async (req, res) => {
  try {
    const resource = await Resource.findByPk(req.params.id);

    if (!resource) {
      return res.status(404).json({ error: 'Resource not found' });
    }

    // Check permissions
    if (req.user.role !== 'admin' && resource.authorId !== req.user.userId) {
      return res.status(403).json({ error: 'Access denied' });
    }

    const [updatedRowsCount, updatedRows] = await Resource.update(
      { ...req.body, updatedAt: new Date() },
      { where: { id: req.params.id }, returning: true }
    );

    if (updatedRowsCount === 0) {
      return res.status(404).json({ error: 'Resource not found' });
    }

    const updatedResource = await Resource.findByPk(req.params.id, {
      include: [{
        model: User,
        as: 'author',
        attributes: ['fullName']
      }]
    });

    res.json(updatedResource);
  } catch (error) {
    console.error('Resource update error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Delete resource
router.delete('/:id', auth, async (req, res) => {
  try {
    const resource = await Resource.findByPk(req.params.id);

    if (!resource) {
      return res.status(404).json({ error: 'Resource not found' });
    }

    // Check permissions
    if (req.user.role !== 'admin' && resource.authorId !== req.user.userId) {
      return res.status(403).json({ error: 'Access denied' });
    }

    await resource.destroy();
    res.json({ message: 'Resource deleted' });
  } catch (error) {
    console.error('Resource deletion error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Get all resources (admin only, including drafts)
router.get('/admin/all', auth, async (req, res) => {
  try {
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied' });
    }

    const resources = await Resource.findAll({
      include: [{
        model: User,
        as: 'author',
        attributes: ['fullName']
      }],
      order: [['createdAt', 'DESC']]
    });

    res.json(resources);
  } catch (error) {
    console.error('Admin resources fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;