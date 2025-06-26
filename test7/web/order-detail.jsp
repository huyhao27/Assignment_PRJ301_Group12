<%-- 
    Document   : processing-order
    Created on : Jun 11, 2025, 11:34:33 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Processing Order</title>
        <link rel="stylesheet" href="./assets/css/stylesheet.css?v=8">
    </head>
    <body>
        <jsp:include page="./assets/includes/sidebar.jsp" />
        <jsp:include page="./assets/includes/header.jsp" />
        <jsp:include page="./assets/includes/chat.jsp" />

        <%
            Account acc = (Account) session.getAttribute("account");
                if (acc == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
                
            int userId = acc.getUserId();
            AccountDAO accDAO = new AccountDAO();
            OrderDAO orderDAO = new OrderDAO();
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            ProductDAO productDAO = new ProductDAO();
            
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            ArrayList<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(orderId);
            Order order = orderDAO.getOrderById(orderId);
        %>

        <div class="main-content">
            <div class="order-container">
                <div class="order-header">
                    <div class="order-info">
                        <h2>Đơn hàng #DH<%= orderId %></h2>
                        <%if(order.getStatus().equals("Pending")||order.getStatus().equals("Processing")||order.getStatus().equals("Shipped")){%>
                        <div class="order-status status-delivering"><%= order.getStatus() %></div>
                        <%} else if(order.getStatus().equals("Cancelled")){%>
                        <div class="order-status status-cancelled"><%= order.getStatus() %></div>
                        <%} else if(order.getStatus().equals("Completed")){%>
                        <div class="order-status status-delivered"><%= order.getStatus() %></div>
                        <%}%>
                        <div class="order-date">Đặt ngày: <%= order.getOrderDate() %></div>
                    </div>
                    <div class="order-actions">
                        <form action="greeting" method="post">
                            <input type="hidden" name="userId" value="<%= productDAO.getProductById(orderItems.get(0).getProductId()).getSellerId() %>"/>
                            <input type="submit" class="btn btn-outline" value="Liên hệ Shop"/>
                        </form>
                        <%if(order.getStatus().equals("Pending")||order.getStatus().equals("Processing")){%>
                        <form action="cancel-order" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?');">
                            <input type="hidden" name="orderId" value="<%= orderId %>"/>
                            <input type="submit" class="btn btn-primary" value="Hủy đơn hàng"/>
                        </form>
                        <%} else if(order.getStatus().equals("Shipped")){%>
                        <form action="complete-order" method="post">
                            <input type="hidden" name="orderId" value="<%= orderId %>" onsubmit="return confirm('Xác nhận đã nhận được hàng?');"/>
                            <input type="submit" class="btn btn-primary" value="Đã nhận được hàng"/>
                        </form>
                        <%} else if(order.getStatus().equals("Completed")){%>
                        <form action="create-review.jsp?<%= orderId %>">
                            <input type="hidden" name="orderId" value="<%= orderId %>"/>
                            <input type="submit" class="btn btn-primary" value="Đánh giá"/>
                        </form>
                        <%}%>
                    </div>
                </div>

                <div class="order-section">
                    <h3 class="section-title">Thông tin người nhận</h3>
                    <div class="section-content">
                        <p><strong><%= acc.getFullName() %></strong> | <%= acc.getPhone() %></p>
                        <p><%= order.getShippingAddress() %></p>
                    </div>
                </div>

                <div class="order-section">
                    <h3 class="section-title">Sản phẩm</h3>
                    <div class="order-items">

                        <% for(OrderItem oi : orderItems){
                        Product p = productDAO.getProductById(oi.getProductId());
                        %>
                        <div class="order-item">
                            <div class="item-info">
                                <img src="./images/product/<%= p.getImage() %>" alt="" class="item-image">
                                <div class="item-details">
                                    <h4 class="item-name"><%= p.getProductName() %></h4>
                                    <div class="item-quantity">x<%= oi.getQuantity() %></div>
                                </div>
                            </div>
                            <div class="item-price"><%= p.getPrice() %></div>
                        </div>
                        <%}%>
                    </div>
                </div>

                <!-- Thông tin thanh toán -->
                <div class="order-section">
                    <h3 class="section-title">Thông tin thanh toán</h3>
                    <div class="payment-info">
                        <div class="payment-row">
                            <span>Tạm tính:</span>
                            <span><%= order.getTotalPrice() %>đ</span>
                        </div>
                        <div class="payment-row total">
                            <span>Tổng cộng:</span>
                            <span><%= order.getTotalPrice() %>đ</span>
                        </div>
                        <div class="payment-method">
                            <span>Phương thức thanh toán:</span>
                            <span>COD</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
