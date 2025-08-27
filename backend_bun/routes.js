import { Hono } from 'hono';
import { productController } from './controllers/product.js';
import { laneController } from './controllers/lane.js';
import { gantryController } from './controllers/gantry.js';
import { proverController } from './controllers/prover.js';
import {externalCalibrationController} from './controllers/calib.js';

const allRoutes = new Hono();
allRoutes.get('/product', productController.getAll);
allRoutes.get('/product/:id', productController.getById);
allRoutes.post('/product', productController.create);
allRoutes.put('/product/:id', productController.update);
allRoutes.delete('/product/:id', productController.delete);

allRoutes.get('/gantry', gantryController.getAll);
allRoutes.get('/gantry/:id', gantryController.getById);
allRoutes.post('/gantry', gantryController.create);
allRoutes.put('/gantry/:id', gantryController.update);
allRoutes.delete('/gantry/:id', gantryController.delete);

allRoutes.get('/lane', laneController.getAll);
allRoutes.get('/lane/:id', laneController.getById);
allRoutes.post('/lane', laneController.create);
allRoutes.put('/lane/:id', laneController.update);
allRoutes.delete('/lane/:id', laneController.delete);

allRoutes.get('/prover', proverController.getAll);
allRoutes.get('/prover/:id', proverController.getById);
allRoutes.post('/prover', proverController.create);
allRoutes.put('/prover/:id', proverController.update);
allRoutes.delete('/prover/:id', proverController.delete);

allRoutes.get('/calib', externalCalibrationController.getAll);
allRoutes.get('/calib/latest', externalCalibrationController.getLatestCalibrations);
allRoutes.get('/calib/overdue', externalCalibrationController.getOverdueCalibrations);
allRoutes.get('/calib/:id', externalCalibrationController.getById);
allRoutes.get('/calib/lane/:laneId', externalCalibrationController.getByLaneId);
allRoutes.post('/calib/initialize', externalCalibrationController.initializeAllLanes);
allRoutes.post('/calib/complete', externalCalibrationController.completeCalibration);
allRoutes.post('/calib', externalCalibrationController.create);
allRoutes.put('/calib/:id', externalCalibrationController.update);
allRoutes.delete('/calib/:id', externalCalibrationController.delete);

export default allRoutes;