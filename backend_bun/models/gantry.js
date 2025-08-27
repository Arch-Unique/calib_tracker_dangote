import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';
import Product from './product.js';

const Gantry = sequelize.define('Gantry', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true
    }
  },
  productId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Product,
      key: 'id'
    }
  }
});

export default Gantry;
