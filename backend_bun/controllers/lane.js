import { Lane, Product, Gantry } from '../models/index.js';

export const laneController = {
  // Get all lanes
  getAll: async (c) => {
    try {
      const lanes = await Lane.findAll({
        include: ['product', 'gantry']
      });
      return c.json({ success: true, data: lanes });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Get lane by ID
  getById: async (c) => {
    try {
      const id = c.req.param('id');
      const lane = await Lane.findByPk(id, {
        include: ['product', 'gantry']
      });
      
      if (!lane) {
        return c.json({ success: false, error: 'Lane not found' }, 404);
      }
      
      return c.json({ success: true, data: lane });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Create lane
  create: async (c) => {
    try {
      const { name, productId, gantryId, make, model, serialNo, flowRange,isEthanol='false' } = await c.req.json();
      
      if (!name || !productId || !gantryId || !make || !model || !serialNo || !flowRange) {
        return c.json({ success: false, error: 'All fields are required' }, 400);
      }
      
      // Check if product exists
      const product = await Product.findByPk(productId);
      if (!product) {
        return c.json({ success: false, error: 'Product not found' }, 404);
      }
      
      // Check if gantry exists
      const gantry = await Gantry.findByPk(gantryId);
      if (!gantry) {
        return c.json({ success: false, error: 'Gantry not found' }, 404);
      }
      
      const lane = await Lane.create({ 
        name, productId, gantryId, make, model, serialNo, flowRange ,isEthanol: isEthanol === 'true'
      });
      return c.json({ success: true, data: lane }, 201);
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Update lane
  update: async (c) => {
    try {
      const id = c.req.param('id');

      const { name, productId, gantryId, make, model, serialNo, flowRange,isEthanol='false' } = await c.req.json();
      
      const lane = await Lane.findByPk(id);
      if (!lane) {
        return c.json({ success: false, error: 'Lane not found' }, 404);
      }
      
      // Check if product exists if productId is being updated
      if (productId) {
        const product = await Product.findByPk(productId);
        if (!product) {
          return c.json({ success: false, error: 'Product not found' }, 404);
        }
      }
      
      // Check if gantry exists if gantryId is being updated
      if (gantryId) {
        const gantry = await Gantry.findByPk(gantryId);
        if (!gantry) {
          return c.json({ success: false, error: 'Gantry not found' }, 404);
        }
      }
      
      await lane.update({ 
        name, productId, gantryId, make, model, serialNo, flowRange ,isEthanol: isEthanol === 'true'
      });
      return c.json({ success: true, data: lane });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Delete lane
  delete: async (c) => {
    try {
      const id = c.req.param('id');
      
      const lane = await Lane.findByPk(id);
      if (!lane) {
        return c.json({ success: false, error: 'Lane not found' }, 404);
      }
      
      await lane.destroy();
      return c.json({ success: true, message: 'Lane deleted successfully' });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  }
};
