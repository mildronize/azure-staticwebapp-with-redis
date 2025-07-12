import { useEffect, useState } from 'react';
import reactLogo from './assets/react.svg';
import viteLogo from '/vite.svg';
import './App.css';

function App() {
  const [count, setCount] = useState(0);

  const [data, setData] = useState<string>('');

  const initData = async () => {
    const apiURL = import.meta.env.VITE_API_URL as string | undefined;
    if(!apiURL) {
      throw new Error('VITE_API_URL is not defined');
    }
    const response = await fetch(`${apiURL}/api`);
    const result = await response.json() as { greeting: string };
    setData(result.greeting);
  }

  useEffect(() => {
    initData().catch((error) => {
      console.error('Error fetching data:', error);
      setData('Failed to fetch data');
    });
  }, []);

  return (
    <>
      <div>
        <a href="https://vitejs.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React + Hono + Azure Functions</h1>
      <h2>{data}</h2>
      <div className="card">
        <button onClick={() => setCount(count => count + 1)}>count is {count}</button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">Click on the Vite and React logos to learn more</p>
    </>
  );
}

export default App;
