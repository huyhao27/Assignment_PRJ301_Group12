<%-- File: web/admin/manageComments_content.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h1 class="main-title">Quản lý Bình luận</h1>
<p>Tổng số bình luận: <strong>${commentList.size()}</strong></p>

<table class="cart-table">
    <thead>
        <tr>
            <th style="width: 5%;">ID</th>
            <th style="width: 40%;">Nội dung</th>
            <th style="width: 10%;">User ID</th>
            <th style="width: 10%;">Post ID</th>
            <th style="width: 15%;">Ngày bình luận</th>
            <th style="width: 10%;">Hành động</th>
        </tr>
    </thead>
    <tbody>
        <c:if test="${empty commentList}">
            <tr>
                <td colspan="6" style="text-align: center;">Không có bình luận nào.</td>
            </tr>
        </c:if>
        <c:forEach var="comment" items="${commentList}">
            <tr>
                <td>${comment.commentId}</td>
                <td><c:out value="${comment.content}"/></td>
                <td>${comment.userId}</td>
                <td><a href="${pageContext.request.contextPath}/home.jsp#post-${comment.postId}" target="_blank">${comment.postId}</a></td>
                <td>
                     <fmt:setLocale value="vi_VN"/>
                     <fmt:formatDate value="${comment.createdAt}" pattern="HH:mm dd/MM/yyyy"/>
                </td>
                <td>
                    <form action="${pageContext.request.contextPath}/admin/comments" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa bình luận này?');">
                        <input type="hidden" name="commentId" value="${comment.commentId}">
                        <button type="submit" class="delete-btn" style="color: red;">Xóa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>