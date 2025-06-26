<%-- 
    Document   : product-detail
    Created on : Jun 11, 2025, 11:52:23 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Detail</title>
        <link rel="stylesheet" href="./assets/css/stylesheet.css?v=123">
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
            
            int productId = 0;
            try {
                String productIdStr = request.getParameter("productId");
                productId = Integer.parseInt(productIdStr);
            } catch(Exception e){
                
            }
            
            ProductDAO productDAO = new ProductDAO();
            AccountDAO accDAO = new AccountDAO();
            ReviewDAO reviewDAO = new ReviewDAO();
            CartDAO cartDAO = new CartDAO();
            Product thisProduct = productDAO.getProductById(productId);
            Account thisSeller = accDAO.getAccountById(thisProduct.getSellerId());
            ArrayList<Review> reviewList = reviewDAO.getReviewsByProduct(productId);
            
        %>

        <div class="main-content">
            <div class="detail-container">
                <div class="detail-top">
                    <div class="detail-image-container">
                        <img src="./images/product/<%= thisProduct.getImage() %>" alt="" />
                    </div>
                    <div class="detail-info">
                        <% 
                            if(thisProduct.getSellerId() == acc.getUserId()){
                        %>
                        <div class="post-options-wrapper">
                            <img src="./assets/icon/menu-dots.png" class="dots-icon" onclick="togglePostMenu(<%= thisProduct.getProductId() %>)" />
                            <div class="action-post-menu" id="post-menu-<%= thisProduct.getProductId() %>">
                                <a href="edit-product.jsp?productId=<%= thisProduct.getProductId() %>">Chỉnh sửa</a>
                                <a href="delete-product?productId=<%= thisProduct.getProductId() %>" onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')">Xóa</a>
                            </div>
                        </div>
                        <%} else {%>
                        <div></div>
                        <%}%>
                        <div class="detail-name"><%= thisProduct.getProductName() %></div>
                        <div class="detail-price"><%= thisProduct.getPrice() %></div>

                        <form class="detail-actions-form" method="post" action="add-to-cart">

                            <input type="hidden" name="productId" value="<%= request.getParameter("productId") %>" />
                            <input type="hidden" name="cartId" value="<%= cartDAO.getCartByUserId(userId).getCartId() %>" />

                            <div class="detail-quantity-control">
                                <button type="button" class="btn-decrease" onclick="changeQuantity(-1)">−</button>
                                <input type="number" name="quantity" id="quantityProduct" value="1" min="1" max="<%= thisProduct.getQuantity() %>">
                                <button type="button" class="btn-increase" onclick="changeQuantity(1)">+</button>
                            </div>

                            <input type="submit" value="🛒 Thêm vào giỏ" class="detail-btn-cart"/>
                            <button value="buyNow" class="detail-btn-buy">Mua ngay</button>
                        </form>
                    </div>
                </div>


                <div class="detail-seller-box">
                    <img src="./images/avatar/<%= thisSeller.getAvatar() %>" alt="avatar" class="detail-seller-avatar" onclick="window.location.href = 'user.jsp?userId=<%= thisSeller.getUserId() %>'" />

                    <div class="detail-seller-info">
                        <strong><%= thisSeller.getUsername() %></strong><br>
                        <%= (productDAO.getProductsBySeller(thisSeller.getUserId())).size() %> Sản phẩm
                    </div>
                    <div class="detail-seller-actions">
                        <button>Chat</button>
                        <button onclick="window.location.href = 'user.jsp?userId=<%= thisSeller.getUserId() %>'">Hồ sơ</button>
                    </div>
                </div>

                <div class="detail-box">
                    <h3>Mô tả sản phẩm</h3>
                    <p><%= thisProduct.getDescription() %></p>
                </div>

                <div class="detail-box">
                    <h3>Đánh giá</h3>

                    <div class="review-list">

                        <% for(Review review : reviewList){ %>
                        <div class="review-item">
                            <div class="review-header">
                                <span class="reviewer-name"><%= accDAO.getAccountById(review.getUserId()).getUsername() %></span>
                                <% switch(review.getRating()) {
                                    case 1: %><span class="review-stars">★☆☆☆☆</span><% break;
                                    case 2: %><span class="review-stars">★★☆☆☆</span><% break;
                                    case 3: %><span class="review-stars">★★★☆☆</span><% break;
                                    case 4: %><span class="review-stars">★★★★☆</span><% break;
                                    case 5: %><span class="review-stars">★★★★★</span><% break;
                                    default: %><span class="review-stars">★★★★★</span><% break;
                                } %>
                            </div>
                            <div class="review-content">
                                <p><%= review.getComment() %></p>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function changeQuantity(amount) {
                const input = document.getElementById('quantityProduct');
                let value = parseInt(input.value);
                value = isNaN(value) ? 1 : value;

                const min = parseInt(input.min) || 1;
                const max = parseInt(input.max) || 9999;
                value = Math.min(max, Math.max(min, value + amount));

                input.value = value;
            }

            function togglePostMenu(postId) {
                const menu = document.getElementById("post-menu-" + postId);
                const allMenus = document.querySelectorAll(".post-menu");
                allMenus.forEach(m => {
                    if (m !== menu)
                        m.style.display = "none";
                });
                menu.style.display = menu.style.display === "block" ? "none" : "block";
            }

            // Đóng menu khi click bên ngoài
            document.addEventListener("click", function (event) {
                if (!event.target.matches('.dots-icon')) {
                    document.querySelectorAll('.post-menu').forEach(menu => {
                        menu.style.display = 'none';
                    });
                }
            });

        </script>
    </body>
</html>
