<%-- 
    Document   : create-post
    Created on : Jun 14, 2025, 10:31:00 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>post</title>
        <style>
            h3, h5 {
                margin: 0;
            }
        </style>
    </head>
    <body>


        <div class="create-post" onclick="openCreatePost()">
            <img src="./images/icon/edit.png" alt="Tạo bài viết" />
        </div>

        <div id="overlay" class="overlay" onclick="closeCreatePost()"></div>

        <div class="create-post-modal" id="createPostModal">
            <div class="create-post-header">
                <h3>Tạo bài viết</h3>
                <div class="create-post-exit" onclick="closeCreatePost()">
                    <img src="./images/icon/cross-circle.png" alt="Đóng" />
                </div>
            </div>
            <div class="create-post-user">
                <img src="./avatar/user.png" alt="Avatar" class="create-post-avatar" />
                <h5>Username</h5>
            </div>
            <div>
                <form onsubmit="submitPost(event)">
                    <img id="imagePreview" class="image-preview" style="display: none;" />
                    <textarea class="create-post-content" placeholder="Bạn đang nghĩ gì?" rows="4"></textarea>
                    <input type="file" id="imageInput" class="create-post-image" onchange="previewImage(event)" hidden accept="image/*" />
                    <label for="imageInput" class="image-upload-label">
                        <img src="./images/icon/add-image.png" alt="Thêm ảnh" />
                    </label>
                    <input type="submit" class="create-post-submit" value="Đăng" />
                </form>
            </div>
        </div>



        <script>
            function openCreatePost() {
                document.getElementById('createPostModal').style.display = 'block';
                document.getElementById('overlay').style.display = 'block';
            }

            function closeCreatePost() {
                document.getElementById('createPostModal').style.display = 'none';
                document.getElementById('overlay').style.display = 'none';
                document.getElementById('imagePreview').style.display = 'none';
                document.getElementById('imagePreview').src = '';
            }


            function previewImage(event) {
                const input = event.target;
                const preview = document.getElementById('imagePreview');
                if (input.files && input.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            }

            function submitPost(event) {
                event.preventDefault();
                alert('Đã gửi bài viết (demo)');
                closeCreatePost();
            }
        </script>
    </body>
</html>
