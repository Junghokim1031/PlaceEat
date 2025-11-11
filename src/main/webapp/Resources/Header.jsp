<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="py-3">
  <div class="container d-flex justify-content-between align-items-center">
    <!-- 로고 -->
    <a href="${pageContext.request.contextPath}/Main.do">
      <img src="${pageContext.request.contextPath}/Resources/Img/Logo.png" alt="로고">
    </a>
    
    <!-- 네비게이션 -->
    <nav>
      <a href="${pageContext.request.contextPath}/Main.do" class="me-3 text-dark text-decoration-none">홈</a>
      <a href="${pageContext.request.contextPath}/Board/List.do" class="me-3 text-dark text-decoration-none">추천 여행 기사</a>

      <c:choose>
        <c:when test="${not empty sessionScope.loginUser}">
          <a href="${pageContext.request.contextPath}/Member/logout.do" 
             class="me-3 text-dark text-decoration-none">로그아웃</a>
          <a href="${pageContext.request.contextPath}/Member/MyPage.do" 
             class="text-dark text-decoration-none">마이페이지</a>
        </c:when>

        <c:otherwise>
          <a href="${pageContext.request.contextPath}/Member/Login.jsp" 
             class="me-3 text-dark text-decoration-none">로그인</a>
          <a href="${pageContext.request.contextPath}/Member/SignUp.jsp" 
             class="text-dark text-decoration-none">회원가입</a>
        </c:otherwise>
      </c:choose>
    </nav>
  </div>
</header>

<!-- 헤더 구분선 -->
<div class="header-divider"></div>
