<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="admin_layout.jsp">
    <jsp:param name="title" value="Manage Posts"/>
</jsp:include>

<div class="container-fluid">
    <h1 class="mt-4">Manage Posts</h1>
    <div class="card mb-4">
        <div class="card-header"><i class="fas fa-file-alt mr-1"></i>Post List</div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Post ID</th>
                            <th>User ID</th>
                            <th>Content</th>
                            <th>Image</th>
                            <th>Created At</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${postList}" var="post">
                            <tr>
                                <td>${post.postId}</td>
                                <td>${post.userId}</td>
                                <td>${post.content}</td>
                                <td><img src="${pageContext.request.contextPath}/images/post/${post.image}" alt="Post Image" width="50"></td>
                                <td>${post.createdAt}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/posts" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="postId" value="${post.postId}">
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