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

        <style>

        </style>
    </head>
    <body>
        <jsp:include page="./assets/includes/sidebar.jsp" />
        <jsp:include page="./assets/includes/header.jsp" />
        <jsp:include page="./assets/includes/chat.jsp" />

        <%
            Account acc = (Account) session.getAttribute("account");
            int postId = 0;
            try{
                postId = Integer.parseInt(request.getParameter("postId"));
            }catch(Exception e){
            }
            if (acc == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int userId = acc.getUserId();
            
            AccountDAO accDAO = new AccountDAO();
            PostDAO postDAO = new PostDAO();
            
            Post post = postDAO.getPostById(postId);
        %>

        <div class="main-content">
            <div class="update-post-modal">
                <div class="update-post-header">
                    <h3>Chỉnh sửa bài viết</h3>
                </div>
                <div class="update-post-user">
                    <img src="./images/avatar/<%= acc.getAvatar() %>" alt="Avatar" class="create-post-avatar" />
                    <h5><%= acc.getUsername() %></h5>
                </div>
                <div>
                    <form action="edit-post" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="postId" value="<%= post.getPostId() %>"/>
                        <img id="imagePreviewUpdate" class="update-image-preview"
                             src="./images/post/<%= post.getImage() != null ? post.getImage() : "" %>"
                             style="<%= post.getImage() != null ? "display: block;" : "display: none;" %>" />

                        <textarea class="update-post-content" name="content" placeholder="Bạn đang nghĩ gì?" rows="4"><%= post.getContent() %></textarea>
                        <input type="file" name="postphoto" id="imageInputUpdate" class="update-post-image" onchange="previewUpdateImage(event)" hidden
                               accept="image/*" />
                        <label for="imageInputUpdate" class="image-upload-label">
                            <img src="./assets/icon/add-image.png" alt="Thêm ảnh" />
                        </label>
                        <input type="submit" class="update-post-submit" value="Đăng" />
                    </form>
                </div>
            </div>
        </div>
        <script>
            function previewUpdateImage(event) {
                const imageInput = event.target;
                if (imageInput.files && imageInput.files[0]) {
                    // Trỏ đến đúng id mới là 'imagePreviewUpdate'
                    const imagePreview = document.getElementById('imagePreviewUpdate');

                    imagePreview.src = URL.createObjectURL(imageInput.files[0]);
                    imagePreview.style.display = 'block';

                    imagePreview.onload = function () {
                        URL.revokeObjectURL(imagePreview.src);
                    }
                }
            }

        </script>
    </body>
</html>
