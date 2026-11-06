export default function Placeholder({ title, height = 200 }) {
  return (
    <section className="card">
      <h2>{title}</h2>
      <div className="placeholder" style={{ minHeight: height }}>
        Placeholder
      </div>
    </section>
  )
}
