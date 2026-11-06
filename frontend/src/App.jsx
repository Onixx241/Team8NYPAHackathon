import Placeholder from './components/Placeholder.jsx'

export default function App() {
  return (
    <div className="app">
      <header className="header">
        <h1>NYC Multifamily Building Energy</h1>
        <p>NYPA Hackathon · Use Case 2 · Team 8</p>
      </header>

      <div className="layout">
        <aside className="sidebar">
          <Placeholder title="Filters" height={300} />
        </aside>

        <main className="content">
          <div className="grid kpis">
            <Placeholder title="KPI 1" height={60} />
            <Placeholder title="KPI 2" height={60} />
            <Placeholder title="KPI 3" height={60} />
            <Placeholder title="KPI 4" height={60} />
          </div>

          <div className="grid two">
            <Placeholder title="Chart 1" height={260} />
            <Placeholder title="Chart 2" height={260} />
          </div>

          <Placeholder title="Table" height={220} />
        </main>
      </div>
    </div>
  )
}
