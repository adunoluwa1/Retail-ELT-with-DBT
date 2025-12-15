# 🛒 Retail Analytics dbt Project

This repository contains a dbt-based analytics engineering project that transforms raw retail data into analytics-ready tables for reporting, dashboards, and advanced analysis such as customer cohorts and retention.

The project follows dbt best practices with clear layer separation, testing, documentation, and reusable macros.

⸻

##  📐 Project Architecture

The project is organized into the following layers:

sources  →  staging  →  intermediate  →  marts
                         ↓
                      snapshots
                         ↓
                       tests


┌────────────────────┐
│   Source Tables    │
│  (public schema)   │
│                    │
│ orders              │
│ order_items         │
│ products            │
│ categories          │
│ departments         │
│ customers           │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│   Staging Layer    │
│    stg_retail__*   │
│                    │
│ Standardized names │
│ Type casting       │
│ Basic cleaning     │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│ Intermediate Layer │
│     int_* models   │
│                    │
│ Business logic     │
│ Joins & metrics    │
│ Fact & dim prep    │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│     Mart Layer     │
│  Analytics-ready   │
│                    │
│ dim_customers      │
│ sales_metrics      │
│ customer_cohorts   │
│ top_products       │
│ customer_order_cnt │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│ BI & Dashboards    │
│ Power BI / Tableau │
│ Looker / SQL       │
└────────────────────┘
Each layer has a clearly defined responsibility to ensure data quality, scalability, and maintainability.

⸻

## 🗂️ Data Sources (sources)

The sources layer defines the system-of-record tables ingested from the production database (public schema).

### Source Tables
	•	orders – Customer orders and order status
	•	order_items – Line-item details for each order
	•	products – Product attributes and pricing
	•	categories – Product categories
	•	departments – Department hierarchy
	•	customers – Customer profile and address data

Source definitions include:
	•	Business descriptions
	•	Column-level documentation
	•	Clear lineage into downstream models

⸻

## 🧪 Staging Layer (stg_)

The staging layer performs light transformations and standardization:
	•	Renames columns into analytics-friendly formats
	•	Applies basic data cleaning
	•	Preserves one-to-one row mapping with source tables

### Staging Models
	•	stg_retail__orders
	•	stg_retail__order_items
	•	stg_retail__products
	•	stg_retail__categories
	•	stg_retail__departments
	•	stg_retail__customers

### Key characteristics:
	•	Minimal business logic
	•	Primary key validation (unique, not_null)
	•	Designed as the foundation for downstream transformations

⸻

## 🔄 Intermediate Layer (int_)

The intermediate layer applies business logic and enrichment to prepare data for analytics use cases.

### Intermediate Models
	•	int_retail__orders – Orders enriched with timestamps and calendar attributes
	•	int_retail__order_items – Order-item grain with revenue calculations
	•	int_retail__customers – Cleaned customer dimension
	•	int_retail__products – Product attributes
	•	int_retail__categories – Category-to-department mapping
	•	int_retail__departments – Department dimension
	•	int_fact_sales – Core fact table at order-item grain
	•	int_dim_product – Denormalized product dimension

### Key features:
	•	Referential integrity tests
	•	Accepted values for order statuses
	•	Clear dimensional and fact modeling patterns

⸻

## 📊 Mart Layer (marts)

The mart layer provides analytics- and BI-ready tables optimized for reporting and decision-making.

### Mart Models
	•	dim_customers – Customer dimension for segmentation, LTV, and cohorts
	•	top_products – Product revenue rankings
	•	sales_metrics – Daily sales KPIs with rolling metrics
	•	customer_order_count – Customer behavior by order status
	•	customer_cohorts – Cohort and retention analysis by month

These models are:
	•	Fully documented
	•	Aggregated and business-ready
	•	Designed for tools like Power BI, Tableau, or Looker

⸻

## ⏳ Snapshots (snapshots)

Snapshots track historical changes over time.

Snapshot: snapshot_sales_metrics
	•	Tracks changes to the sales_metrics model
	•	Uses a timestamp-based strategy
	•	Enables historical trend and audit analysis

⸻

## 🧩 Macros (macros)

Reusable SQL logic is centralized in macros.

Macro: initcap_and_coalesce
	•	Applies INITCAP formatting
	•	Replaces NULL values with a default
	•	Ensures consistent text formatting across models

⸻

## ✅ Tests (tests)

Custom and built-in dbt tests ensure data quality and trust.

Example Custom Test
	•	Validates that:

quantity × product_price = subtotal


	•	Catches calculation and ingestion errors early

Other tests include:
	•	Primary key uniqueness
	•	Not-null constraints
	•	Referential integrity
	•	Accepted value validation

⸻

## 🚀 How to Run the Project
```
# Install dependencies
dbt deps

# Run models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
```

⸻

## 🎯 Key Analytics Use Cases Supported
	•	Revenue and sales performance tracking
	•	Product and category analysis
	•	Customer lifetime value (LTV)
	•	Customer retention and cohort analysis
	•	Operational monitoring and KPI reporting

⸻

## 🧠 Design Principles
	•	Clear layer separation
	•	Analytics engineering best practices
	•	BI-friendly modeling
	•	Strong documentation and testing
	•	Scalable and maintainable structure
