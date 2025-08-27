import { Sequelize } from "sequelize";

const sequelize = new Sequelize(
  process.env.DB_NAME || "your_database_name",
  null,
  null,
  {
    dialect: "mssql",
    logging: console.log, // Set to false to disable SQL query logging
    dialectOptions: {
      authentication: {
        type: "ntlm",
        options: {
          domain: process.env.DB_DOMAIN,
          userName: process.env.DB_USERNAME || "your_username",
          password: process.env.DB_PASSWORD || "your_password",
        },
      },
      options: {
        instanceName: "MSSQLSERVER",
        trustServerCertificate: true,
      },
    },
    pool: {
      max: 10,
      min: 0,
      acquire: 60000,
      idle: 10000,
    },
    define: {
      timestamps: true,
      underscored: false,
      freezeTableName: true, // Prevent Sequelize from pluralizing table names
    },
  }
);

export default sequelize;
