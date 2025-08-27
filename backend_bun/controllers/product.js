import { Product } from '../models/index.js';

export const productController = {
  // Get all products
  getAll: async (c) => {
    try {
      const products = await Product.findAll({
        include: ['gantries', 'lanes']
      });
      return c.json({ success: true, data: products });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Get product by ID
  getById: async (c) => {
    try {
      const id = c.req.param('id');
      const product = await Product.findByPk(id, {
        include: ['gantries', 'lanes']
      });
      
      if (!product) {
        return c.json({ success: false, error: 'Product not found' }, 404);
      }
      
      return c.json({ success: true, data: product });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Create product
  create: async (c) => {
    try {
      const { name } = await c.req.json();
      
      if (!name) {
        return c.json({ success: false, error: 'Name is required' }, 400);
      }
      
      const product = await Product.create({ name });
      return c.json({ success: true, data: product }, 201);
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Update product
  update: async (c) => {
    try {
      const id = c.req.param('id');
      const { name } = await c.req.json();
      
      const product = await Product.findByPk(id);
      if (!product) {
        return c.json({ success: false, error: 'Product not found' }, 404);
      }
      
      await product.update({ name });
      return c.json({ success: true, data: product });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Delete product
  delete: async (c) => {
    try {
      const id = c.req.param('id');
      
      const product = await Product.findByPk(id);
      if (!product) {
        return c.json({ success: false, error: 'Product not found' }, 404);
      }
      
      await product.destroy();
      return c.json({ success: true, message: 'Product deleted successfully' });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  }
};
