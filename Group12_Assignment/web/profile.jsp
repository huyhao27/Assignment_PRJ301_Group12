<%-- 
    Document   : profile
    Created on : Jun 11, 2025, 11:30:20 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*" %>
<%@page isELIgnored="true" %>

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
            Account acc = (Account) session.getAttribute("account");
            if (acc == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int userId = acc.getUserId();
            
            ProductDAO productDAO = new ProductDAO();
            AccountDAO accDAO = new AccountDAO();
            PostDAO postDAO = new PostDAO();
            FollowDAO followDAO = new FollowDAO();
            LikeDAO likeDAO = new LikeDAO();
            SavedPostDAO savedPostDAO = new SavedPostDAO();
            CommentDAO commentDAO = new CommentDAO();
            
            ArrayList<Post> listPost = postDAO.getPostsByUser(userId);
            ArrayList<Product> listProduct = productDAO.getProductsBySeller(userId);
            ArrayList<Integer> listFollower = followDAO.getFollowers(userId);
            ArrayList<Integer> listFollowing = followDAO.getFollowing(userId);
        %>

        <div class="main-content">
            <div class="profile-header">
                <img src="./images/avatar/<%= acc.getAvatar() %>" alt="Avatar" class="profile-avatar">
                <div class="profile-info">
                    <h2><%= acc.getUsername() %></h2>
                    <div class="profile-stats">
                        <div class="stat-block" id="post-count"><%= listPost.size() %> Bài viết</div>
                        <div class="stat-block" id="followers"><%= listFollower.size() %> Người theo dõi</div>
                        <div class="stat-block" id="following">Đang theo dõi <%= listFollowing.size() %></div>
                    </div>
                </div>
            </div>

            <!-- Tabs -->
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
                                    <div class="post-options-wrapper">
                                        <img src="./assets/icon/menu-dots.png" class="dots-icon" onclick="togglePostMenu(<%= post.getPostId() %>)" />
                                        <div class="action-post-menu" id="post-menu-<%= post.getPostId() %>">
                                            <a href="edit-post.jsp?postId=<%= post.getPostId() %>">Chỉnh sửa</a>
                                            <a href="delete-post?postId=<%= post.getPostId() %>" onclick="return confirm('Bạn có chắc muốn xóa bài viết này?')">Xóa</a>
                                        </div>
                                    </div>
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

            document.addEventListener('DOMContentLoaded', function () {
                const feedPost = document.querySelector('.feed-post');

                // Mở popup khi click vào ảnh
                document.querySelector('.feed-grid').addEventListener('click', function (e) {
                    const feedItem = e.target.closest('.feed-item');
                    if (!feedItem || !feedItem.id)
                        return;

                    const popup = document.getElementById(feedItem.id + '-popup');
                    if (!popup)
                        return;

                    document.querySelectorAll('.feed-post-item').forEach(p => {
                        p.classList.remove('active');
                        p.style.display = 'none';
                    });

                    feedPost.style.display = 'flex';
                    popup.style.display = 'flex';

                    requestAnimationFrame(() => {
                        popup.classList.add('active');
                    });
                });

                // Đóng popup
                document.querySelectorAll('.close-feed-post img').forEach(closeBtn => {
                    closeBtn.addEventListener('click', () => {
                        document.querySelectorAll('.feed-post-item').forEach(p => {
                            p.classList.remove('active');
                            p.style.display = 'none';
                        });
                        feedPost.style.display = 'none';
                    });
                });

                feedPost.addEventListener('click', (e) => {
                    if (e.target === feedPost) {
                        document.querySelectorAll('.feed-post-item').forEach(p => {
                            p.classList.remove('active');
                            p.style.display = 'none';
                        });
                        feedPost.style.display = 'none';
                    }
                });

                document.querySelectorAll('.ajax-comment-form').forEach(form => {
                    form.addEventListener('submit', async (e) => {
                        e.preventDefault();

                        const formData = new FormData(form);
                        const postId = formData.get('postId');
                        const content = formData.get('content');

                        if (!content.trim())
                            return;

                        const response = await fetch('<%= request.getContextPath() %>/comment', {
                            method: 'POST',
                            body: formData
                        });

                        if (response.ok) {
                            const commentBox = form.closest('.feed-post-item')
                                    .querySelector('.feed-post-comments');

                            const contextPath = '<%= request.getContextPath() %>';
                            const userAvatar = "<%= acc.getAvatar() %>";
                            const username = "<%= acc.getUsername() %>";

                            const commentDiv = document.createElement('div');
                            commentDiv.className = 'feed-post-comment-content';
                            commentDiv.innerHTML = `
        <img src="./images/avatar/<%= acc.getAvatar() %>" alt="" />
        <p><strong><%= acc.getUsername() %></strong> ${content}</p>`;

                            commentBox.appendChild(commentDiv);
                            commentBox.scrollTop = commentBox.scrollHeight;

                            form.reset();
                        } else {
                            alert("Đăng bình luận thất bại.");
                        }
                    });
                });

                document.querySelectorAll('.heart').forEach(heartIcon => {
                    heartIcon.addEventListener('click', async function (e) {
                        e.stopPropagation(); // Prevent opening the post popup when clicking like

                        const postId = this.getAttribute('data-post-id');
                        const isCurrentlyLiked = this.src.includes('redheart.png');

                        try {
                            const response = await fetch('<%= request.getContextPath() %>/like', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                                body: `postId=${postId}`
                            });

                            if (response.ok) {
                                const data = await response.json();

                                // Update the heart icon
                                this.src = `./assets/icon/${data.isLiked ? 'redheart.png' : 'heart.png'}`;

                                // Update like count in both the grid item and popup
                                document.querySelectorAll(`[id*="post-${postId}"] .like-count`).forEach(element => {
                                    element.textContent = `${data.likeCount} lượt thích`;
                                });

                                // Update like count in the footer if visible
                                const footerCount = document.querySelector(`#post-${postId} .feed-item-footer-action span:first-child`);
                                if (footerCount) {
                                    footerCount.textContent = data.likeCount;
                                }
                            }
                        } catch (error) {
                            console.error('Error:', error);
                        }
                    });
                });

                document.querySelectorAll('.save-icon').forEach(saveIcon => {
                    saveIcon.addEventListener('click', async function (e) {
                        e.stopPropagation();

                        const postId = this.getAttribute('data-post-id');
                        const icon = this;

                        try {
                            const response = await fetch('<%= request.getContextPath() %>/save-post', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                                body: `postId=${postId}`
                            });

                            if (response.ok) {
                                const data = await response.json();

                                // Cập nhật icon
                                icon.src = `./assets/icon/${data.isSaved ? 'saved.png' : 'bookmark.png'}`;

                                if (data.isSaved) {
                                    icon.classList.add('saved');
                                    setTimeout(() => icon.classList.remove('saved'), 500);
                                }
                            }
                        } catch (error) {
                            console.error('Error saving post:', error);
                        }
                    });
                });

            });


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
