<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="admin_layout.jsp">
    <jsp:param name="title" value="Manage Products"/>
</jsp:include>

<div class="container-fluid">
    <h1 class="mt-4">Manage Products</h1>
    <div class="card mb-4">
        <div class="card-header"><i class="fas fa-box mr-1"></i>Product List</div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Image</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Seller ID</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${productList}" var="product">
                            <tr>
                                <td>${product.productId}</td>
                                <td>${product.productName}</td>
                                <td><img src="${pageContext.request.contextPath}/images/product/${product.image}" alt="Product Image" width="50"></td>
                                <td>${product.price}</td>
                                <td>${product.quantity}</td>
                                <td>${product.sellerId}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/products" method="post" style="display:inline;">
                                        <input type="hidden" name="productId" value="${product.productId}">
                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="admin_footer.jsp"/>