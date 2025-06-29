<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%--<jsp:include page="/admin/admin_header.jsp" />--%>
<html>
<head>
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/stylesheet.css">
</head>
<body>
    <jsp:include page="/admin/admin_header.jsp" />
    <div class="main-content" style="margin-left: 0;">
        <h2 class="main-title">Danh sách người dùng</h2>
        <table class="cart-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Họ Tên</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${userList}">
                    <tr>
                        <td>${user.userId}</td>
                        <td>${user.username}</td>
                        <td>${user.fullName}</td>
                        <td>${user.email}</td>
                        <td>${user.role}</td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="userId" value="${user.userId}">
                                <button type="submit" onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này?');">Xóa</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="reset_password">
                                <input type="hidden" name="userId" value="${user.userId}">
                                <button type="submit">Reset Pass</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>