# Category Intelligence — Retail Product Performance EDA

**Calibo AI Academy · Path 2 · KLU Batch 16 · Phase 1 — Mini Use Case 01 (MUC01)**

Six months of retail transaction data turned into a supplier-review decision — plus **Clarity**, a live web app that runs the same cleaning-and-EDA workflow on any dataset.



---

## The question

A regional retail chain is preparing for its quarterly supplier review. Across 12 stores, 5 categories and 25 products, the Category Manager has no consolidated, trend-based view of which categories have earned their shelf space — so today the loudest supplier wins, not the best-performing one.

> **Which categories are growing or declining, which products drive category performance, and is the discount ladder actually working?**

## Headline findings

| Metric | Value | What it means |
| --- | --- | --- |
| Total revenue analysed | ₹459.8M | 107,836 transactions, Jan–Jun 2026 |
| Chain revenue trend | ₹84.8M → ₹69.3M | Down ₹15.5M/month over the half-year |
| Steepest decline | **Electronics, −35%** | ~49% of revenue; lost ₹16.0M of monthly revenue |
| Strongest growth | **Apparel, +34%** | Only category with sustained momentum |
| Discount effect on volume | 2.59 → 2.58 units | No volume gain from 0% to 20% discount |

**The three conclusions:**

1. **The decline is an Electronics problem, not a chain problem.** Electronics alone shed ₹16.0M in monthly revenue against a chain net decline of ₹15.5M — it accounts for the entire contraction while the rest of the portfolio stays broadly stable.
2. **Apparel is the only real growth engine.** A clean month-on-month climb from ₹10.0M to ₹13.5M; it overtakes Home & Kitchen by June.
3. **The discount ladder buys no extra volume.** Units per transaction hold at ~2.58 across every discount level while revenue per transaction falls ~22% (₹4,686 → ₹3,632). Discounts are handing back margin on sales that would have happened anyway — and since Saturday earns ~75% more than Monday (₹3.52M vs ₹2.01M), mid-week discounting is the least defensible spend of all.

A fourth, negative finding matters just as much: **there is no dead SKU.** Within every category the best and worst product differ by only 2–14%, so the actionable signal sits at category level, not product level.

---

## Repository structure

```
├── notebook/
│   └── Batch16_MUC01_KLU_Notebook.ipynb        # 7-step analysis (runs top-to-bottom, 0 errors)
├── data/
│   └── MUC01_Retail_Sales_Dataset.csv          # 107,836 transactions · Jan–Jun 2026
├── docs/
│   └── Batch16_MUC01_KLU_Summary.docx          # Team documentation & insight report
├── reports/
│   ├── Batch16_MUC01_KLU_Individual_Report_Naishadh_Vytla.docx
│   ├── Batch16_MUC01_KLU_Individual_Report_Adi_Seshu.docx
│   ├── Batch16_MUC01_KLU_Individual_Report_Sushmitha.docx
│   └── Batch16_MUC01_KLU_Individual_Report_Nakul_Sriraj.docx
├── deck/
│   └── Batch16_MUC01_KLU_Presentation.pptx     # "Category Pulse" — 10 slides
└── app/
    ├── index.html                              # Clarity — the whole app, one file
    ├── schema.sql                              # Supabase setup (tables, RLS, storage)
    └── logo/                                   # SVG + PNG icon set
```

---

## Running the notebook

**Google Colab (recommended):**
1. Open [colab.research.google.com](https://colab.research.google.com) → **Upload notebook** → `notebook/Batch16_MUC01_KLU_Notebook.ipynb`
2. Click the folder icon in the left sidebar → upload `data/MUC01_Retail_Sales_Dataset.csv` to the session root
3. **Runtime → Run all**

The notebook loads the CSV by relative path, so it must sit beside the notebook. Colab wipes session files on disconnect — re-upload the CSV if you return to a stale session.

**Locally:**
```bash
pip install pandas numpy matplotlib seaborn jupyter
jupyter notebook notebook/Batch16_MUC01_KLU_Notebook.ipynb
```

### Analysis steps

| Step | Section | Owner |
| --- | --- | --- |
| — | CBIM Problem Canvas | All four members |
| 1 | Load & inspect data · build the SSOT | Naishadh Vytla |
| 2 | Category revenue trend over time | Adi Seshu |
| 3 | Top & bottom products by category | Adi Seshu |
| 4 | Discount effectiveness | Sushmitha |
| 5 | Day-of-week & monthly patterns | Sushmitha |
| 6 | Category Manager Briefing | Nakul Sriraj |
| 7 | Conclusion & 90-day action roadmap | Nakul Sriraj |

### Method note — the SSOT

Every chart, table and figure derives from **one** cleaned DataFrame built once from the raw CSV. Before any analysis, `revenue` is verified as `units_sold × unit_price × (1 − discount_pct/100)` across all 107,836 rows. No re-reads, no divergent copies, one definition of every metric — that check is what makes the frame authoritative rather than merely loaded.

---

### Clarity — Web App

**Built by Naishadh Vytla and team for MUC01 .**

A general-purpose EDA platform with the workflow:

**Upload → Profile → Clean → Explore → Report → Export**

* Supports **CSV, TSV, JSON & XLSX**
* Transparent **data-quality scoring**
* Cleaning with **preview, apply & undo**; outliers are flagged, not deleted
* Automatic **EDA charts** based on column types
* **Correlation analysis** with strongest relationships
* **Deterministic, evidence-linked insights**
* Generates **SSOT reports** in HTML/PDF
* User accounts with **2 saved analyses per user**
* **Stack:** Single HTML + Supabase + Netlify + CDN libraries
* **No backend server required**
* Supports files up to roughly **50–100 MB** in-browser

**Link:** [Clarity EDA](https://clarityeda.netlify.app/?utm_source=chatgpt.com)




## Future work

- **Close the margin gap.** Every recommendation here rests on revenue alone. Ingesting category-level COGS would turn "back Apparel, challenge Electronics" from a top-line call into a profit call; footfall counts would separate demand shifts from basket-size effects.
- **Test the discount finding causally.** The flat units-per-transaction result is a strong observational finding, not a controlled one. A held-out A/B test on mid-week discounting would confirm that withdrawing promotions costs no volume before rolling it out chain-wide.
- **Productise the workflow.** [Clarity](https://clarityeda.netlify.app/) already generalises this pipeline to any dataset and enforces the SSOT discipline automatically, so next quarter's refresh becomes an upload-and-review task rather than a rebuild.

## Team — Batch 16

| Member | Role |
| --- | --- |
| **Naishadh Vytla** | Data foundation & SSOT · notebook assembly · |
| **Adi Seshu** | Product-level analysis · chart consistency · QA |
| **Sushmitha** | Promotion effectiveness · timing analysis · insight report |
| **Nakul Sriraj** | Business synthesis · stakeholder briefing · QA |

Each member's `reports/` document covers their scope, method, findings, business interpretation and reflection.

---

## Limitations

- **Revenue only — no cost or margin data.** A growing category could still be low-margin and a declining one highly profitable, so every recommendation rests on top-line performance. Category-level COGS would be needed to confirm these calls on profit.
- **No footfall or customer counts**, so genuine demand shifts cannot be separated from basket-size effects.
- Outliers were detected with the 1.5×IQR rule and **flagged, not confirmed** as errors.
- Correlations describe association only and do not establish causation.
- Findings reflect this six-month sample and may not generalise beyond it.

---

*Academic coursework for Calibo AI Academy. The dataset is synthetic and provided as part of the MUC01 brief.*
