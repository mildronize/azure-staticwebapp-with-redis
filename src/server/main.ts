import { createAzureFunctionsHandler } from 'trpc-azure-functions-adapter';
import { app} from '@azure/functions'
import { appRouter } from './api/root';
import { createContext } from './api/trpc';

app.http('trpc', {
  methods: ['GET', 'POST'],
  authLevel: 'anonymous',
  route: 'trpc/{*proxy}',
  handler: createAzureFunctionsHandler({
    router: appRouter,
    createContext,
  }),
});