import { Prover } from '../models/index.js';

export const proverController = {
  // Get all provers
  getAll: async (c) => {
    try {
      const provers = await Prover.findAll();
      return c.json({ success: true, data: provers });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Get prover by ID
  getById: async (c) => {
    try {
      const id = c.req.param('id');
      const prover = await Prover.findByPk(id);
      
      if (!prover) {
        return c.json({ success: false, error: 'Prover not found' }, 404);
      }
      
      return c.json({ success: true, data: prover });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Create prover
  create: async (c) => {
    try {
      const {  make, model, serialNo, capacity,proverType } = await c.req.json();
      
      if (!make || !model || !serialNo || !capacity || !proverType) {
        return c.json({ success: false, error: 'All fields are required' }, 400);
      }
      
      const prover = await Prover.create({ 
        make, model, serialNo, capacity,proverType 
      });
      return c.json({ success: true, data: prover }, 201);
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Update prover
  update: async (c) => {
    try {
      const id = c.req.param('id');

      const { make, model, serialNo, capacity,proverType } = await c.req.json();
      
      const prover = await Prover.findByPk(id);
      if (!prover) {
        return c.json({ success: false, error: 'Prover not found' }, 404);
      }
      
      await prover.update({ 
        make, model, serialNo, capacity,proverType
      });
      return c.json({ success: true, data: prover });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Delete prover
  delete: async (c) => {
    try {
      const id = c.req.param('id');
      
      const prover = await Prover.findByPk(id);
      if (!prover) {
        return c.json({ success: false, error: 'Prover not found' }, 404);
      }
      
      await prover.destroy();
      return c.json({ success: true, message: 'Prover deleted successfully' });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  }
};
