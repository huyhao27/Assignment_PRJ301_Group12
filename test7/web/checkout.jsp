<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*" %>
<%@page isELIgnored="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Check out</title>
        <link rel="stylesheet" href="./assets/css/stylesheet.css?v=434">
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
            String[] selected = request.getParameterValues("selectedProductId[]");
            if (selected == null || selected.length == 0) {
                response.sendRedirect("cart.jsp");
                return;
            }

            AccountDAO accDAO = new AccountDAO();
            CartDAO cartDAO = new CartDAO();
            CartItemDAO cartItemDAO = new CartItemDAO();
            ProductDAO productDAO = new ProductDAO();

            Cart cart = cartDAO.getCartByUserId(userId);
            List<CartItem> allItems = cartItemDAO.getCartItemsByCartId(cart.getCartId());
            Map<Integer, List<CartItem>> sellerMap = new HashMap<>();
            Map<Integer, Product> productMap = new HashMap<>();
            double totalAmount = 0;

            for (String pidStr : selected) {
                int pid = Integer.parseInt(pidStr);
                for (CartItem item : allItems) {
                    if (item.getProductId() == pid) {
                        Product p = productDAO.getProductById(pid);
                        productMap.put(pid, p);
                        int sellerId = p.getSellerId();
                        sellerMap.putIfAbsent(sellerId, new ArrayList<>());
                        sellerMap.get(sellerId).add(item);
                        totalAmount += p.getPrice() * item.getQuantity();
                        break;
                    }
                }
            }
        %>

        <div class="main-content">
            <div class="checkout-wrapper">
                <form action="purchase" method="post">
                    <div class="checkout-section address-section">
                        <h3>Địa Chỉ Nhận Hàng</h3>
                        <div class="address-info">
                            <div>
                                <strong><%= acc.getFullName() %> | <%= acc.getPhone() %></strong><br>
                                <span style="color: #888; font-size: 14px;">Bạn vui lòng nhập địa chỉ giao hàng bên dưới</span>
                            </div>
                        </div>
                        <input type="text" name="shippingAddress" placeholder="Nhập địa chỉ nhận hàng"
                               class="address-input" required/>
                    </div>

                    <!-- Danh sách sản phẩm theo người bán -->
                    <div class="checkout-section product-section">
                        <% for (Map.Entry<Integer, List<CartItem>> entry : sellerMap.entrySet()) {
                            int sellerId = entry.getKey();
                            List<CartItem> items = entry.getValue();
                        %>
                        <div class="seller-block">
                            <div class="seller-header"><%= accDAO.getAccountById(sellerId).getUsername() %></div>
                            <% for (CartItem item : items) {
                                Product p = productMap.get(item.getProductId());
                            %>
                            <div class="product-row">
                                <img src="./images/product/<%= p.getImage() %>" alt="">
                                <div class="checkout-product-info">
                                    <div class="checkout-product-name"><%= p.getProductName() %></div>
                                </div>
                                <div class="checkout-product-price">₫<%= p.getPrice() %></div>
                                <div class="checkout-product-quantity">x<%= item.getQuantity() %></div>
                                <div class="checkout-product-total">₫<%= p.getPrice() * item.getQuantity() %></div>
                            </div>
                            <% } %>
                        </div>
                        <% } %>
                    </div>

                    <!-- Tổng kết -->
                    <div class="checkout-section summary-section">
                        <div class="summary-row">
                            <span>Tổng tiền hàng</span>
                            <span>₫<%= (int) totalAmount %></span>
                        </div>
                        <div class="summary-row total">
                            <span>Tổng thanh toán</span>
                            <span class="total-money">₫<%= (int) (totalAmount) %></span>
                        </div>
                    </div>

                    <!-- Nút đặt hàng -->

                    <% for (String id : selected) { %>
                    <input type="hidden" name="selectedProductId[]" value="<%= id %>">
                    <% } %>
                    <div class="checkout-actions">
                        <span>Thanh toán khi nhận hàng (COD)</span>
                        <input type="submit" class="place-order-btn" value="Đặt hàng" />
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
