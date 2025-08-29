import app from './app.js';
import sequelize from './config/database.js';

const PORT = process.env.PORT || 3000;

// Database connection and sync
async function startServer() {
  try {
    // Test database connection
    await sequelize.authenticate();
    console.log('Database connection has been established successfully.');
    
    // Sync database (create tables)
    await sequelize.sync({ alter:true });
    console.log('Database synced successfully.');
    
    // Start server
    console.log(`Server running on port ${PORT}`);
    
    // For Bun, we need to use Bun.serve
    Bun.serve({
      port: PORT,
      fetch: app.fetch,
    });
    
    console.log(`🚀 Server started at http://localhost:${PORT}`);
  } catch (error) {
    console.error('Unable to start server:', error);
    process.exit(1);
  }
}

startServer();
