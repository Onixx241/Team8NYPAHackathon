// Each slot shows one R output in an iframe.
// `src` can be a local HTML file saved from R (e.g. htmlwidgets::saveWidget)
// or a URL such as a running Shiny app (http://localhost:3838).
// If the file is missing, a placeholder card is shown instead.
const SLOTS = {
  minimum: [
    { title: "Simple predictor: predicted vs. actual EUI", note: "Year built + bedroom density · testing file, 2,495 buildings · dashed line = perfect prediction", src: "charts/eui_predictor_simple.html", wide: true },
    { title: "Model comparison", note: "Simple predictor vs. regression on the testing file", src: "charts/model_comparison_min.html", wide: true },
  ],
  intermediate: [
    { title: "Predicted vs. actual EUI", note: "Testing file, 2,495 buildings · dashed line = perfect prediction", src: "charts/predicted_vs_actual.html", wide: true },
    { title: "Regression accuracy", note: "Linear regression scored on the testing file", src: "charts/metrics.html" },
    { title: "What the numbers mean", note: "How to read the accuracy card", html: `
      <dl class="glossary">
        <div class="term"><dt>R²</dt><dd>How much of the difference between buildings the model explains, from 0 to 1.<span class="dir up">↑ Higher is better</span></dd></div>
        <div class="term"><dt>MAE</dt><dd>The average miss, in kBtu/ft².<span class="dir down">↓ Lower is better</span></dd></div>
        <div class="term"><dt>RMSE</dt><dd>Also an average miss, but big misses count more.<span class="dir down">↓ Lower is better</span></dd></div>
        <div class="term"><dt>MAPE</dt><dd>The average miss as a percent of actual use.<span class="dir down">↓ Lower is better</span></dd></div>
        <div class="term"><dt>Within 20%</dt><dd>Share of buildings predicted within 20% of their actual use.<span class="dir up">↑ Higher is better</span></dd></div>
      </dl>` },
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
  if (slot.html) {
    const body = document.createElement("div");
    body.className = "card-body";
    body.innerHTML = slot.html;
    card.appendChild(body);
    return card;
  }

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
