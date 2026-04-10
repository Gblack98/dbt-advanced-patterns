# dbt Fintech — Advanced Patterns

A hands-on dbt learning project using DuckDB on a real-world loan default dataset (148,670 rows).
Covers advanced dbt patterns: incremental models, SCD Type 2, data contracts, custom macros, tests, exposures, groups & access, and slim CI.

---

## Stack

| Tool | Version |
|------|---------|
| dbt-core | 1.11.7 |
| dbt-duckdb | 1.10.1 |
| DuckDB | local (`dev.duckdb`) |
| Python | 3.12 |

---

## Dataset

**Source:** [Loan Default Dataset](https://www.kaggle.com/datasets/yasserh/loan-default-dataset) (Kaggle)
**File:** `seeds/Loan_Default.csv` — 148,670 loans from 2019
**Key columns:** `loan_id`, `region`, `credit_score`, `loan_amount`, `is_default`
**Regions:** south, North, central, North-East

---

## Project Structure

```
seeds/
└── Loan_Default.csv              ← raw data

models/
├── staging/
│   └── stg_loans.sql             ← cleaning + casting (view)
└── marts/
    ├── mart_loan_summary.sql     ← aggregation by region/year (table)
    └── mart_risk_profile.sql     ← credit score bucketing (incremental)

snapshots/
└── loan_status_snapshot.sql      ← SCD Type 2 history tracking

macros/
├── audit_log.sql                 ← post-hook: logs row count after each run
└── test_not_empty.sql            ← reusable generic test

tests/
├── assert_default_rate_reasonable.sql
└── assert_loan_summary_positive_loans.sql
```

---

## Concepts Covered

| Concept | File(s) |
|---------|---------|
| Incremental model | `mart_risk_profile.sql` |
| SCD Type 2 snapshot | `snapshots/loan_status_snapshot.sql` |
| Data Contracts | `models/marts/schema.yml` — `contract: enforced: true` |
| Post-hook macro | `macros/audit_log.sql` — uses `{{ this }}` to avoid DAG cycles |
| Custom generic test | `macros/test_not_empty.sql` |
| Singular tests | `tests/assert_*.sql` |
| Unit tests | `schema.yml` — top-level `unit_tests:` block |
| Exposures | `models/marts/exposures.yml` |
| Groups & Access | `models/staging/groups.yml` |
| Slim CI | `.github/workflows/dbt_ci.yml` |

---

## Setup

```bash
# Clone the repo
git clone git@github.com:Gblack98/dbt-advanced-patterns.git
cd dbt-advanced-patterns

# Create and activate virtualenv
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install dbt-core==1.11.7 dbt-duckdb==1.10.1

# Configure dbt profile (~/.dbt/profiles.yml)
cat >> ~/.dbt/profiles.yml << 'EOF'
dbt_fintech:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: dev.duckdb
      threads: 1
EOF
```

---

## Usage

```bash
cd dbt_fintech

# Load seed data
dbt seed

# Run all models
dbt run

# Run all tests
dbt test

# Run snapshots
dbt snapshot

# Inspect exposure DAG
dbt ls --select +exposure:loan_risk_dashboard

# List models in a group
dbt ls --select group:marts
```

---

## CI/CD — Slim CI

The `.github/workflows/dbt_ci.yml` workflow implements a **Slim CI** strategy:

- **First run:** full `dbt build` → saves `manifest.json` as a GitHub Actions artifact
- **Subsequent runs:** downloads previous manifest → runs only **modified models and their dependents** (`state:modified+`)

```
push / PR → seed → slim build (state:modified+) → upload manifest
```

---

## Key Results

### `mart_loan_summary` — Default rate by region

| Region | Default Rate |
|--------|-------------|
| North-East | 30.45% |
| central | ~27% |
| south | ~25% |
| North | 22.51% |

### `mart_risk_profile` — Default rate by credit score bucket

| Bucket | Score Range | Default Rate |
|--------|-------------|-------------|
| Bad | < 580 | 24.7% |
| Fair | 580–669 | 24.5% |
| Good | 670–739 | 24.2% |
| Very Good | 740–799 | 24.5% |
| Excellent | ≥ 800 | 25.2% |

> Note: similar default rates across buckets are an artifact of the synthetic Kaggle dataset.
