<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>비밀번호 재설정</title></head>
<body>
<h2>새 비밀번호 설정</h2>
<form action="${pageContext.request.contextPath}/member/updatePassword.do" method="post">
    <input type="hidden" name="token" value="${token}">
    새 비밀번호: <input type="password" name="newPassword" required><br>
    새 비밀번호 확인: <input type="password" name="confirmPassword" required><br>
    <button type="submit">변경</button>
</form>

<p style="color:red;"><%= request.getAttribute("message") == null ? "" : request.getAttribute("message") %></p>
</body>
</html>
