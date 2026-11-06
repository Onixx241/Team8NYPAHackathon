# Frontend (placeholder)

Plain HTML/CSS/JS with no build step. Each chart slot is an iframe that loads an HTML file exported from R.

## Run

```sh
cd frontend
python3 -m http.server 8000
# open http://localhost:8000
```

## Plug in R output

Save each chart into `frontend/charts/` with the filename the slot expects:

| Tab | File |
|---|---|
| Minimum | `charts/eui_predictor_simple.html`, `charts/model_comparison_min.html` |
| Intermediate | `charts/predicted_vs_actual.html`, `charts/metrics.html` |

Example from R:

```r
library(plotly); library(htmlwidgets)
saveWidget(ggplotly(scatter), "frontend/charts/predicted_vs_actual.html", selfcontained = TRUE)
```

Tables can be saved the same way with `DT::datatable(...)`.

To use a Shiny app instead, set that slot's `src` in `app.js` to its URL (for example `http://localhost:3838`).
Slots whose file is missing show a "Waiting for R output" placeholder.
