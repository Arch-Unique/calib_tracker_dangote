import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';
import Lane from './lane.js';

const ExternalCalibration = sequelize.define('ExternalCalibration', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  certPath: {
    type: DataTypes.STRING(500),
    allowNull: true,
    comment: 'Path to calibration certificate'
  },
  calibPath: {
    type: DataTypes.STRING(500),
    allowNull: true,
    comment: 'Path to calibration document'
  },
  poPath: {
    type: DataTypes.STRING(500),
    allowNull: true,
    comment: 'Path to purchase order document'
  },
  lastCalibDate: {
    type: DataTypes.DATE,
    allowNull: false,
    comment: 'Last calibration date'
  },
  dateDone: {
    type: DataTypes.DATE,
    allowNull: true,
    comment: 'Date when calibration was completed'
  },
  kFactor: {
    type: DataTypes.DECIMAL(10, 6),
    allowNull: false,
    comment: 'K-factor for flowmeter calibration'
  },
  laneId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Lane,
      key: 'id'
    },
    comment: 'Reference to lane'
  },
  eStatus: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: '',
    validate: {
      isIn: [['', 'PO Issued', 'PR Issued', 'Calibration Done']]
    },
    comment: 'Calibration status'
  },
  remark: {
    type: DataTypes.TEXT,
    allowNull: true,
    comment: 'Additional remarks or notes'
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: true,
    comment: 'Whether this calibration record is active'
  },
}, {
  tableName: 'ExternalCalibration',
  indexes: [
    {
      fields: ['laneId']
    },
    {
      fields: ['lastCalibDate']
    },
    {
      fields: ['dateDone']
    },
    {
      fields: ['isActive']
    }
  ]
});

export default ExternalCalibration;