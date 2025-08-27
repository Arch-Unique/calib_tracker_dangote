import { Gantry, Product } from '../models/index.js';

export const gantryController = {
  // Get all gantries
  getAll: async (c) => {
    try {
      const gantries = await Gantry.findAll({
        include: ['product', 'lanes']
      });
      return c.json({ success: true, data: gantries });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Get gantry by ID
  getById: async (c) => {
    try {
      const id = c.req.param('id');
      const gantry = await Gantry.findByPk(id, {
        include: ['product', 'lanes']
      });
      
      if (!gantry) {
        return c.json({ success: false, error: 'Gantry not found' }, 404);
      }
      
      return c.json({ success: true, data: gantry });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Create gantry
  create: async (c) => {
    try {
      const { name, productId } = await c.req.json();
      
      if (!name || !productId) {
        return c.json({ success: false, error: 'Name and productId are required' }, 400);
      }
      
      // Check if product exists
      const product = await Product.findByPk(productId);
      if (!product) {
        return c.json({ success: false, error: 'Product not found' }, 404);
      }
      
      const gantry = await Gantry.create({ name, productId });
      return c.json({ success: true, data: gantry }, 201);
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Update gantry
  update: async (c) => {
    try {
      const id = c.req.param('id');
      const { name, productId } = await c.req.json();
      
      const gantry = await Gantry.findByPk(id);
      if (!gantry) {
        return c.json({ success: false, error: 'Gantry not found' }, 404);
      }
      
      // Check if product exists if productId is being updated
      if (productId) {
        const product = await Product.findByPk(productId);
        if (!product) {
          return c.json({ success: false, error: 'Product not found' }, 404);
        }
      }
      
      await gantry.update({ name, productId });
      return c.json({ success: true, data: gantry });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Delete gantry
  delete: async (c) => {
    try {
      const id = c.req.param('id');
      
      const gantry = await Gantry.findByPk(id);
      if (!gantry) {
        return c.json({ success: false, error: 'Gantry not found' }, 404);
      }
      
      await gantry.destroy();
      return c.json({ success: true, message: 'Gantry deleted successfully' });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  }
};
