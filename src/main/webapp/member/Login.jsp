<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인 | Place & Eat</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
        crossorigin="anonymous">

  <!-- JS -->
  <script type="text/javascript" src="${pageContext.request.contextPath}/Resources/script/member.js"></script>

  <!-- Header CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Header.css">

  <style>
    body {
      font-family: 'Arial', sans-serif;
      background-color: #ffffff;
      padding-bottom: 100px;
    }

    .login-box {
      max-width: 400px;
      margin: 100px auto;
      padding: 40px 30px;
      border: 1px solid #ddd;
      border-radius: 10px;
      background: #fff;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    .login-title {
      font-size: 28px;
      font-weight: bold;
      text-align: center;
      margin-bottom: 30px;
    }

    .form-control {
      border: none;
      border-bottom: 1px solid #000;
      border-radius: 0;
      box-shadow: none;
    }

    .btn-login {
      background-color: #888;
      color: #fff;
      width: 100%;
      padding: 10px;
      font-weight: bold;
      margin-top: 20px;
      transition: background-color 0.2s ease;
    }

    .btn-login:hover {
      background-color: #666;
    }

    .signup-link {
      text-align: center;
      margin-top: 15px;
      font-size: 14px;
    }

    .signup-link a {
      text-decoration: none;
      color: #999;
    }

    .signup-link a:hover {
      text-decoration: underline;
    }
  </style>
</head>

<body>

  <!-- Header include -->
  <jsp:include page="/Resources/Header.jsp" />

  <!-- ============================= -->
  <!-- 로그인 박스 -->
  <!-- ============================= -->
  <div class="login-box">
    <div class="login-title">로그인</div>

    <!-- 로그인 실패 메시지 -->
    <c:if test="${not empty message}">
      <div class="alert alert-danger text-center">${message}</div>
    </c:if>

    <!-- 로그인 폼 -->
    <form action="${pageContext.request.contextPath}/Member/login.do" method="post" name="frm">
      
      <!-- 아이디 -->
      <div class="mb-3">
        <label for="userid" class="form-label">아이디</label>
        <input type="text" id="userid" name="userid" class="form-control"
               placeholder="아이디를 입력하세요"
               value="${cookie.userid.value}" required>
      </div>

      <!-- 비밀번호 -->
      <div class="mb-3">
        <label for="pwd" class="form-label">비밀번호</label>
        <input type="password" id="pwd" name="pwd" class="form-control"
               placeholder="비밀번호를 입력하세요" required>
      </div>

      <!-- 로그인 상태 유지 -->
      <div class="form-check mb-3">
        <input type="checkbox" class="form-check-input" id="remember" name="remember"
               <c:if test="${not empty cookie.userid.value}">checked</c:if>>
        <label class="form-check-label" for="remember">로그인 상태 유지</label>
      </div>

      <!-- 버튼 -->
      <button type="submit" class="btn btn-login">로그인</button>
    </form>

    <!-- 회원가입 -->
    <div class="signup-link">
      <a href="${pageContext.request.contextPath}/Member/SignUp.jsp">회원가입</a>
    </div>
  </div>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
          crossorigin="anonymous"></script>

</body>
</html>
