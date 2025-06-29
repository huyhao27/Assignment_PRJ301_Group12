<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="admin_layout.jsp">
    <jsp:param name="title" value="System Logs"/>
</jsp:include>

<div class="container-fluid">
    <h1 class="mt-4">System Logs</h1>
    <div class="card mb-4">
        <div class="card-header"><i class="fas fa-history mr-1"></i>Log List</div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Level</th>
                            <th>Message</th>
                            <th>User ID</th>
                            <th>Username</th>
                            <th>Timestamp</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${logList}" var="log">
                            <tr>
                                <td>${log.logId}</td>
                                <td>${log.level}</td>
                                <td>${log.message}</td>
                                <td>${log.userId}</td>
                                <td>${log.username}</td>
                                <td>${log.createdAt}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="admin_footer.jsp"/>