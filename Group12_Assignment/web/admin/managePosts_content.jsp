<%-- File: web/admin/managePosts_content.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h1 class="main-title">Quản lý Bài viết</h1>
<p>Tổng số bài viết: <strong>${postList.size()}</strong></p>

<table class="cart-table">
    <thead>
        <tr>
            <th style="width: 5%;">ID</th>
            <th style="width: 10%;">Ảnh</th>
            <th style="width: 35%;">Nội dung</th>
            <th style="width: 15%;">Người đăng</th>
            <th style="width: 15%;">Ngày đăng</th>
            <th style="width: 10%;">Hành động</th>
        </tr>
    </thead>
    <tbody>
        <c:if test="${empty postList}">
            <tr>
                <td colspan="6" style="text-align: center;">Không có bài viết nào.</td>
            </tr>
        </c:if>
        <c:forEach var="post" items="${postList}">
            <tr>
                <td>${post.postId}</td>
                <td>
                    <c:if test="${not empty post.image}">
                        <img src="${pageContext.request.contextPath}/images/post/${post.image}" alt="Post Image" style="width: 80px; height: 80px; object-fit: cover; border-radius: 4px;">
                    </c:if>
                </td>
                <td><c:out value="${post.content}"/></td>
                <td>User ID: ${post.userId}</td>
                <td>
                    <fmt:setLocale value="vi_VN"/>
                    <fmt:formatDate value="${post.createdAt}" pattern="HH:mm dd/MM/yyyy"/>
                </td>
                <td>
                    <form action="${pageContext.request.contextPath}/admin/posts" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa bài viết này và tất cả bình luận liên quan?');">
                        <input type="hidden" name="postId" value="${post.postId}">
                        <button type="submit" class="delete-btn" style="color: red;">Xóa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>