import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Prover = sequelize.define('Prover', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
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
  capacity: {
    type: DataTypes.STRING,
    allowNull: true,
    validate: {
      notEmpty: true
    }
  },
  proverType: {
    type: DataTypes.STRING,
    allowNull: true,
    validate: {
      notEmpty: true
    }
  },
  
});

export default Prover;
