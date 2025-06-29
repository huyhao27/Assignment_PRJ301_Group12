<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${param.title} | Admin Panel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/stylesheet.css">
    <style>
        body { display: flex; background-color: #f4f7f6; }
        .admin-sidebar { flex-shrink: 0; width: 240px; height: 100vh; background-color: #ffffff; padding: 15px; border-right: 1px solid #dee2e6; position: fixed; top: 0; left: 0; }
        .admin-main-content { flex-grow: 1; padding: 25px; margin-left: 240px; }
        .admin-sidebar a { display: block; padding: 12px 15px; text-decoration: none; color: #333; border-radius: 5px; margin-bottom: 5px; font-weight: 500;}
        .admin-sidebar a:hover, .admin-sidebar a.active { background-color: #0d6efd; color: white; }
        .admin-main-content .main-title { margin-top: 0; }
        .cart-table button { padding: 5px 10px; cursor: pointer; border-radius: 4px; border: 1px solid #ccc; }
    </style>
</head>
<body>
    <jsp:include page="admin_sidebar.jsp" />
    <main class="admin-main-content">
        <jsp:include page="${param.body_page}" />
    </main>
</body>
</html>