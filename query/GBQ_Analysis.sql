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