<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="admin_layout.jsp">
    <jsp:param name="title" value="Manage Orders"/>
</jsp:include>

<div class="container-fluid">
    <h1 class="mt-4">Manage Orders</h1>
    <div class="card mb-4">
        <div class="card-header"><i class="fas fa-shopping-cart mr-1"></i>Order List</div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>User ID</th>
                            <th>Total Price</th>
                            <th>Status</th>
                            <th>Order Date</th>
                            <th>Shipping Address</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${orderList}" var="order">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>${order.userId}</td>
                                <td>${order.totalPrice}</td>
                                <td>${order.status}</td>
                                <td>${order.orderDate}</td>
                                <td>${order.shippingAddress}</td>
                                <td>
                                     <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="update_status">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <select name="status" onchange="this.form.submit()">
                                            <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                            <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>Processing</option>
                                            <option value="Shipped" ${order.status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                                            <option value="Completed" ${order.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                            <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="admin_footer.jsp"/>