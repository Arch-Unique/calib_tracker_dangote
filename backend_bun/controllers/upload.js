import { join, dirname } from 'path';
import sharp from 'sharp';
import { writeFile, mkdir } from 'fs/promises';
import { ExternalCalibration, Lane } from '../models/index.js';

const UPLOAD_DIR = 'uploads';
const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'application/pdf'];

const ensureUploadDir = async (subDir) => {
  const fullPath = join(process.cwd(), UPLOAD_DIR, subDir);
  await mkdir(fullPath, { recursive: true });
  return fullPath;
};

const processFile = async (file, subDir,fname) => {
  const fileName = `${fname}-${Date.now()}.webp`;
  const uploadPath = await ensureUploadDir(subDir);
  const filePath = join(uploadPath, fileName);

  if (file.type.startsWith('image/')) {
    await sharp(await file.arrayBuffer())
      .resize(1200, 1200, { fit: 'inside', withoutEnlargement: true })
      .webp()
      .toFile(filePath);
  } else {
    await writeFile(filePath, await file.arrayBuffer());
  }

  return join(UPLOAD_DIR, subDir, fileName);
};

export const uploadController = {
  uploadExternalCheck: async (c) => {
    try {
      const formData = await c.req.parseBody();
      const file = formData['file'];
      const lane = formData['lane'];
      const location = formData['location'];

      if (!file || !lane || !location) {
        return c.json({ 
          success: false, 
          error: 'Missing file, lane, or location' 
        }, 400);
      }

      if (!ALLOWED_TYPES.includes(file.type)) {
        return c.json({ 
          success: false, 
          error: 'Invalid file type' 
        }, 400);
      }
      const calibration = await ExternalCalibration.findOne({
        where: { 
          laneId: lane,
          isActive: true 
        },
        order: [['lastCalibDate', 'DESC']]
      });

      if (!calibration) {
        return c.json({ 
          success: false, 
          error: 'No active calibration found' 
        }, 404);
      }

      const filePath = await processFile(file, `external_checks/${lane}`,'ec');
      
      await calibration.update({
        calibPath: filePath,
        dateDone: new Date(),
      });

      return c.json({ 
        success: true, 
        data: { filePath } 
      });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

   uploadRuns: async (c) => {
    try {
      const formData = await c.req.parseBody();
      const file = formData['file'];

      if (!file) {
        return c.json({ 
          success: false, 
          error: 'Missing file' 
        }, 400);
      }

      if (!ALLOWED_TYPES.includes(file.type)) {
        return c.json({ 
          success: false, 
          error: 'Invalid file type' 
        }, 400);
      }

      const filePath = await processFile(file, `batch`,'runs');

      return c.json({ 
        success: true, 
        data: filePath 
      });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  uploadCalibrationCertificate: async (c) => {
    try {
      const formData = await c.req.parseBody();
      const file = formData['file'];
      const lane = formData['lane'];
      const location = formData['location'];
      const kFactor = formData['kFactor'];

      if (!file || !lane || !location || !kFactor) {
        return c.json({ 
          success: false, 
          error: 'Missing required fields' 
        }, 400);
      }

      if (!ALLOWED_TYPES.includes(file.type)) {
        return c.json({ 
          success: false, 
          error: 'Invalid file type' 
        }, 400);
      }

      const calibration = await ExternalCalibration.findOne({
        where: { 
          laneId: lane,
          isActive: true 
        },
        order: [['lastCalibDate', 'DESC']]
      });

      if (!calibration) {
        return c.json({ 
          success: false, 
          error: 'No active calibration found' 
        }, 404);
      }

      const filePath = await processFile(file, `certificates/${lane}`,"c");

      await calibration.update({
        certPath: filePath,
        kFactor: parseFloat(kFactor),
        eStatus: 'Calibration Done'
      });

      // Create new calibration record
      await ExternalCalibration.create({
        laneId: lane,
        lastCalibDate: new Date(),
        kFactor: parseFloat(kFactor),
        isActive: calibration.isActive,
        remark: calibration.remark
      });

      return c.json({ 
        success: true, 
        data: { filePath } 
      });
    } catch (error) {
      return c.json({ success: false, error: error.message }, 500);
    }
  },

  uploadPurchaseOrder: async (c) => {
    try {
      const formData = await c.req.parseBody({all: true});
      const file = formData['file'];
      const location = formData['location'];
      const lanes = formData['lanes'];

      if (!file || !location || !lanes.length) {
        return c.json({ 
          success: false, 
          error: 'Missing required fields' 
        }, 400);
      }

      if (!ALLOWED_TYPES.includes(file.type)) {
        return c.json({ 
          success: false, 
          error: 'Invalid file type' 
        }, 400);
      }

      const filePath = await processFile(file, 'purchase_orders',"po");

      // Update all specified lanes
      console.log(lanes);
      for (const laneId of lanes) {
        console.log(laneId);
        const calibration = await ExternalCalibration.findOne({
          where: { 
            laneId: Number(laneId),
            isActive: true 
          },
          order: [['lastCalibDate', 'DESC']]
        });

        if (calibration) {
          await calibration.update({
            poPath: filePath,
            eStatus: 'PO Issued'
          });
        }
      }

      return c.json({ 
        success: true, 
        data: { 
          filePath,
          updatedLanes: lanes.length 
        } 
      });
    } catch (error) {
      console.log(error);
      return c.json({ success: false, error: error.message }, 500);
    }
  }
};