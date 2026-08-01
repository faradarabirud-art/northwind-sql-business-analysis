-- =====================================================
-- Northwind SQL Business Analysis Project
-- File: 03_business_analysis_queries.sql
-- Purpose: Business-focused SQL analysis queries
-- Author: Farad Arabi
-- =====================================================

USE northwind_ba;

-- =====================================================
-- Query 1: Executive KPI Summary
-- Business Question:
-- What is the overall sales performance of Northwind Traders?
-- =====================================================

SELECT
    COUNT(DISTINCT o.orderID) AS total_orders,
    COUNT(DISTINCT o.customerID) AS total_customers,
    SUM(od.quantity) AS total_units_sold,
    ROUND(SUM(od.unitPrice * od.quantity), 2) AS gross_sales,
    ROUND(SUM(od.unitPrice * od.quantity * od.discount), 2) AS total_discount,
    ROUND(SUM(od.unitPrice * od.quantity * (1 - od.discount)), 2) AS net_sales,
    ROUND(
        SUM(od.unitPrice * od.quantity * (1 - od.discount)) 
        / COUNT(DISTINCT o.orderID), 
        2
    ) AS average_order_value
FROM orders o
JOIN order_details od
    ON o.orderID = od.orderID;


-- =====================================================
-- Query 2: Sales Performance by Product Category
-- Business Question:
-- Which product categories generate the highest sales revenue?
-- =====================================================

SELECT 
    c.CategoryName AS category_name,
    ROUND(SUM(od.unitPrice * od.quantity), 2) AS gross_sales,
    ROUND(SUM(od.unitPrice * od.quantity * od.discount), 2) AS total_discount,
    ROUND(SUM(od.unitPrice * od.quantity * (1 - od.discount)), 2) AS net_sales,
    SUM(od.quantity) AS total_units_sold,
    COUNT(DISTINCT od.orderID) AS total_orders
FROM categories c
JOIN products p 
    ON p.categoryID = c.Category_ID
JOIN order_details od 
    ON od.productID = p.productID
GROUP BY c.CategoryName
ORDER BY net_sales DESC;


-- =====================================================
-- Query 3: Top 10 Products by Revenue
-- Business Question:
-- Which 10 products generate the highest net sales revenue?
-- =====================================================

SELECT 
    p.productName,
    c.CategoryName AS category_name,
    ROUND(SUM(od.unitPrice * od.quantity), 2) AS gross_sales,
    ROUND(SUM(od.unitPrice * od.quantity * od.discount), 2) AS total_discount,
    ROUND(SUM(od.unitPrice * od.quantity * (1 - od.discount)), 2) AS net_sales,
    SUM(od.quantity) AS total_units_sold,
    COUNT(DISTINCT od.orderID) AS total_orders
FROM products p 
JOIN order_details od 
    ON p.productID = od.productID
JOIN categories c 
    ON c.Category_ID = p.categoryID
GROUP BY 
    p.productID,
    p.productName,
    c.CategoryName
ORDER BY net_sales DESC
LIMIT 10;
