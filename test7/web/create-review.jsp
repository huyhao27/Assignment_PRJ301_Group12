<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Review</title>
        <link rel="stylesheet" href="./assets/css/stylesheet.css?v=23">
    </head>
    <body>
        <jsp:include page="./assets/includes/sidebar.jsp" />
        <jsp:include page="./assets/includes/header.jsp" />
        <jsp:include page="./assets/includes/chat.jsp" />

        <%
            
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            ProductDAO productDAO = new ProductDAO();
            AccountDAO accDAO = new AccountDAO();
            PostDAO postDAO = new PostDAO();
            FollowDAO followDAO = new FollowDAO();
            OrderItemDAO oiDAO = new OrderItemDAO();
            
            ArrayList<Product> products = oiDAO.getProductsByOrderId(orderId);
            
            Account acc = (Account) session.getAttribute("account");
            if (acc == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <div class="main-content">
            <h2>Đánh giá đơn hàng #DH<%= orderId %></h2>
            <form action="create-review" method="post">
                <input type="hidden" name="orderId" value="<%= orderId %>"/>
                <% for (Product p : products) { %>
                <div class="review-item">
                    <div class="left-info">
                        <img src="./images/product/<%= p.getImage() %>" alt="">
                        <div class="product-name"><%= p.getProductName() %></div>
                    </div>
                    <div class="right-review">
                        <div class="emoji-rating-wrapper">
                            <input type="hidden" name="productId" value="<%= p.getProductId() %>"/>
                            <p>How satisfied are you with our product?</p>
                            <div class="emoji-rating">
                                <input type="radio" name="rating_<%= p.getProductId() %>" id="emoji-1-<%= p.getProductId() %>" value="1">
                                <label for="emoji-1-<%= p.getProductId() %>">😞</label>

                                <input type="radio" name="rating_<%= p.getProductId() %>" id="emoji-2-<%= p.getProductId() %>" value="2">
                                <label for="emoji-2-<%= p.getProductId() %>">😕</label>

                                <input type="radio" name="rating_<%= p.getProductId() %>" id="emoji-3-<%= p.getProductId() %>" value="3">
                                <label for="emoji-3-<%= p.getProductId() %>">😐</label>

                                <input type="radio" name="rating_<%= p.getProductId() %>" id="emoji-4-<%= p.getProductId() %>" value="4">
                                <label for="emoji-4-<%= p.getProductId() %>">😊</label>

                                <input type="radio" name="rating_<%= p.getProductId() %>" id="emoji-5-<%= p.getProductId() %>" value="5" checked>
                                <label for="emoji-5-<%= p.getProductId() %>">😍</label>
                            </div>

                            <textarea placeholder="Bạn thích điều gì nhất?" name="comment_<%= p.getProductId() %>" rows="3"></textarea>
                        </div>
                    </div>
                </div>
                <% } %>

                <div class="review-submit">
                    <input type="submit" value="Gửi đánh giá">
                </div>
            </form>
        </div>
        <script>
            const emojiRadios = document.querySelectorAll('input[name="emoji"]');
            let selectedRating = null;

            emojiRadios.forEach(radio => {
                radio.addEventListener('change', () => {
                    selectedRating = radio.value;
                    console.log("Đánh giá:", selectedRating);
                });
            });

        </script>

    </body>
</html>
