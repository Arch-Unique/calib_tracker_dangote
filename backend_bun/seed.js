import { Product, Gantry, Lane, Prover } from "./models/index.js";
import sequelize from "./config/database.js";

async function seedData() {
  try {
    // Sync database
    await sequelize.sync({ force: true });

    // Create prover
    await Prover.bulkCreate([
      { make: "CRYOGENIC LIQUIDE PVT. LTD", model: "SS 304", capacity: "5000" , serialNo: "CRL/60/2018", proverType: "OPEN PROVER TANK" },
      { make: "CRYOGENIC LIQUIDE PVT. LTD", model: "SS 304", capacity: "5000" , serialNo: "CRL/61/2018", proverType: "OPEN PROVER TANK" },
      { make: "CRYOGENIC LIQUIDE PVT. LTD", model: "SS 304", capacity: "5000" , serialNo: "CRL/62/2018", proverType: "OPEN PROVER TANK" },
      { make: "CRYOGENIC LIQUIDE PVT. LTD", model: "SS 304", capacity: "5000" , serialNo: "CRL/63/2018", proverType: "OPEN PROVER TANK" },
      { make: "CRYOGENIC LIQUIDE PVT. LTD", model: "SS 304", capacity: "5000" , serialNo: "CRL/64/2018", proverType: "OPEN PROVER TANK" },
    ]);
    
    // Create products
    const products = await Product.bulkCreate([
      { name: "PMS" },
      { name: "AGO" },
      { name: "JETA1" },
      { name: "DPK" },
      { name: "SLURRY" },
      { name: "LPG" },
    ]);

    // Create gantries and lanes for each product
    for (let productIndex = 0; productIndex < products.length; productIndex++) {
      const product = products[productIndex];

      switch (productIndex) {
        case 0: // PMS - G1 to G4
          // Create G1-G4 gantries
          for (let g = 1; g <= 4; g++) {
            const gantry = await Gantry.create({
              name: `G${g}`,
              productId: product.id,
            });

            // Create lanes for G1 (10 sets of .1 and .2, each with ethanol variant)
            if (g === 1) {
              for (let i = 1; i <= 10; i++) {
                for (let suffix of [".1", ".2"]) {
                  await Lane.bulkCreate([
                    {
                      name: `G1.${i}${suffix}`,
                      productId: product.id,
                      gantryId: gantry.id,
                      make: "Micro Motion",
                      model: "CMF200M49N2BZEZZZ",
                      flowRange: "1800",
                      isEthanol: false,
                    },
                    {
                      name: `G1.${i}${suffix}`,
                      productId: product.id,
                      gantryId: gantry.id,
                      make: "Micro Motion",
                      model: "CMF200M49N2BZEZZZ",
                      flowRange: "1800",
                      isEthanol: true,
                    },
                  ]);
                }
              }
            } else {
              // Create lanes for G2-G4 (1-10 with ethanol variants)
              for (let i = 1; i <= 10; i++) {
                await Lane.bulkCreate([
                  {
                    name: `G${g}.${i}`,
                    productId: product.id,
                    gantryId: gantry.id,
                    make: "Micro Motion",
                    model: "CMF200M49N2BZEZZZ",
                    flowRange: "1800",
                    isEthanol: false,
                  },
                  {
                    name: `G${g}.${i}`,
                    productId: product.id,
                    gantryId: gantry.id,
                    make: "Micro Motion",
                    model: "CMF200M49N2BZEZZZ",
                    flowRange: "1800",
                    isEthanol: true,
                  },
                ]);
              }
            }
          }
          break;

        case 1: // AGO - G5 and G6
          const g5 = await Gantry.create({
            name: "G5",
            productId: product.id,
          });
          const g6 = await Gantry.create({
            name: "G6",
            productId: product.id,
          });

          // Create lanes for G5 (1-10)
          for (let i = 1; i <= 10; i++) {
            await Lane.create({
              name: `G5.${i}`,
              productId: product.id,
              gantryId: g5.id,
              make: "Micro Motion",
              model: "CMF200M49N2BZEZZZ",
              flowRange: "1800",
              isEthanol: false,
            });
          }

          // Create lanes for G6 (1-7)
          for (let i = 1; i <= 7; i++) {
            await Lane.create({
              name: `G6.${i}`,
              productId: product.id,
              gantryId: g6.id,
              make: "Micro Motion",
              model: "CMF200M49N2BZEZZZ",
              flowRange: "1800",
              isEthanol: false,
            });
          }
          break;

        case 2: // JETA1 - G7
          const g7 = await Gantry.create({
            name: "G7",
            productId: product.id,
          });
          for (let i = 1; i <= 10; i++) {
            await Lane.create({
              name: `G7.${i}`,
              productId: product.id,
              gantryId: g7.id,
              make: "Micro Motion",
              model: "CMF200M49N2BZEZZZ",
              flowRange: "1800",
              isEthanol: false,
            });
          }
          break;

        case 3: // DPK - G8
          const g8 = await Gantry.create({
            name: "G8",
            productId: product.id,
          });
          for (let i = 1; i <= 11; i++) {
            await Lane.create({
              name: `G8.${i}`,
              productId: product.id,
              gantryId: g8.id,
              make: "Micro Motion",
              model: "CMF200M49N2BZEZZZ",
              flowRange: "1800",
              isEthanol: false,
            });
          }
          break;

        case 4: // SLURRY - G9
          const g9 = await Gantry.create({
            name: "G9",
            productId: product.id,
          });
          for (let i = 1; i <= 3; i++) {
            await Lane.create({
              name: `G9.${i}`,
              productId: product.id,
              gantryId: g9.id,
              make: "Micro Motion",
              model: "CMF200M49N2BZEZZZ",
              flowRange: "1800",
              isEthanol: false,
            });
          }
          break;

        case 5: // LPG - G11
          const g11 = await Gantry.create({
            name: "G11",
            productId: product.id,
          });
          for (let i = 1; i <= 5; i++) {
            await Lane.create({
              name: `G11.${i}`,
              productId: product.id,
              gantryId: g11.id,
              make: "Micro Motion",
              model: "CMF200M49N2BZEZZZ",
              flowRange: "1800",
              isEthanol: false,
            });
          }
          break;
      }
    }

    console.log("Data seeding completed successfully");
  } catch (error) {
    console.error("Error seeding data:", error);
  } finally {
    await sequelize.close();
  }
}

// Run the seeding function
seedData();
