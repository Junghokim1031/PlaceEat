<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>비밀번호 찾기</title></head>
<body>
<h2>비밀번호 찾기</h2>
<form action="${pageContext.request.contextPath}/member/sendResetMail.do" method="post">
    아이디: <input type="text" name="userid" required><br>
    이름: <input type="text" name="name" required><br>
    이메일: <input type="email" name="email" required><br>
    <button type="submit">재설정 메일 보내기</button>
</form>

<p style="color:red;">
<%= request.getAttribute("message") == null ? "" : request.getAttribute("message") %>
</p>

<p><a href="${pageContext.request.contextPath}/member/Login.jsp">로그인으로</a></p>
</body>
</html>
