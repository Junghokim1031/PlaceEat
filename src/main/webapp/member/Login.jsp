<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%
    // 쿠키에서 아이디 저장값 불러오기
    String savedId = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if (c.getName().equals("userid")) {
                savedId = c.getValue();
                break;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <style>
        body { font-family: '맑은 고딕', sans-serif; background-color: #f4f4f4; }
        .login-box {
            width: 360px; margin: 100px auto; padding: 30px;
            background: white; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .login-box h2 { text-align: center; margin-bottom: 25px; }
        input[type=text], input[type=password] {
            width: 95%; padding: 10px; margin: 8px 0;
            border: 1px solid #ccc; border-radius: 5px;
        }
        button {
            width: 100%; padding: 10px; margin-top: 10px;
            background-color: #007bff; color: white; border: none; border-radius: 5px;
        }
        .options {
            text-align: center; margin-top: 10px;
        }
        .options a { color: #007bff; text-decoration: none; margin: 0 5px; }
        .options a:hover { text-decoration: underline; }
        .message { color: red; text-align: center; margin-top: 10px; }
        .remember {
            text-align: left;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="login-box">
    <h2>로그인</h2>

    <form action="login.do" method="post">
        <input type="text" name="userid" placeholder="아이디" value="<%= savedId %>" required>
        <input type="password" name="pwd" placeholder="비밀번호" required>

        <div class="remember">
            <label>
                <input type="checkbox" name="remember" value="on"
                    <%= (savedId != null && !savedId.isEmpty()) ? "checked" : "" %>> 아이디 저장
            </label>
        </div>

        <button type="submit">로그인</button>

        <div class="message">${message}</div>

        <div class="options">
            <a href="FindId.jsp">아이디 찾기</a> |
            <a href="ForgotPassword.jsp">비밀번호 찾기</a> |
            <a href="Join.jsp">회원가입</a>
        </div>
    </form>
</div>
</body>
</html>
