<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<head>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
		integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<style>

	
	header {
	  background-color: #ffffff;
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
</style>
</head>
<header class="py-3">
  <div class="container d-flex justify-content-between align-items-center">
    <img src="${pageContext.request.contextPath}/Resources/Img/Logo.png" alt="로고">
    <nav>
      <a href="${pageContext.request.contextPath}/Main.jsp" class="me-3 text-dark text-decoration-none">홈</a>
      <a href="#" class="me-3 text-dark text-decoration-none">추천 여행 기사</a>
      <a href="${pageContext.request.contextPath}/User/Login.jsp" class="me-3 text-dark text-decoration-none">로그인</a>
      <a href="${pageContext.request.contextPath}/User/SignUp.jsp" class="text-dark text-decoration-none">회원가입</a>
    </nav>
  </div>
</header>

<div class="header-divider"></div>


