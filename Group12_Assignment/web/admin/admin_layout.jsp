
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${param.title}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/stylesheet.css">
    <style>
        body { display: flex; }
        .admin-sidebar { width: 220px; height: 100vh; background-color: #f8f9fa; padding: 15px; border-right: 1px solid #dee2e6; }
        .admin-main-content { flex-grow: 1; padding: 20px; }
        .admin-sidebar a { display: block; padding: 10px; text-decoration: none; color: #333; border-radius: 5px; }
        .admin-sidebar a:hover, .admin-sidebar a.active { background-color: #007bff; color: white; }
    </style>
</head>
<body>
    <jsp:include page="admin_sidebar.jsp" />
    <main class="admin-main-content">
        <jsp:include page="${param.body}" />
    </main>
</body>
</html>