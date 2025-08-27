import { Hono } from "hono";
import { cors } from "hono/cors";
import allRoutes from "./routes.js";
import { errorHandler } from "./config/middleware.js";
import { logger } from "hono/logger";
import { serveStatic } from "hono/bun";

const app = new Hono();

// Middleware
app.use(
  "*",
  cors({
    origin: '*',
    allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowHeaders: ["Content-Type", "Authorization"],
  })
);

app.use("*", logger());

// Routes
app.get("/", (c) => c.json({ message: "API is running!" }));
app.route("/api", allRoutes);

// Serve admin interface
app.get("/admin", (c) => c.redirect("/admin/")); // Redirect /admin to /admin/
app.use("/admin/*", serveStatic({ root: "./public" }));
app.get("/admin/", serveStatic({ path: "./public/index.html" }));

// Error handling
app.onError(errorHandler);

// 404 handler
app.notFound((c) => c.json({ error: "Not Found" }, 404));

export default app;
