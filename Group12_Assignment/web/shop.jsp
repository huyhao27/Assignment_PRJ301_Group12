<%-- 
    Document   : shop
    Created on : Jun 11, 2025, 11:31:52 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Shop</title>
        <link rel="stylesheet" href="./assets/css/stylesheet.css?qwacc=2ae3">
    </head>
    <body>
        <jsp:include page="./assets/includes/sidebar.jsp" />
        <jsp:include page="./assets/includes/header.jsp" />
        <jsp:include page="./assets/includes/chat.jsp" />

        <div class="main-content">

            <%
                ProductDAO productDAO = new ProductDAO();
                AccountDAO accDAO = new AccountDAO();
                CategoryDAO categoryDAO = new CategoryDAO();
                ArrayList<Product> listProduct = productDAO.getAllProducts();
                ArrayList<Category> listCategory = categoryDAO.getAllCategories();
                
                int currentPage  = 1;
                int pageSize = 18;
                int totalProducts = listProduct.size();
                int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                try {
                    currentPage  = Integer.parseInt(pageParam);
                    if (currentPage  < 1) currentPage  = 1;
                    else if (currentPage  > totalPages) currentPage  = totalPages;
                } catch (NumberFormatException e) {
                    currentPage  = 1;
                    }
                }

                int start = (currentPage  - 1) * pageSize;
                int end = Math.min(start + pageSize, totalProducts);
                List<Product> currentPageProducts = listProduct.subList(start, end);
                
                ArrayList<Product> bestSellingProducts = productDAO.getBestSellingProducts(5);
                
                String[] selectedCategories = request.getParameterValues("category");
    String minPriceStr = request.getParameter("minPrice");
    String maxPriceStr = request.getParameter("maxPrice");
    String sort = request.getParameter("sort");

    double minPrice = 0, maxPrice = Double.MAX_VALUE;
    try {
        if (minPriceStr != null && !minPriceStr.isEmpty()) {
            minPrice = Double.parseDouble(minPriceStr);
        }
        if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
            maxPrice = Double.parseDouble(maxPriceStr);
        }
    } catch (NumberFormatException e) {}

    List<Product> filteredProducts = new ArrayList<>();
    for (Product p : listProduct) {
        boolean matchCategory = true;
        if (selectedCategories != null && selectedCategories.length > 0) {
            matchCategory = false;
            for (String cat : selectedCategories) {
                try {
                    if (p.getCategoryId() == Integer.parseInt(cat)) {
                        matchCategory = true;
                        break;
                    }
                } catch (NumberFormatException e) {}
            }
        }
        boolean matchPrice = p.getPrice() >= minPrice && p.getPrice() <= maxPrice;

        if (matchCategory && matchPrice) {
            filteredProducts.add(p);
        }
    }

    // Sắp xếp
    if (sort != null) {
        switch (sort) {
            case "az":
                Collections.sort(filteredProducts, Comparator.comparing(Product::getProductName));
                break;
            case "za":
                Collections.sort(filteredProducts, Comparator.comparing(Product::getProductName).reversed());
                break;
            case "priceAsc":
                Collections.sort(filteredProducts, Comparator.comparingDouble(Product::getPrice));
                break;
            case "priceDesc":
                Collections.sort(filteredProducts, Comparator.comparingDouble(Product::getPrice).reversed());
                break;
        }
    }

    // Đặt lại danh sách đang hiển thị là filtered
    listProduct = new ArrayList<>(filteredProducts);
    totalProducts = listProduct.size();
    totalPages = (int) Math.ceil((double) totalProducts / pageSize);
    start = (currentPage - 1) * pageSize;
    end = Math.min(start + pageSize, totalProducts);
    currentPageProducts = listProduct.subList(start, end);

            %>
             <div class="best-selling-section">

                <div class="section-title">

                    Sản phẩm bán chạy

                </div>

                <div class="best-selling-carousel">

                    <% for(int i = 0; i < bestSellingProducts.size(); i++) {
                    Product product = bestSellingProducts.get(i);
                    Category category = categoryDAO.getCategoryById(product.getCategoryId());
                    %>

                    <div class="carousel-item <%= i == 0 ? "active" : "" %>">
                        <div class="background-text">
                            <%= category.getCategoryName() %>
                        </div>

                        <div class="product-details">
                            <div class="product-image-container">
                                <img src="./images/product/<%= product.getImage() %>" alt="<%= product.getProductName() %>">
                            </div>
                            <div class="product-info-overlay">
                                <h3><%= product.getProductName() %></h3>
                                <p><%= product.getDescription() %></p>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <div class="carousel-navigation">
                    <% for(int i = 0; i < bestSellingProducts.size(); i++) { %>
                    <span class="dot <%= i == 0 ? "active" : "" %>" onclick="currentSlide(<%= i + 1 %>)"></span>
                    <% } %>
                </div>
            </div>


            <div class="filter-section">
                <form action="shop.jsp" method="get">
                    <div class="selected-filters">
                        <div class="filter-title">
                            <img src="./assets/icon/bfilter.png" class="icon" />
                            <span><strong> Bộ lọc</strong></span>
                        </div>
                        <a href="shop.jsp" class="reset-button">Bỏ hết</a>
                    </div>

                    <div class="filter-options">
                        <div class="filter-group">
                            <button type="button" class="filter-toggle">Danh mục</button>
                            <div class="filter-content checkbox-list">
                                <label><input type="checkbox" name="category" value="all"> Tất cả</label>
                                    <% for(Category category : listCategory){ 
                                            String checked = "";
                                            if (selectedCategories != null) {
                                                for (String cid : selectedCategories) {
                                                    if (cid.equals(String.valueOf(category.getCategoryId()))) {
                                                        checked = "checked";
                                                        break;
                                                    }
                                                }
                                            }
                                    %>
                                <label><input type="checkbox" onchange="this.form.submit()" name="category" value="<%= category.getCategoryId() %>" <%= checked %>> <%= category.getCategoryName() %></label>
                                    <% } %>
                            </div>
                        </div>

                        <div class="filter-group">
                            <button type="button" class="filter-toggle">Lọc theo giá</button>
                            <div class="filter-content price-filter">
                                <input type="number" onchange="this.form.submit()" name="minPrice" placeholder="Giá từ" value="<%= (minPriceStr != null) ? minPriceStr : "" %>">
                                <input type="number" onchange="this.form.submit()" name="maxPrice" placeholder="đến" value="<%= (maxPriceStr != null) ? maxPriceStr : "" %>">

                                <button type="submit" class="icon-button">
                                    <img src="./assets/icon/bfilter.png" alt="Lọc">
                                </button>
                            </div>
                        </div>

                        <div class="filter-group">
                            <button type="button" class="filter-toggle">Sắp xếp</button>
                            <div class="filter-content radio-list">
                                <label><input type="radio" name="sort" value="default" checked> Mặc định</label>
                                <label><input type="radio" name="sort" onchange="this.form.submit()" value="az" <%= "az".equals(sort) ? "checked" : "" %>>A → Z</label>
                                <label><input type="radio" name="sort" onchange="this.form.submit()" value="za" <%= "za".equals(sort) ? "checked" : "" %>>Z → A</label>
                                <label><input type="radio" name="sort" onchange="this.form.submit()" value="priceAsc" <%= "priceAsc".equals(sort) ? "checked" : "" %>> Giá tăng dần</label>
                                <label><input type="radio" name="sort" onchange="this.form.submit()" value="priceDesc" <%= "priceDesc".equals(sort) ? "checked" : "" %>> Giá giảm dần</label>
                            </div>
                        </div>
                    </div>
                </form>
            </div>



            <!-- Product Grid -->
            <div class="product-list">

                <%
                    for(Product product : currentPageProducts) {
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

            <div class="pagination">
                <% if (currentPage > 1) { %>
                <a href="#" onclick="goToPage(<%= currentPage - 1 %>)">&laquo; Trước</a>
                <% } %>

                <% for (int i = 1; i <= totalPages; i++) { %>
                <a href="#" onclick="goToPage(<%= i %>)" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
                <% } %>

                <% if (currentPage < totalPages) { %>
                <a href="#" onclick="goToPage(<%= currentPage + 1 %>)">Sau &raquo;</a>
                <% } %>
            </div>
        </div>

        <script>
            function goToPage(page) {
                const url = new URL(window.location.href);
                url.searchParams.set("page", page);
                window.location.href = url.toString();
            }

            let slideIndex = 1;
            let autoSlideInterval;

            function showSlides(n) {
                let slides = document.getElementsByClassName("carousel-item");
                let dots = document.getElementsByClassName("dot");

                if (slides.length === 0) {
                    return; // No slides to show
                }

                if (n > slides.length) {
                    slideIndex = 1;
                }
                if (n < 1) {
                    slideIndex = slides.length;
                }

                // Remove 'active' class from all slides and dots
                for (let i = 0; i < slides.length; i++) {
                    slides[i].classList.remove('active');
                }
                for (let i = 0; i < dots.length; i++) {
                    dots[i].classList.remove('active');
                }

                // Add 'active' class to the current slide and dot
                slides[slideIndex - 1].classList.add('active');
                dots[slideIndex - 1].classList.add('active');
            }

            function startAutoSlide() {
                clearInterval(autoSlideInterval); // Clear any existing interval
                autoSlideInterval = setInterval(function () {
                    slideIndex++;
                    showSlides(slideIndex);
                }, 5000); // Change image every 5 seconds
            }

            // Initial setup
            showSlides(slideIndex); // Show the first slide immediately
            startAutoSlide(); // Start automatic sliding

            // Event listeners for dots to reset auto-slide
            document.querySelectorAll('.carousel-navigation .dot').forEach((dot, index) => {
                dot.addEventListener('click', () => {
                    slideIndex = index + 1; // Update slideIndex based on clicked dot
                    showSlides(slideIndex);
                    startAutoSlide(); // Restart auto-slide after manual interaction
                });
            });


        </script>
    </body>
</html>
