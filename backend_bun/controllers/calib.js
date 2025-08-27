import { ExternalCalibration, Lane, Product, Gantry } from '../models/index.js';
import { Op } from 'sequelize';
import sequelize from '../config/database.js';

export const externalCalibrationController = {
  // Get all calibrations
  getAll: async (c) => {
    try {
      const calibrations = await ExternalCalibration.findAll({
        include: [{
          model: Lane,
          as: 'lane',
          include: [
            { model: Product, as: 'product' },
            { model: Gantry, as: 'gantry' }
          ]
        }],
        order: [['laneId', 'ASC'], ['lastCalibDate', 'DESC']]
      });
      return c.json({ success: true, data: calibrations });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Get calibration by ID
  getById: async (c) => {
    try {
      const id = c.req.param('id');
      const calibration = await ExternalCalibration.findByPk(id, {
        include: [{
          model: Lane,
          as: 'lane',
          include: [
            { model: Product, as: 'product' },
            { model: Gantry, as: 'gantry' }
          ]
        }]
      });
      
      if (!calibration) {
        return c.json({ success: false, error: 'Calibration record not found' }, 404);
      }
      
      return c.json({ success: true, data: calibration });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Get latest calibrations for all lanes (the last 100 or all unique lanes)
  getLatestCalibrations: async (c) => {
    try {
      // Get the latest calibration for each lane
      const latestCalibrations = await ExternalCalibration.findAll({
        include: [{
          model: Lane,
          as: 'lane',
          include: [
            { model: Product, as: 'product' },
            { model: Gantry, as: 'gantry' }
          ]
        }],
        where: {
          id: {
            [Op.in]: await ExternalCalibration.findAll({
              attributes: [
                [sequelize.fn('MAX', sequelize.col('id')), 'maxId']
              ],
              group: ['laneId'],
              raw: true
            }).then(results => results.map(r => r.maxId))
          }
        },
        order: [['laneId', 'ASC']]
      });

      return c.json({ 
        success: true, 
        data: latestCalibrations,
        count: latestCalibrations.length 
      });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Get calibrations by lane ID
  getByLaneId: async (c) => {
    try {
      const laneId = c.req.param('laneId');
      const calibrations = await ExternalCalibration.findAll({
        where: { laneId },
        include: [{
          model: Lane,
          as: 'lane',
          include: [
            { model: Product, as: 'product' },
            { model: Gantry, as: 'gantry' }
          ]
        }],
        order: [['lastCalibDate', 'DESC']]
      });
      
      return c.json({ success: true, data: calibrations });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Initialize calibrations for all lanes
  initializeAllLanes: async (c) => {
    try {
      const { lastCalibDate, kFactor } = await c.req.json();
      
      if (!lastCalibDate || !kFactor) {
        return c.json({ 
          success: false, 
          error: 'lastCalibDate and kFactor are required' 
        }, 400);
      }

      // Get all lanes
      const lanes = await Lane.findAll();
      
      // Check which lanes already have calibration records
      const existingCalibrations = await ExternalCalibration.findAll({
        attributes: ['laneId'],
        group: ['laneId']
      });
      
      const existingLaneIds = existingCalibrations.map(cal => cal.laneId);
      const lanesToInitialize = lanes.filter(lane => !existingLaneIds.includes(lane.id));
      
      if (lanesToInitialize.length === 0) {
        return c.json({ 
          success: true, 
          message: 'All lanes already have calibration records',
          initialized: 0
        });
      }

      // Create initial calibration records for lanes that don't have them
      const calibrationData = lanesToInitialize.map(lane => ({
        laneId: lane.id,
        lastCalibDate: new Date(lastCalibDate),
        kFactor: parseFloat(kFactor),
        eStatus: '',
        isActive: true
      }));

      const createdCalibrations = await ExternalCalibration.bulkCreate(calibrationData);
      
      return c.json({ 
        success: true, 
        message: `Initialized calibration records for ${createdCalibrations.length} lanes`,
        data: createdCalibrations,
        initialized: createdCalibrations.length
      }, 201);
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Create calibration (usually when completing a calibration)
  create: async (c) => {
    try {
      const { 
        certPath, calibPath, poPath, lastCalibDate, dateDone, 
        kFactor, laneId, eStatus, remark, isActive = true 
      } = await c.req.json();
      
      if (!lastCalibDate || !kFactor || !laneId) {
        return c.json({ 
          success: false, 
          error: 'lastCalibDate, kFactor, and laneId are required' 
        }, 400);
      }
      
      // Check if lane exists
      const lane = await Lane.findByPk(laneId);
      if (!lane) {
        return c.json({ success: false, error: 'Lane not found' }, 404);
      }
      
      const calibration = await ExternalCalibration.create({ 
        certPath, calibPath, poPath, 
        lastCalibDate: new Date(lastCalibDate),
        dateDone: dateDone ? new Date(dateDone) : null,
        kFactor: parseFloat(kFactor), 
        laneId, eStatus, remark, 
        isActive: Boolean(isActive)
      });
      
      return c.json({ success: true, data: calibration }, 201);
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Complete calibration (creates new record with dateDone set)
  completeCalibration: async (c) => {
    try {
      const { 
        laneId, certPath, calibPath, poPath, dateDone, 
        kFactor, eStatus = 'COMPLETED', remark 
      } = await c.req.json();
      
      if (!laneId || !dateDone || !kFactor) {
        return c.json({ 
          success: false, 
          error: 'laneId, dateDone, and kFactor are required' 
        }, 400);
      }

      // Get the latest calibration record for this lane
      const latestCalibration = await ExternalCalibration.findOne({
        where: { laneId },
        order: [['lastCalibDate', 'DESC']]
      });

      if (!latestCalibration) {
        return c.json({ 
          success: false, 
          error: 'No existing calibration record found for this lane' 
        }, 404);
      }

      // Create new calibration record with dateDone as the new lastCalibDate
      const newCalibration = await ExternalCalibration.create({
        certPath,
        calibPath,
        poPath,
        lastCalibDate: new Date(dateDone), // The completion date becomes the new last calib date
        dateDone: new Date(dateDone),
        kFactor: parseFloat(kFactor),
        laneId,
        eStatus,
        remark,
        isActive: true
      });

      return c.json({ success: true, data: newCalibration }, 201);
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Update calibration
  update: async (c) => {
    try {
      const id = c.req.param('id');
      const { 
        certPath, calibPath, poPath, lastCalibDate, dateDone, 
        kFactor, eStatus, remark, isActive 
      } = await c.req.json();
      
      const calibration = await ExternalCalibration.findByPk(id);
      if (!calibration) {
        return c.json({ success: false, error: 'Calibration record not found' }, 404);
      }
      
      const updateData = {};
      if (certPath !== undefined) updateData.certPath = certPath;
      if (calibPath !== undefined) updateData.calibPath = calibPath;
      if (poPath !== undefined) updateData.poPath = poPath;
      if (lastCalibDate !== undefined) updateData.lastCalibDate = new Date(lastCalibDate);
      if (dateDone !== undefined) updateData.dateDone = dateDone ? new Date(dateDone) : null;
      if (kFactor !== undefined) updateData.kFactor = parseFloat(kFactor);
      if (eStatus !== undefined) updateData.eStatus = eStatus;
      if (remark !== undefined) updateData.remark = remark;
      if (isActive !== undefined) updateData.isActive = Boolean(isActive);
      
      await calibration.update(updateData);
      return c.json({ success: true, data: calibration });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Delete calibration
  delete: async (c) => {
    try {
      const id = c.req.param('id');
      
      const calibration = await ExternalCalibration.findByPk(id);
      if (!calibration) {
        return c.json({ success: false, error: 'Calibration record not found' }, 404);
      }
      
      await calibration.destroy();
      return c.json({ success: true, message: 'Calibration record deleted successfully' });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  // Get overdue calibrations (you can customize the overdue criteria)
  getOverdueCalibrations: async (c) => {
    try {
      const daysOverdue = parseInt(c.req.query('days') || '365'); // Default 365 days
      const overdueDate = new Date();
      overdueDate.setDate(overdueDate.getDate() - daysOverdue);

      const overdueCalibrations = await ExternalCalibration.findAll({
        where: {
          lastCalibDate: {
            [Op.lt]: overdueDate
          },
          dateDone: {
            [Op.is]: null
          },
          isActive: true
        },
        include: [{
          model: Lane,
          as: 'lane',
          include: [
            { model: Product, as: 'product' },
            { model: Gantry, as: 'gantry' }
          ]
        }],
        order: [['lastCalibDate', 'ASC']]
      });

      return c.json({ 
        success: true, 
        data: overdueCalibrations,
        overdueThreshold: daysOverdue 
      });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  }
};
