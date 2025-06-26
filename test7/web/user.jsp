<%-- 
    Document   : user
    Created on : Jun 21, 2025, 12:09:27 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Profile</title>
        <link rel="stylesheet" href="./assets/css/stylesheet.css?v=123">
    </head>
    <body>
        <jsp:include page="./assets/includes/sidebar.jsp" />
        <jsp:include page="./assets/includes/header.jsp" />
        <jsp:include page="./assets/includes/chat.jsp" />

        <%
            
            
            ProductDAO productDAO = new ProductDAO();
            AccountDAO accDAO = new AccountDAO();
            PostDAO postDAO = new PostDAO();
            FollowDAO followDAO = new FollowDAO();
            LikeDAO likeDAO = new LikeDAO();
            SavedPostDAO savedPostDAO = new SavedPostDAO();
            CommentDAO commentDAO = new CommentDAO();
            String userIdStr = request.getParameter("userId").trim();
            
            Account acc = (Account) session.getAttribute("account");
            if (acc == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            int userId = 0;
            try {
                userId = Integer.parseInt(userIdStr);
            } catch(Exception e){
            
            }
            
            if(userId == acc.getUserId()){
                response.sendRedirect("profile.jsp");
                return;
            }
            
            Account thisUser = accDAO.getAccountById(userId);
            ArrayList<Post> listPost = postDAO.getPostsByUser(userId);
            ArrayList<Product> listProduct = productDAO.getProductsBySeller(userId);
            ArrayList<Integer> listFollower = followDAO.getFollowers(userId);
            ArrayList<Integer> listFollowing = followDAO.getFollowing(userId);
            
            boolean isFollow = followDAO.isFollowing(acc.getUserId(), userId);
        %>

        <div class="main-content">
            <div class="profile-header">
                <img src="./images/avatar/<%= thisUser.getAvatar() %>" alt="Avatar" class="profile-avatar">
                <div class="profile-info">
                    <h2><%= thisUser.getUsername() %></h2>
                    <div class="profile-stats">
                        <div class="stat-block" id="post-count"><%= listPost.size() %> Bài viết</div>
                        <div class="stat-block" id="followers"><%= listFollower.size() %> Người theo dõi</div>
                        <div class="stat-block" id="following">Đang theo dõi <%= listFollowing.size() %></div>
                    </div>
                </div>
                <div class="user-action">
                    <form method="post" action="follow" class="user-action-form">
                        <input type="hidden" name="userId" value="<%= userId %>" />
                        <input type="hidden" name="action" value="<%= isFollow ? "unfollow" : "follow" %>" />
                        <input type="submit" value="<%= isFollow ? "Unfollow" : "Follow" %>" class="user-action-btn" />
                    </form>

                    <form method="post" action="greeting" class="user-action-form">
                        <input type="hidden" name="userId" value="<%= userId %>" />
                        <input type="submit" value="Chat" class="user-action-btn" />
                    </form>
                </div>
            </div>

            <div class="tab-nav">
                <div class="tab-item active" onclick="showTab('posts')">Bài viết</div>
                <div class="tab-item" onclick="showTab('products')">Sản phẩm</div>
                <div class="tab-item" onclick="showTab('profile-images')">Ảnh</div>
            </div>

            <div id="posts" class="tab-content active">
                <div class="feed-grid">


                    <% 
                        for(Post post : listPost){
                    %>

                    <div class="feed-item" id="post-<%= post.getPostId() %>">
                        <div class="feed-item-img">
                            <img src="./images/post/<%= post.getImage() %>" alt="" />
                        </div>
                        <div class="feed-item-footer">
                            <div class="feed-item-user">
                                <img src="./images/avatar/<%= (accDAO.getAccountById(post.getUserId())).getAvatar() %>" alt="" class="feed-item-avatar" />
                                <span class="username"><%= (accDAO.getAccountById(post.getUserId())).getUsername() %></span>
                            </div>
                            <div class="feed-item-footer-action">
                                <img src="./assets/icon/heart.png" alt="" class="feed-icon">
                                <span><%= likeDAO.countLikesByPost(post.getPostId())%></span>
                                <img src="./assets/icon/comment-alt.png" alt="" class="feed-icon">
                                <span><%= commentDAO.getCommentsByPost(post.getPostId()).size() %></span>
                            </div>
                        </div>
                    </div>

                    <% 
                        }
                    %>




                </div> <!-- End of grid-->

                <div class="feed-post">

                    <%
                        for(Post post : listPost){
                    %>

                    <div class="feed-post-item" id="post-<%= post.getPostId() %>-popup">
                        <div class="feed-post-image">
                            <img src="./images/post/<%= post.getImage() %>" alt="" />
                        </div>
                        <div class="feed-post-content">
                            <div class="feed-post-caption">
                                <div class="feed-post-avatar">
                                    <img src="./images/avatar/<%= (accDAO.getAccountById(post.getUserId())).getAvatar() %>" alt="" onclick="window.location.href = 'user.jsp?userId=<%= post.getUserId() %>'"/>
                                    <span><%= (accDAO.getAccountById(post.getUserId())).getUsername() %></span>
                                </div>
                                <div class="feed-post-main-caption">
                                    <p><%= post.getContent() %></p>
                                </div>
                            </div>
                            <div class="feed-post-comments">
                                <%
                                    ArrayList<Comment> commentList = commentDAO.getCommentsByPost(post.getPostId());
                                    for(Comment comment : commentList){
                                %>

                                <div class="feed-post-comment-content">
                                    <img src="./images/avatar/<%= accDAO.getAccountById(comment.getUserId()).getAvatar() %>" alt="" />
                                    <p><strong><%= accDAO.getAccountById(comment.getUserId()).getUsername() %></strong>  <%= comment.getContent() %></p>
                                </div>

                                <% } %>
                            </div>
                            <div class="feed-post-action">
                                <img src="./assets/icon/<%= likeDAO.isLikedByUser(userId, post.getPostId()) ? "redheart.png" : "heart.png" %>" 
                                     class="icon feed-icon heart" data-post-id="<%= post.getPostId() %>" />
                                <img src="./assets/icon/comment-alt-middle.png" class="icon" />
                                <img src="./assets/icon/<%= savedPostDAO.isPostSaved(userId, post.getPostId()) ? "saved.png" : "bookmark.png" %>" 
                                     class="icon save-icon" data-post-id="<%= post.getPostId() %>" />
                            </div>
                            <div class="feed-post-information">
                                <h4 class="like-count"><%= likeDAO.countLikesByPost(post.getPostId())%> lượt thích</h4>
                                <p><%= post.getCreatedAt() %></p>
                            </div>
                            <div class="feed-post-comment-form" >
                                <form action="comment" method="post" class="ajax-comment-form">
                                    <input type="hidden" name="postId" value="<%= post.getPostId() %>" />
                                    <input type="text" name="content" required/>
                                    <input type="submit" value="Đăng" />
                                </form>
                            </div>
                        </div>
                    </div>
                    <% 
                        }
                    %>
                </div> <!-- End of feed posts-->
            </div>

            <div id="products" class="tab-content">
                <div class="product-list">

                    <%
                        for(Product product : listProduct) {
                    %>


                    <a href="product-detail.jsp?productId=<%= product.getProductId() %>" class="product-item">
                        <div class="product-img">
                            <img src="./images/product/<%= product.getImage() %>" alt="Product">
                        </div>
                        <div class="product-info">
                            <h4 class="product-name"><%= product.getProductName() %></h4>
                            <p class="product-price"><%= product.getPrice() %></p>
                        </div>
                    </a>

                    <%}%>
                </div>
            </div>

            <div id="profile-images" class="tab-content">
                <div class="image-grid">
                    <% for(Post post : listPost){ %>
                    <img src="./images/post/<%= post.getImage() %>" class="image-grid-item"/>
                    <% } %>
                </div>
            </div>
        </div>
        <script>
            function showTab(tabId) {
                const tabs = ['posts', 'products', 'profile-images'];
                const index = tabs.indexOf(tabId);

                document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
                document.getElementById(tabId).classList.add('active');

                document.querySelectorAll('.tab-item').forEach(el => el.classList.remove('active'));
                document.querySelectorAll('.tab-item')[index].classList.add('active');

                document.querySelector('.tab-nav').style.setProperty('--tab-index', index);
            }
        </script>
    </body>
</html>
