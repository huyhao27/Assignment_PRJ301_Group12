<%-- 
    Document   : home
    Created on : Jun 11, 2025, 2:59:45 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*" %>
<%@page isELIgnored="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Explore</title>
        <link rel="stylesheet" href="./assets/css/stylesheet.css?v=123">
    </head>
    <% 
        PostDAO postDAO = new PostDAO();
        AccountDAO accDAO = new AccountDAO();
        LikeDAO likeDAO = new LikeDAO();
        SavedPostDAO savedPostDAO = new SavedPostDAO();
        CommentDAO commentDAO = new CommentDAO();
        ArrayList<Post> posts = postDAO.getAllPosts();
        
        Account acc = (Account) session.getAttribute("account");
        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = acc.getUserId();
    %>

    <body>
        <jsp:include page="./assets/includes/sidebar.jsp" />
        <jsp:include page="./assets/includes/header.jsp" />
        <jsp:include page="./assets/includes/chat.jsp" />
        <div class="main-content">

            <div class="feed-grid">


                <% 
                    for(Post post : posts){
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
                    for(Post post : posts){
                %>

                <div class="feed-post-item" id="post-<%= post.getPostId() %>-popup">
                    <div class="feed-post-image">
                        <img src="./images/post/<%= post.getImage() %>" alt="" />
                    </div>
                    <div class="feed-post-content">
                        <div class="feed-post-caption">
                            <div class="feed-post-avatar">
                                <img src="./images/avatar/<%= (accDAO.getAccountById(post.getUserId())).getAvatar() %>" alt="" onclick="window.location.href = '<%= "user.jsp?userId="+post.getUserId() %>'"/>
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

        <script>
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

        </script>
    </body>
</html>
