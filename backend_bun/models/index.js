import Product from './product.js';
import Gantry from './gantry.js';
import Lane from './lane.js';
import ExternalCalibration from './calib.js';
import Prover from './prover.js';
import Batch from './batch.js';

// Define associations
Product.hasMany(Gantry, { foreignKey: 'productId', as: 'gantries' });
Gantry.belongsTo(Product, { foreignKey: 'productId', as: 'product' });

Product.hasMany(Lane, { foreignKey: 'productId', as: 'lanes' });
Lane.belongsTo(Product, { foreignKey: 'productId', as: 'product' });

Gantry.hasMany(Lane, { foreignKey: 'gantryId', as: 'lanes' });
Lane.belongsTo(Gantry, { foreignKey: 'gantryId', as: 'gantry', });

Lane.hasMany(ExternalCalibration, { foreignKey: 'laneId', as: 'calibrations' });
ExternalCalibration.belongsTo(Lane, { foreignKey: 'laneId', as: 'lane' });

Lane.hasMany(Batch, { foreignKey: 'laneId', as: 'batches' });
Batch.belongsTo(Lane, { foreignKey: 'laneId', as: 'lane' });

Prover.hasMany(Batch, { foreignKey: 'proverId', as: 'batches' });
Batch.belongsTo(Prover, { foreignKey: 'proverId', as: 'prover' });

export { Product, Gantry, Lane, ExternalCalibration,Prover,Batch };
