<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>마이페이지 | Place & Eat</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
        crossorigin="anonymous" />

  <!-- 공통 헤더 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Footer.css">

  <style>
html, body {
  margin: 0 !important;
  padding: 0 !important;
}

body {
  display: flex;
  flex-direction: column;
  font-family: 'Arial', sans-serif;
  background-color: #ffffff;
  min-height: 100vh;
  padding-top: 100px;
  padding-bottom: 0; 
}
section.container.my-5 {
  flex: 1;
  margin-top: 0 !important; 
  margin-bottom: 0 !important;
  padding: 0;
}

/* ===== hr (구분선) 여백 제거 ===== */
hr {
  margin: 0 !important;
}


    .profile-box {
      max-width: 600px;
      margin: 50px auto;
      padding: 30px;
      border: 2px solid #9ec3ff;
      border-radius: 10px;
      background-color: #fff;
      text-align: center;
    }

    .profile-box img {
      width: 120px;
      height: auto;
      margin-bottom: 15px;
    }

    .username {
      font-size: 24px;
      font-weight: bold;
      margin-bottom: 20px;
    }

    .profile-box .btn {
      background-color: #888;
      color: white;
      font-weight: bold;
      border: none;
      width: 150px;
      margin: 5px;
    }

    .profile-box .btn:hover {
      background-color: #666;
    }

    .travel-card img {
      width: 100%;
      height: 180px;
      object-fit: cover;
    }

    .card.text-center {
      transition: 0.2s;
    }

    .card.text-center:hover {
      transform: scale(1.03);
    }

    .card.text-center img {
      border: 2px solid #9ec3ff;
    }

    .pagination {
      justify-content: center;
      margin-top: 20px;
    }
  </style>
</head>

<body>

  <!-- 공통 헤더 -->
  <jsp:include page="/Resources/Header.jsp" />

  <!-- ============================= -->
  <!-- 프로필 박스 -->
  <!-- ============================= -->
  <section>
    <div class="profile-box">
      <img src="${pageContext.request.contextPath}/Resources/Img/Logo.png" alt="로고" />
      <div class="username">${sessionScope.loginUser.name} 님</div>

      <div>
        <a href="${pageContext.request.contextPath}/Member/logout.do" class="btn">로그아웃</a>
        <a href="${pageContext.request.contextPath}/Member/UpdateInfo.do" class="btn">회원 정보수정</a>
      </div>

      <!-- 기자 전용 버튼 -->
      <c:if test="${sessionScope.loginUser.grade == 'R'}">
        <a href="${pageContext.request.contextPath}/Board/Write.do" 
           class="btn mt-2" style="width:200px;">신규 기사 등록</a>
      </c:if>
    </div>
  </section>

  <!-- ============================= -->
  <!-- 여행 기사 / 활동 목록 -->
  <!-- ============================= -->
  <section class="container my-5">

    <c:choose>
  <%-- 기자용 --%>
  <c:when test="${sessionScope.loginUser.grade == 'R'}">
    <h4 class="text-center mb-4">내가 작성한 기사</h4>

    <c:if test="${empty boardLists}">
      <div class="text-center text-muted my-5">등록한 여행 기사가 없습니다.</div>
    </c:if>

    <div class="row g-4">
      <c:forEach var="article" items="${boardLists}">
        <div class="col-md-4 col-lg-3">
          <a href="${pageContext.request.contextPath}/Board/View.do?boardId=${article.boardId}"
             class="text-decoration-none text-dark">
            <div class="card travel-card h-100">
              <img src="${pageContext.request.contextPath}/Uploads/${article.imgSfilename}" 
                   class="card-img-top" alt="${article.title}">
              <div class="card-body">
                <h6 class="card-title fw-bold">${article.title}</h6>
                <p class="card-text small text-muted">${article.details}</p>
              </div>
            </div>
          </a>
        </div>
      </c:forEach>
    </div>

    <%-- 기자 페이징 --%>
    <nav>
      <ul class="pagination justify-content-center">
        <c:out value="${map.pagingImg}" escapeXml="false" />
      </ul>
    </nav>
  </c:when>
</c:choose>

<!-- 👇 아래 부분은 기자/일반유저 공통으로 노출 -->
<hr class="my-5" />

<h4 class="text-center mb-4">내가 좋아요한 게시글</h4>
<div class="row g-4">
  <c:forEach var="post" items="${likedLists}">
    <div class="col-md-4 col-lg-3">
      <a href="${pageContext.request.contextPath}/Board/View.do?boardId=${post.boardId}" 
         class="text-decoration-none text-dark">
        <div class="card travel-card h-100">
          <img src="${pageContext.request.contextPath}/Uploads/${post.imgSfilename}" 
               class="card-img-top" alt="${post.title}">
          <div class="card-body">
            <h6 class="card-title fw-bold">${post.title}</h6>
            <p class="card-text small text-muted">${post.details}</p>
          </div>
        </div>
      </a>
    </div>
  </c:forEach>
</div>

<nav>
  <ul class="pagination justify-content-center">
    <c:out value="${map.likedPaging}" escapeXml="false" />
  </ul>
</nav>

<h4 class="text-center mb-4 mt-5">내가 댓글 단 게시글</h4>
<div class="row g-4">
  <c:forEach var="post" items="${commentedLists}">
    <div class="col-md-4 col-lg-3">
      <a href="${pageContext.request.contextPath}/Board/View.do?boardId=${post.boardId}" 
         class="text-decoration-none text-dark">
        <div class="card travel-card h-100">
          <img src="${pageContext.request.contextPath}/Uploads/${post.imgSfilename}" 
               class="card-img-top" alt="${post.title}">
          <div class="card-body">
            <h6 class="card-title fw-bold">${post.title}</h6>
            <p class="card-text small text-muted">${post.details}</p>
          </div>
        </div>
      </a>
    </div>
  </c:forEach>
</div>

<nav>
  <ul class="pagination justify-content-center">
    <c:out value="${map.commentPaging}" escapeXml="false" />
  </ul>
</nav>

  </section>


	<%-- 기자 전용 페이징 처리 --%>
	<c:if test="${sessionScope.loginUser.grade == 'R'}">
	  <nav>
	    <ul class="pagination justify-content-center">
	      <c:out value="${map.pagingImg}" escapeXml="false" />
	    </ul>
	  </nav>
	</c:if>

  <jsp:include page="/Resources/Footer.jsp" />
  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
          crossorigin="anonymous"></script>
</body>
</html>
