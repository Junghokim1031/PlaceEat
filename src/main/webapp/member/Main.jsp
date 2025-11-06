<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.placeeat.dao.MemberVO" %>
<%
    MemberVO user = (MemberVO)session.getAttribute("loginUser");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인 페이지</title>
<style>
body { font-family: '맑은 고딕'; background-color: #f8f9fa; text-align: center; margin-top: 100px; }
h1 { color: #333; }
button {
background: #dc3545; border: none; padding: 10px 20px; color: #fff;
border-radius: 5px; cursor: pointer; margin-top: 20px;
}
button:hover { background: #c82333; }
</style>
</head>
<body>
<h1>어서오세요, <%= user.getName() %> 님!</h1>
<p>아이디: <%= user.getUserid() %></p>
<form action="logout.do" method="post">
<button type="submit">로그아웃</button>
</form>
</body>
</html>
