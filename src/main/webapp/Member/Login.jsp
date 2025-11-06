<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
        crossorigin="anonymous">

  <!-- 로그인 관련 스크립트 -->
  <script type="text/javascript" src="${pageContext.request.contextPath}/Resources/script/member.js"></script>

  <style>
    /* ================================
       기본 스타일
    ================================ */
    body {
      font-family: 'Arial', sans-serif;
      background-color: #ffffff;
      padding-bottom: 100px;
    }

    header {
      background-color: #ffffff;
      font-weight: bolder;
    }

    header img {
      width: 100px;
      height: auto;
    }

    .header-divider {
      height: 4px;
      background: linear-gradient(to right, #bdf3ff, #2193b0);
      border: none;
    }

    footer {
      background-color: #f5f5f5;
      text-align: center;
      padding: 20px 0;
      position: relative;
      bottom: 0;
      width: 100%;
    }

    /* ================================
       로그인 박스
    ================================ */
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

  <%@ include file="/Resources/Header.jsp" %>

  <!-- ============================= -->
  <!--  로그인 폼 -->
  <!-- ============================= -->
  <div class="login-box">
    <div class="login-title">로그인</div>

    <!--  로그인 실패 시 에러 메시지 -->
    <c:if test="${not empty errorMsg}">
      <div class="alert alert-danger text-center">${errorMsg}</div>
    </c:if>

    <!-- ============================= -->
    <!-- 로그인 폼 영역 -->
    <!-- ============================= -->
    <form action="${pageContext.request.contextPath}/Login.do" method="post" name="frm">
      
      <!-- 아이디 입력 -->
      <div class="mb-3">
        <label for="userId" class="form-label">아이디</label>
        <input type="text" id="userId" name="userId" class="form-control"
               placeholder="아이디를 입력하세요" value="${param.userId}" required>
      </div>

      <!-- 비밀번호 입력 -->
      <div class="mb-3">
        <label for="userPw" class="form-label">비밀번호</label>
        <input type="password" id="userPw" name="password" class="form-control"
               placeholder="비밀번호를 입력하세요" required>
      </div>

      <!-- 로그인 버튼 -->
      <button type="submit" class="btn btn-login">로그인</button>
    </form>

    <!-- 회원가입 링크 -->
    <div class="signup-link">
      <a href="${pageContext.request.contextPath}/Member/SignUp.jsp">회원가입</a>
    </div>
  </div>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
          crossorigin="anonymous"></script>

</body>
</html>
