import { Batch, Lane, Prover } from '../models/index.js';

export const batchController = {
  // Get all batches
  getAll: async (c) => {
    try {
      const batches = await Batch.findAll({
        include: [
          { model: Lane, as: 'lane' },
          { model: Prover, as: 'prover' }
        ],
        order: [['createdAt', 'DESC']]
      });
      return c.json({ success: true, data: batches });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Get batch by ID
  getById: async (c) => {
    try {
      const id = c.req.param('id');
      const batch = await Batch.findByPk(id, {
        include: [
          { model: Lane, as: 'lane' },
          { model: Prover, as: 'prover' }
        ]
      });
      
      if (!batch) {
        return c.json({ success: false, error: 'Batch not found' }, 404);
      }
      
      return c.json({ success: true, data: batch });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Get batches by lane ID
  getByLaneId: async (c) => {
    try {
      const laneId = c.req.param('laneId');
      const batches = await Batch.findAll({
        where: { laneId },
        include: [
          { model: Lane, as: 'lane' },
          { model: Prover, as: 'prover' }
        ],
        order: [['createdAt', 'DESC']]
      });
      
      return c.json({ success: true, data: batches });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Create batch
  create: async (c) => {
    try {
      const { laneId, proverId, checkBy, calibBy, runs } = await c.req.json();
      
      // Validate required fields
      if (!laneId || !proverId || !checkBy || !calibBy || !runs) {
        return c.json({ success: false, error: 'All required fields must be provided' }, 400);
      }

      // Validate lane exists
      const lane = await Lane.findByPk(laneId);
      if (!lane) {
        return c.json({ success: false, error: 'Lane not found' }, 404);
      }

      // Validate prover exists
      const prover = await Prover.findByPk(proverId);
      if (!prover) {
        return c.json({ success: false, error: 'Prover not found' }, 404);
      }

      const batch = await Batch.create({
        laneId,
        proverId,
        checkBy,
        calibBy,
        runs
      });

      return c.json({ success: true, data: batch }, 201);
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Update batch
  update: async (c) => {
    try {
      const id = c.req.param('id');
      const updates = await c.req.json();
      
      const batch = await Batch.findByPk(id);
      if (!batch) {
        return c.json({ success: false, error: 'Batch not found' }, 404);
      }

      // If updating lane or prover, validate they exist
      if (updates.laneId) {
        const lane = await Lane.findByPk(updates.laneId);
        if (!lane) {
          return c.json({ success: false, error: 'Lane not found' }, 404);
        }
      }

      if (updates.proverId) {
        const prover = await Prover.findByPk(updates.proverId);
        if (!prover) {
          return c.json({ success: false, error: 'Prover not found' }, 404);
        }
      }
      
      await batch.update(updates);
      return c.json({ success: true, data: batch });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Delete batch
  delete: async (c) => {
    try {
      const id = c.req.param('id');
      
      const batch = await Batch.findByPk(id);
      if (!batch) {
        return c.json({ success: false, error: 'Batch not found' }, 404);
      }
      
      await batch.destroy();
      return c.json({ success: true, message: 'Batch deleted successfully' });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  }
};