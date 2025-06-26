<%-- 
    Document   : sidebar
    Created on : Jun 11, 2025, 2:59:56 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page isELIgnored="false" %>
<%@page import="java.util.*, model.*, dao.*" %>
<div class="sidebar">


    <a href="home.jsp" class="menu-item">
        <img src="./assets/icon/home.png" alt="Home" class="icon">
        <span>Trang chủ</span>
    </a>

    <a href="explore.jsp" class="menu-item">
        <img src="./assets/icon/search.png" alt="Explore" class="icon">
        <span>Khám phá</span>
    </a>

    <a href="#" class="menu-item  create-menu-toggle">
        <img src="./assets/icon/square-plus.png" alt="Explore" class="icon">
        <span>Tạo</span>
    </a>


    <div class="create-submenu" id="createSubmenu">
        <div class="create-option" id="createPostBtn">
            <span>Bài viết</span>
            <img src="./assets/icon/blog-text.png" alt="Post Icon" />
        </div>
        <div class="create-option" id="createProductBtn">
            <span>Sản phẩm</span>
            <img src="./assets/icon/shopping-bag.png" alt="Bag Icon" />
        </div>
    </div>


    <a href="shop.jsp" class="menu-item">
        <img src="./assets/icon/shop.png" alt="Shop" class="icon">
        <span>Cửa hàng</span>
    </a>

    <a href="profile.jsp" class="menu-item">
        <img src="./assets/icon/user.png" alt="Profile" class="icon">
        <span>Hồ sơ</span>
    </a>

    <hr>

    <a href="settings.jsp" class="menu-item">
        <img src="./assets/icon/settings-sliders.png" alt="Settings" class="icon">
        <span>Cài đặt</span>
    </a>

    <a href="${pageContext.request.contextPath}/logout" class="menu-item" onclick="return confirm('Bạn có chắc chắn muốn đăng xuất không?');">
        <img src="./assets/icon/exit.png" alt="Logout" class="icon">
        <span>Đăng xuất</span>
    </a>



</div>

<%
    CategoryDAO categoryDAO = new CategoryDAO();
    ArrayList<Category> listCategory = categoryDAO.getAllCategories();
    
    Account acc = (Account) session.getAttribute("account");
    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div class="overlay" id="createOverlay"></div>

<div class="create-post-modal" id="createPostModal">
    <div class="create-post-header">
        <h3>Tạo bài viết</h3>
        <div class="create-prod-exit" onclick="closeCreatePost()">
            <img src="./assets/icon/cross-circle.png" alt="Đóng" />
        </div>
    </div>
    <div class="create-post-user">
        <img src="./images/avatar/<%= acc.getAvatar() %>" alt="Avatar" class="create-post-avatar" />
        <h5><%= acc.getUsername() %></h5>
    </div>
    <div>
        <form action="create-post" method="post" enctype="multipart/form-data">
            <img id="imagePreviewPost" class="image-preview" style="display: none;" />
            <textarea class="create-post-content" name="content" placeholder="Bạn đang nghĩ gì?" rows="4"></textarea>
            <input type="file" name="postphoto" id="imageInputPost" class="create-post-image" onchange="previewImage(event, 'Post')" hidden
                   accept="image/*" />
            <label for="imageInputPost" class="image-upload-label">
                <img src="./assets/icon/add-image.png" alt="Thêm ảnh" />
            </label>
            <input type="submit" class="create-post-submit" value="Đăng" />
        </form>
    </div>
</div>



<div class="create-prod-modal" id="createProdModal">
    <div class="create-prod-header">
        <h3>Tạo sản phẩm</h3>
        <div class="create-prod-exit" onclick="closeCreateProd()">
            <img src="./assets/icon/cross-circle.png" alt="Đóng" />
        </div>
    </div>
    <div class="create-prod-form">
        <form action="create-product" method="post" enctype="multipart/form-data">
            <img id="imagePreviewProd" class="image-preview-prod" style="display: none;" />
            <input type="file" name="image" id="imageInputProd" class="create-post-image" onchange="previewImage(event, 'Prod')" hidden
                   accept="image/*" />
            <label for="imageInputProd" class="image-upload-label">
                Thêm ảnh: <img src="./assets/icon/add-image.png" alt="Thêm ảnh" />
            </label><br>

            <label for="productName">Tên sản phẩm:</label><br>
            <input class="create-prod-input" type="text" id="productName" name="productName" required><br>

            <label for="description">Mô tả:</label><br>
            <textarea class="create-prod-input" id="description" name="description" rows="4" cols="50" required></textarea><br>

            <label for="price">Giá (VNĐ):</label><br>
            <input class="create-prod-input" type="number" id="price" name="price" step="0.01" min="0" required><br>

            <label for="quantity">Số lượng:</label><br>
            <input class="create-prod-input" type="number" id="quantity" name="quantity" min="1" value="1" required><br>

            <label for="categoryId">Danh mục:</label><br>
            <select class="create-prod-input" id="categoryId" name="categoryId" required>
                <option value="NULL">-- Chọn danh mục --</option>
                <% for(Category category : listCategory){ %>
                    <option value="<%= category.getCategoryId() %>"><%= category.getCategoryName() %></option>
                <% } %>
                
            </select><br><br>

            <input type="submit" class="create-post-submit" value="Tạo" />
        </form>
    </div>
</div>

<script>
    const toggleBtn = document.querySelector('.create-menu-toggle');
    const submenu = document.getElementById('createSubmenu');
    const createPostModal = document.getElementById('createPostModal');
    const createProdModal = document.getElementById('createProdModal');
    const createOverlay = document.getElementById('createOverlay');

    toggleBtn.addEventListener('click', (e) => {
        e.preventDefault();
        submenu.classList.toggle('active');
    });

    document.getElementById('createProductBtn').addEventListener('click', () => {
        createProdModal.style.display = 'block';
        createOverlay.style.display = 'block';
        submenu.classList.remove('active');
    });

    document.getElementById('createPostBtn').addEventListener('click', () => {
        createPostModal.style.display = 'block';
        createOverlay.style.display = 'block';
        submenu.classList.remove('active');
    });

    window.addEventListener('click', (e) => {
        if (!submenu.contains(e.target) && !toggleBtn.contains(e.target)) {
            submenu.classList.remove('active');
        }

        if (e.target === createOverlay) {
            closeCreatePost();
            closeCreateProd();
        }
    });

    function closeCreatePost() {
        createPostModal.style.display = 'none';
        createOverlay.style.display = 'none';
    }

    function closeCreateProd() {
        createProdModal.style.display = 'none';
        createOverlay.style.display = 'none';
    }

    createOverlay.addEventListener('click', () => {
        closeCreatePost();
        closeCreateProd();
    });

    function previewImage(event, type) {
        const input = event.target;
        const previewId = type === 'Post' ? 'imagePreviewPost' : 'imagePreviewProd';
        const preview = document.getElementById(previewId);

        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(input.files[0]);
        }
    }


</script>
