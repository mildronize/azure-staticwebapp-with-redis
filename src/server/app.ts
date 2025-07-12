// src/app.ts
import { Hono } from 'hono'
import { cors } from 'hono/cors';

const rawOrigins = process.env.CORS_ORIGINS ?? ''
const allowlist = rawOrigins.split(',').map(o => o.trim()).filter(Boolean)

const app = new Hono().basePath('/api')

app.use(
  cors({
    origin: allowlist,
    allowMethods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowHeaders: ['Content-Type', 'Authorization'],
    exposeHeaders: ['Content-Length', 'X-Request-Id'],
    credentials: true,
    maxAge: 600,
  })
)

app.get('/', (c) => c.json({
  greeting: 'Hello from Hono on Azure Functions!',
}))

export default app