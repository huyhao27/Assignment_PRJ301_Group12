<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h1 class="main-title">Quản lý Sản phẩm</h1>
<p>Tổng số sản phẩm: <strong>${productList.size()}</strong></p>

<table class="cart-table">
    <thead>
        <tr>
            <th style="width: 5%;">ID</th>
            <th style="width: 10%;">Ảnh</th>
            <th style="width: 30%;">Tên sản phẩm</th>
            <th style="width: 15%;">Người bán (ID)</th>
            <th style="width: 15%;">Giá</th>
            <th style="width: 10%;">Số lượng</th>
            <th style="width: 10%;">Hành động</th>
        </tr>
    </thead>
    <tbody>
         <c:if test="${empty productList}">
            <tr>
                <td colspan="7" style="text-align: center;">Không có sản phẩm nào.</td>
            </tr>
        </c:if>
        <c:forEach var="product" items="${productList}">
            <tr>
                <td>${product.productId}</td>
                <td>
                     <c:if test="${not empty product.image}">
                        <img src="${pageContext.request.contextPath}/images/product/${product.image}" alt="Product Image" style="width: 80px; height: 80px; object-fit: cover; border-radius: 4px;">
                    </c:if>
                </td>
                <td><c:out value="${product.productName}"/></td>
                <td>${product.sellerId}</td>
                <td><fmt:formatNumber value="${product.price}" type="currency" currencyCode="VND"/></td>
                <td>${product.quantity}</td>
                <td>
                     <form action="${pageContext.request.contextPath}/admin/products" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <button type="submit" class="delete-btn" style="color: red;">Xóa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>