<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h1 class="main-title">Quản lý Đơn hàng</h1>
<p>Tổng số đơn hàng: <strong>${orderList.size()}</strong></p>

<table class="cart-table">
    <thead>
        <tr>
            <th>ID Đơn hàng</th>
            <th>ID Người mua</th>
            <th>Tổng tiền</th>
            <th>Địa chỉ giao hàng</th>
            <th>Ngày đặt</th>
            <th>Trạng thái</th>
        </tr>
    </thead>
    <tbody>
        <c:if test="${empty orderList}">
            <tr>
                <td colspan="6" style="text-align: center;">Không có đơn hàng nào.</td>
            </tr>
        </c:if>
        <c:forEach var="order" items="${orderList}">
            <tr>
                <td>#${order.orderId}</td>
                <td>${order.userId}</td>
                <td><fmt:formatNumber value="${order.totalPrice}" type="currency" currencyCode="VND"/></td>
                <td><c:out value="${order.shippingAddress}"/></td>
                <td>
                    <fmt:setLocale value="vi_VN"/>
                    <fmt:formatDate value="${order.orderDate}" pattern="HH:mm dd/MM/yyyy"/>
                </td>
                <td>
                     <span class="order-status 
                        <c:if test='${order.status == "Completed"}'>status-delivered</c:if>
                        <c:if test='${order.status == "Shipped" || order.status == "Pending"}'>status-delivering</c:if>
                        <c:if test='${order.status == "Cancelled"}'>status-cancelled</c:if>
                     ">
                        ${order.status}
                    </span>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>