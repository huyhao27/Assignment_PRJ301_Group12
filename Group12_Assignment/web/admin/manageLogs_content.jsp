<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h1 class="main-title">Log Hệ thống</h1>
<p>Tổng số log: <strong>${logList.size()}</strong></p>

<table class="cart-table">
    <thead>
        <tr>
            <th style="width: 5%;">ID</th>
            <th style="width: 10%;">Mức độ</th>
            <th style="width: 50%;">Nội dung</th>
            <th style="width: 15%;">Người thực hiện</th>
            <th style="width: 20%;">Thời gian</th>
        </tr>
    </thead>
    <tbody>
        <c:if test="${empty logList}">
            <tr>
                <td colspan="5" style="text-align: center;">Không có log nào.</td>
            </tr>
        </c:if>
        <c:forEach var="log" items="${logList}">
            <tr>
                <td>${log.logId}</td>
                <td>
                    <span style="font-weight: bold;
                        color: ${log.level == 'INFO' ? 'blue' : (log.level == 'WARN' ? 'orange' : 'red')};">
                        ${log.level}
                    </span>
                </td>
                <td><c:out value="${log.message}"/></td>
                <td>${not empty log.username ? log.username : 'SYSTEM'} (ID: ${log.userId})</td>
                <td>
                    <fmt:setLocale value="vi_VN"/>
                    <fmt:formatDate value="${log.createdAt}" pattern="HH:mm:ss dd/MM/yyyy"/>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>