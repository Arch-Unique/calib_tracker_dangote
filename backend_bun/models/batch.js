import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';
import Lane from './lane.js';
import Prover from './prover.js';

const Batch = sequelize.define('Batch', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  laneId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Lane,
      key: 'id'
    },
    comment: 'Reference to lane being calibrated'
  },
  proverId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Prover,
      key: 'id'
    },
    comment: 'Reference to prover used for calibration'
  },
  checkBy: {
    type: DataTypes.STRING(100),
    allowNull: false,
    validate: {
      notEmpty: true
    },
    comment: 'Name of person who checked the calibration'
  },
  checkSignPath: {
    type: DataTypes.STRING(500),
    allowNull: true,
    comment: 'Path to checker signature image'
  },
  calibBy: {
    type: DataTypes.STRING(100),
    allowNull: false,
    validate: {
      notEmpty: true
    },
    comment: 'Name of person who performed the calibration'
  },
  calibBySigPath: {
    type: DataTypes.STRING(500),
    allowNull: true,
    comment: 'Path to calibrator signature image'
  },
  runs: {
    type: DataTypes.JSON,
    allowNull: false,
    defaultValue: [],
    validate: {
      isArray(value) {
        if (!Array.isArray(value)) {
          throw new Error('Runs must be an array');
        }
      }
    },
    comment: 'Array of calibration run data'
  }
}, {
  tableName: 'Batch',
  indexes: [
    {
      fields: ['laneId']
    },
    {
      fields: ['proverId']
    }
  ]
});

export default Batch;