<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="admin_layout.jsp">
    <jsp:param name="title" value="Manage Comments"/>
</jsp:include>

<div class="container-fluid">
    <h1 class="mt-4">Manage Comments</h1>
    <div class="card mb-4">
        <div class="card-header"><i class="fas fa-comments mr-1"></i>Comment List</div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Comment ID</th>
                            <th>Post ID</th>
                            <th>User ID</th>
                            <th>Content</th>
                            <th>Created At</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${commentList}" var="comment">
                            <tr>
                                <td>${comment.commentId}</td>
                                <td>${comment.postId}</td>
                                <td>${comment.userId}</td>
                                <td>${comment.content}</td>
                                <td>${comment.createdAt}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/comments" method="post" style="display:inline;">
                                        <input type="hidden" name="commentId" value="${comment.commentId}">
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