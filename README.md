# 🧠 Kimia Farma Business Performance Analysis
### *Big Data Analytics Project — Rakamin Academy x Kimia Farma*

![Kimia Farma Banner](https://lookerstudio.google.com/reporting/fe4354f5-53b7-4e43-a0f9-0e1bd53215ea/page/tWc6D)

---

## 👨‍💻 Author
**Raka Febrian Alfarizi**  
📍 Cikarang Selatan, Kab. Bekasi  
🎓 Mathematics Graduate, Universitas Brawijaya  
📊 Data Analyst | Python • SQL • Power BI • BigQuery  

🔗 [LinkedIn](https://www.linkedin.com/in/raka-febrian/) | [GitHub](https://github.com/Rakafebrian) | ✉️ alfarizi140204@gmail.com  

---

## 🧩 Project Overview

This project is part of the **Big Data Analytics – Kimia Farma x Rakamin Academy** program.  
It aims to analyze the **business performance of PT Kimia Farma (Persero) Tbk** during the period **2020–2023** using **Google BigQuery** and **Looker Studio**.  

Through this analysis, I explored sales trends, branch performance, product contributions, and customer satisfaction to generate actionable business insights.

---

## 🧮 SQL Data Modeling  

To create the main analysis table, the following SQL query was used:

```sql
CREATE OR REPLACE TABLE `kimia_farma.analysis` AS
SELECT
    t.transaction_id,
    t.date,
    t.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    p.product_category,
    p.price AS actual_price,
    t.discount_percentage,
    i.opname_stock,
    CASE
        WHEN p.price <= 50000 THEN '≤ 50K'
        WHEN p.price > 50000 AND p.price <= 100000 THEN '50K - 100K'
        WHEN p.price > 100000 AND p.price <= 300000 THEN '100K - 300K'
        WHEN p.price > 300000 AND p.price <= 500000 THEN '300K - 500K'
        WHEN p.price > 500000 THEN '> 500K'
    END AS price_range,
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        WHEN t.price > 500000 THEN 0.30
    END AS persentase_gross_laba,
    (t.price * (1 - t.discount_percentage)) AS nett_sales,
    (t.price * (1 - t.discount_percentage)) *
        CASE
            WHEN t.price <= 50000 THEN 0.10
            WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
            WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
            WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
            WHEN t.price > 500000 THEN 0.30
        END AS nett_profit,
    t.rating AS rating_transaksi
FROM
    `kimia_farma.kf_final_transaction` t
LEFT JOIN
    `kimia_farma.kf_kantor_cabang` kc ON t.branch_id = kc.branch_id
LEFT JOIN
    `kimia_farma.kf_product` p ON t.product_id = p.product_id
LEFT JOIN
    `kimia_farma.kf_inventory` i 
    ON t.branch_id = i.branch_id AND t.product_id = i.product_id;
```

### 🧩 Explanation
- **CREATE OR REPLACE TABLE**: Recreates the `analysis` table in the `kimia_farma` dataset.  
- **LEFT JOIN**: Combines four main tables (`kf_final_transaction`, `kf_kantor_cabang`, `kf_product`, `kf_inventory`) so that all transactions are retained even if related data is missing.  
- **CASE WHEN**:  
  - Categorizes product prices into ranges (*price_range*).  
  - Calculates *gross profit percentage* according to price levels.  
- **Nett Sales** = `price * (1 - discount_percentage)`  
- **Nett Profit** = *nett_sales × gross profit percentage*  
- **Result**: A unified dataset with branch, product, and transactional details enriched with computed business metrics.  

---

## 🔍 Exploratory Data Analysis (EDA)

After building the analysis table, EDA was performed to summarize branch-level performance:

```sql
SELECT
    COUNT(*) AS total_transactions,
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date,
    AVG(actual_price) AS average_price,
    AVG(discount_percentage) AS average_discount_percentage,
    AVG(persentase_gross_laba) AS average_gross_profit_percentage,
    SUM(nett_sales) AS total_net_sales,
    SUM(nett_profit) AS total_net_profit,
    AVG(rating_transaksi) AS average_transaction_rating,
    AVG(rating_cabang) AS average_branch_rating,
    branch_name,
    COUNT(DISTINCT customer_name) AS total_customers
FROM
    `kimia_farma.analysis`
GROUP BY
    branch_name
ORDER BY
    total_net_sales DESC;
```

### 🧩 Explanation
- **COUNT(*)**: Counts total transactions per branch.  
- **MIN() / MAX()**: Defines the transaction time range.  
- **AVG()**: Calculates averages for price, discount, profit %, and ratings.  
- **SUM()**: Aggregates total sales and profit per branch.  
- **COUNT(DISTINCT)**: Measures unique customer count.  
- **ORDER BY total_net_sales DESC**: Ranks branches by sales performance.  

💡 This EDA provides a clear overview of branch performance, product pricing, profit margin, and customer behavior across all regions.

---

## 📈 Dashboard Visualization  

An interactive **Performance Analytics Dashboard** was built using **Looker Studio**.  

### 🔗 [View Dashboard Here](https://lookerstudio.google.com/reporting/fe4354f5-53b7-4e43-a0f9-0e1bd53215ea)

**Dashboard Insights:**
- Revenue peaked in **2022** after pandemic recovery, with slight adjustment in 2023.  
- **West Java** led in total revenue, followed by **North Sumatra** and **Central Java**.  
- **Premium products (>Rp500K)** contributed **80% of total profit**.  
- A **service gap** exists between facility ratings and transaction experience.  

---

## 💡 Summary Insights  

| Aspect | Key Findings |
|---------|---------------|
| **Business Performance** | Revenue Rp425–438B per branch, profit margin ~25.6% |
| **Trend Over Time** | Peak in 2022, steady growth in Q3–Q4 each year |
| **Geographical** | West Java dominates revenue |
| **Product & Pricing** | Premium items drive profitability |
| **Customer Experience** | High branch ratings, but lower transaction satisfaction |

---

## 🛠️ Tools & Technologies  

| Category | Tools |
|-----------|-------|
| **Data Warehouse** | Google BigQuery |
| **Data Visualization** | Looker Studio |
| **Query Language** | SQL |
| **Data Analysis** | Google Cloud Platform |
| **Documentation** | Markdown, Google Slides, PDF |

---

## 🏁 Conclusion  

This project highlights how **SQL and BigQuery** can be used to create powerful data-driven insights.  
By combining structured queries and visualization dashboards, businesses like **Kimia Farma** can monitor performance, optimize product strategy, and enhance customer satisfaction.
