// src/app.ts
import { Hono } from 'hono'
const app = new Hono().basePath('/api')

app.get('/', (c) => c.json({
  greeting: 'Hello from Hono on Azure Functions!',
}))

export default app