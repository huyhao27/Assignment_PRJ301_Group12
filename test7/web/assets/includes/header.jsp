<%-- 
    Document   : header
    Created on : Jun 11, 2025, 2:58:41 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*" %>
<header class="main-header">

    <%
        CartItemDAO cartItemDAO = new CartItemDAO();
        CartDAO cartDAO = new CartDAO();
        NotificationDAO notificationDAO = new NotificationDAO();
        ProductDAO productDAO = new ProductDAO();
        AccountDAO accDAO = new AccountDAO();
        PostDAO postDAO = new PostDAO();
        FollowDAO followDAO = new FollowDAO();
        
        Account thisUser = (Account) session.getAttribute("account");
        if (thisUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = thisUser.getUserId();

        Cart cart = cartDAO.getCartByUserId(userId);
        ArrayList<Notification> listNotification = notificationDAO.getNotificationsByUser(userId);
        ArrayList<CartItem> listCartItem = cartItemDAO.getCartItemsByCartId(cart.getCartId());
    %>

    <a class="logo" href="home.jsp">
        <img src="./assets/icon/logo2uni.png" alt="Logo" class="logo-img">
    </a>


    <form class="search" action="#" method="get">
        <input type="text" name="query" placeholder="Search..." />
        <button type="submit" class="search-button">
            <img src="./assets/icon/search.png" class="icon" alt="Search" />
        </button>
    </form>

    <div class="actions">
        <a class="cart" href="cart.jsp">
            <img src="./assets/icon/shopping-cart.png" alt="Cart" class="icon" />
            <span class="count-cart-item"><%= listCartItem.size() %></span>
        </a>

        <a href="#" class="notification" id="notificationBell">
            <img src="./assets/icon/bell.png" alt="Bell" class="icon" />
        </a>

        <a href="profile.jsp" class="user">
            <img src="./images/avatar/<%= thisUser.getAvatar() %>" alt="User" class="avatar"
                 onerror="this.onerror=null; this.src='./icon/user.png';" />
        </a>
    </div>

    <div class="notification-dropdown" id="notificationDropdown">
        <h4>Thông báo</h4>
        <ul>
            <% for(Notification notification : listNotification) { %>
            <li>
                <div class="notify-content">
                    <p>
                        <% switch(notification.getType()) {
                            case "like":
                                out.print("1 lượt thích mới về bài viết của bạn");
                                break;
                            case "cmt":
                                out.print("1 bình luận mới về bài viết của bạn");
                                break;
                            case "fl":
                                out.print("Bạn có thêm 1 người theo dõi mới");
                                break;
                            default:
                                out.print("Bạn có thông báo mới");
                                break;
                        } %>
                    </p>
                    <span><%= notification.getCreatedAt() %></span>
                </div>
            </li>

            <% } %>
        </ul>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const bell = document.getElementById('notificationBell');
            const dropdown = document.getElementById('notificationDropdown');

            bell.addEventListener('click', function (e) {
                e.preventDefault();
                dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
            });

            document.addEventListener('click', function (e) {
                if (!bell.contains(e.target) && !dropdown.contains(e.target)) {
                    dropdown.style.display = 'none';
                }
            });
        });
    </script>
</header>
