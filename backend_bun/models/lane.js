import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';
import Product from './product.js';
import Gantry from './gantry.js';

const Lane = sequelize.define('Lane', {
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
    },
    onDelete: 'NO ACTION',
    onUpdate: 'CASCADE'

  },
  gantryId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Gantry,
      key: 'id'
    }
  },
  make: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true
    }
  },
  model: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true
    }
  },
  serialNo: {
    type: DataTypes.STRING,
    allowNull: true,
    validate: {
      notEmpty: true
    }
  },
  flowRange: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true
    }
  },
  isEthanol: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false,
    comment: 'Whether this is for ethanol calibration'
  }
});

export default Lane;
