<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1 class="main-title">Dashboard</h1>
<style>
    .dashboard-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
    .dashboard-card { background: #fff; padding: 25px; text-align: center; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
    .dashboard-card h3 { margin-top: 0; color: #555; }
    .dashboard-card .count { font-size: 2.5em; font-weight: bold; color: #0d6efd; }
</style>
<div class="dashboard-grid">
    <div class="dashboard-card"><h3>Người dùng</h3><p class="count">${totalUsers}</p></div>
    <div class="dashboard-card"><h3>Sản phẩm</h3><p class="count">${totalProducts}</p></div>
    <div class="dashboard-card"><h3>Bài viết</h3><p class="count">${totalPosts}</p></div>
    <div class="dashboard-card"><h3>Đơn hàng</h3><p class="count">${totalOrders}</p></div>
</div>