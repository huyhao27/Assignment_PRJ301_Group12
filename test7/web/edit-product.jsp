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
        <link rel="stylesheet" href="./assets/css/stylesheet.css?qq=123">

        <style>

        </style>
    </head>
    <body>
        <jsp:include page="./assets/includes/sidebar.jsp" />
        <jsp:include page="./assets/includes/header.jsp" />
        <jsp:include page="./assets/includes/chat.jsp" />

        <%
            Account acc = (Account) session.getAttribute("account");
            int productId = 0;
            try{
                productId = Integer.parseInt(request.getParameter("productId"));
            }catch(Exception e){
            }
            if (acc == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int userId = acc.getUserId();
            
            AccountDAO accDAO = new AccountDAO();
            ProductDAO prodDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            ArrayList<Category> listCategory = categoryDAO.getAllCategories();
            
            Product product = prodDAO.getProductById(productId);
        %>

        <div class="main-content">

            <div class="update-prod-modal" id="updateProdModal">
                <div class="update-prod-header">
                    <h3>Cập nhật sản phẩm</h3>
                </div>
                <div class="update-prod-form">
                    <form action="update-product" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="productId" value="<%= product.getProductId() %>"/>
                        <img id="imagePreviewUpdate" class="image-preview-prod"
                             src="./images/product/<%= product.getImage() != null ? product.getImage() : "" %>"
                             style="<%= product.getImage() != null ? "display: block;" : "display: none;" %>" />
                        <input type="file" name="image" id="imageInputUpdate" class="create-post-image" onchange="previewUpdateImage(event)" hidden
                               accept="image/*" />
                        <label for="imageInputUpdate" class="image-upload-label">
                            Thêm ảnh: <img src="./assets/icon/add-image.png" alt="Thêm ảnh" />
                        </label><br>

                        <label for="productName">Tên sản phẩm:</label><br>
                        <input class="create-prod-input" type="text" id="productName" name="productName" value="<%= product.getProductName() %>" required><br>

                        <label for="description">Mô tả:</label><br>
                        <textarea class="create-prod-input" id="description" name="description" rows="4" cols="50"><%= product.getDescription() %></textarea><br>

                        <label for="price">Giá (VNĐ):</label><br>
                        <input class="create-prod-input" type="number" id="price" value="<%= product.getPrice() %>" name="price" step="0.01" min="0" required><br>

                        <label for="quantity">Số lượng:</label><br>
                        <input class="create-prod-input" type="number" id="quantity" value="<%= product.getQuantity() %>" name="quantity" min="1" value="1"><br>

                        <label for="categoryId">Danh mục:</label><br>
                        <select class="create-prod-input" id="categoryId" name="categoryId" required>
                            <option value="">-- Chọn danh mục --</option>
                            <% for (Category category : listCategory) { 
                                   boolean isSelected = category.getCategoryId() == product.getCategoryId();
                            %>
                            <option value="<%= category.getCategoryId() %>" <%= isSelected ? "selected" : "" %>>
                                <%= category.getCategoryName() %>
                            </option>
                            <% } %>
                        </select><br><br>

                        <input type="submit" class="update-post-submit" value="Cập nhật" />
                    </form>
                </div>
            </div>
        </div>
        <script>
            function previewUpdateImage(event) {
                const imageInput = event.target;
                if (imageInput.files && imageInput.files[0]) {
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
