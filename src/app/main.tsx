import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { TRPCReactProvider } from "~/trpc/react";
import App from './App';
import './index.css';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <TRPCReactProvider>
      <App />
    </TRPCReactProvider>
  </StrictMode>
);
