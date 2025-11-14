<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" crossorigin="anonymous">
</head>
<body>
<div class="container mt-5" style="max-width:500px;">
    <h3 class="text-center mb-4">비밀번호 재설정</h3>

    <c:if test="${not empty message}">
        <div class="alert alert-info text-center">${message}</div>
    </c:if>

<form action="${pageContext.request.contextPath}/Member/resetPassword.do" method="post">
    <input type="hidden" name="token" value="${param.token}">
    <div class="mb-3">
        <input type="password" name="newPassword" class="form-control" placeholder="새 비밀번호" required>
    </div>
    <button type="submit" class="btn btn-primary w-100">비밀번호 변경</button>
</form>

</div>
</body>
</html>
