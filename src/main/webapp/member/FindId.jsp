<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }
        h2 {
            color: #333;
        }
        form {
            width: 300px;
        }
        input[type="text"], input[type="submit"] {
            width: 100%;
            padding: 8px;
            margin-top: 6px;
            margin-bottom: 12px;
            box-sizing: border-box;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            border: none;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .result {
            color: blue;
            margin-top: 10px;
        }
        .error {
            color: red;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <h2>아이디 찾기</h2>
    <form action="findid.do" method="post">
        <label>이름</label><br>
        <input type="text" name="name" required><br>

        <label>생년월일 (예: 19900101)</label><br>
        <input type="text" name="birth" maxlength="8" required><br>

        <input type="submit" value="아이디 찾기">
    </form>

    <%
        String foundId = (String) request.getAttribute("foundId");
        String message = (String) request.getAttribute("message");

        if (foundId != null) {
    %>
        <div class="result">회원님의 아이디는 <strong><%= foundId %></strong> 입니다.</div>
    <%
        } else if (message != null) {
    %>
        <div class="error"><%= message %></div>
    <%
        }
    %>

    <p style="margin-top: 20px;">
        <a href="../member/Login.jsp">로그인 페이지로 돌아가기</a>
    </p>
</body>
</html>
