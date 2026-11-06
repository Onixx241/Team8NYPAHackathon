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
| Minimum | `charts/eui_summary.html`, `charts/eui_by_year.html`, `charts/eui_by_height.html`, `charts/eui_by_bedrooms.html` |
| Intermediate | `charts/predicted_vs_actual.html`, `charts/metrics.html`, `charts/top_errors.html`, `charts/pct_vs_average.html` |
| Advanced (mock) | `charts/model_comparison.html`, `charts/adv_predicted_vs_actual.html`, `charts/feature_importance.html`, `charts/above_prediction.html` |

The Advanced filters are disabled mock controls. Wiring them up for real is easiest with a Shiny app, or by exporting one file per filter combination.

Example from R:

```r
library(plotly); library(htmlwidgets)
saveWidget(ggplotly(scatter), "frontend/charts/predicted_vs_actual.html", selfcontained = TRUE)
```

Tables can be saved the same way with `DT::datatable(...)`.

To use a Shiny app instead, set that slot's `src` in `app.js` to its URL (for example `http://localhost:3838`).
Slots whose file is missing show a "Waiting for R output" placeholder.
