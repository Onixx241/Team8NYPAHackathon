// Each slot shows one R output in an iframe.
// `src` can be a local HTML file saved from R (e.g. htmlwidgets::saveWidget)
// or a URL such as a running Shiny app (http://localhost:3838).
// If the file is missing, a placeholder card is shown instead.
const SLOTS = {
  minimum: [
    { title: "EUI summary", note: "Mean and median EUI across training buildings", src: "charts/eui_summary.html", wide: true },
    { title: "EUI by year built", note: "How energy per ft² changes with construction year", src: "charts/eui_by_year.html" },
    { title: "EUI by building height", note: "High-rise (10+ stories) vs. mid-rise (5–9) vs. other", src: "charts/eui_by_height.html" },
    { title: "EUI by number of bedrooms", note: "Bedrooms or bedroom density vs. EUI", src: "charts/eui_by_bedrooms.html" },
  ],
  intermediate: [
    { title: "Predicted vs. actual energy", note: "Testing file · dashed line = perfect prediction", src: "charts/predicted_vs_actual.html", wide: true },
    { title: "Accuracy vs. baseline", note: "MAE, MAPE and R² on the testing file", src: "charts/metrics.html" },
    { title: "10 largest errors", note: "Buildings using the most above or below prediction", src: "charts/top_errors.html" },
  ],
};

function placeholder(slot) {
  const div = document.createElement("div");
  div.className = "placeholder";
  div.innerHTML = `<strong>Waiting for R output</strong>
    <span>Save the chart from R to</span>
    <code>frontend/${slot.src}</code>`;
  return div;
}

async function exists(src) {
  if (/^https?:\/\//.test(src)) return true;          // external URL (e.g. Shiny): just try it
  if (location.protocol === "file:") return true;     // can't check from file://, let the iframe try
  try {
    const res = await fetch(src, { method: "HEAD", cache: "no-store" });
    return res.ok;
  } catch {
    return false;
  }
}

async function renderSlot(slot) {
  const card = document.createElement("article");
  card.className = "card" + (slot.wide ? " wide" : "");
  card.innerHTML = `<header><h3>${slot.title}</h3><p>${slot.note}</p></header>`;
  const frame = document.createElement("div");
  frame.className = "frame";
  card.appendChild(frame);

  if (slot.src && (await exists(slot.src))) {
    const iframe = document.createElement("iframe");
    iframe.src = slot.src;
    iframe.title = slot.title;
    iframe.loading = "lazy";
    frame.appendChild(iframe);
  } else {
    frame.appendChild(placeholder(slot));
  }
  return card;
}

async function init() {
  for (const grid of document.querySelectorAll("[data-slots]")) {
    const cards = await Promise.all(SLOTS[grid.dataset.slots].map(renderSlot));
    grid.append(...cards);
  }

  const buttons = document.querySelectorAll(".tabs button");
  buttons.forEach((btn) =>
    btn.addEventListener("click", () => {
      buttons.forEach((b) => b.setAttribute("aria-selected", String(b === btn)));
      document.querySelectorAll(".panel").forEach((p) => (p.hidden = p.id !== btn.dataset.tab));
    })
  );
}

init();
