<%@ page contentType="text/html; charset=UTF-8" %>
<header class="main-header">
    <div class="logo">
         <a href="${pageContext.request.contextPath}/admin/dashboard"><img class="logo-img" src="..." alt="Logo"/></a>
    </div>
    <nav>
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/users">Quản lý User</a>
        <a href="${pageContext.request.contextPath}/admin/posts">Quản lý Bài viết</a>
        <%-- Thêm các link khác --%>
        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
    </nav>
</header>