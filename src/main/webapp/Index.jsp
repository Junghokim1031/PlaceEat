<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Place & Eat</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
        crossorigin="anonymous" />

  <style>
    /* =============================
       기본 스타일
    ============================= */
    body {
      font-family: 'Arial', sans-serif;
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

    /* =============================
       캐러셀 (메인 섹션)
    ============================= */
    .main-section h2 {
      font-size: 2rem;
      color: #333;
    }

    .main-section p {
      font-size: 1.1rem;
      color: #555;
      line-height: 1.6;
    }

    .carousel-item {
      padding: 40px 0;
    }

    .carousel-item img {
      width: 100%;
      height: 400px;
      object-fit: cover;
    }

    .carousel-indicators [data-bs-target] {
      background-color: gray;
      width: 12px;
      height: 12px;
      border-radius: 50%;
    }

    .carousel-indicators .active {
      background-color: black;
    }

    .carousel-item .col-md-6:first-child {
      padding-left: 50px;
      padding-right: 40px;
    }

    /* =============================
       카드(여행콕콕)
    ============================= */
    .travel-card img {
      width: 100%;
      height: 200px;
      object-fit: cover;
    }

    .card:hover {
      transform: scale(1.02);
      transition: 0.2s;
      cursor: pointer;
    }
  </style>
</head>

<body>
  <%@ include file="/Resources/Header.jsp" %>

  <!-- =============================
       메인 캐러셀 섹션
  ============================= -->
  <section class="main-section container my-5">
    <div id="travelCarousel" class="carousel slide" data-bs-ride="carousel">

      <!-- 캐러셀 아이템 -->
      <div class="carousel-inner">
        <c:forEach var="article" items="${mainArticles}" varStatus="status">
          <div class="carousel-item <c:if test='${status.first}'>active</c:if>">
            <div class="row align-items-center">
              
              <!-- 왼쪽 설명 -->
              <div class="col-md-6">
                <h2 class="fw-bold mb-3">${article.title}</h2>
                <p class="text-muted">${article.summary}</p>
              </div>

              <!-- 오른쪽 이미지 -->
              <div class="col-md-6">
                <a href="${pageContext.request.contextPath}/BoardView.do?board_id=${article.board_id}">
                  <img src="${pageContext.request.contextPath}/Img/${article.image}"
                       class="d-block w-100 rounded" alt="${article.title}">
                </a>
              </div>

            </div>
          </div>
        </c:forEach>
      </div>

      <!-- 인디케이터 -->
      <c:if test="${not empty mainArticles}">
        <div class="carousel-indicators mt-3">
          <c:forEach var="i" begin="0" end="${fn:length(mainArticles)-1}">
            <button type="button" data-bs-target="#travelCarousel" data-bs-slide-to="${i}"
              class="<c:if test='${i == 0}'>active</c:if>"
              aria-current="<c:if test='${i == 0}'>true</c:if>"
              aria-label="Slide ${i + 1}"></button>
          </c:forEach>
        </div>
      </c:if>
    </div>
  </section>

  <!-- =============================
       여행콕콕 (추천 기사)
  ============================= -->
  <section class="container my-5">
    <h3 class="fw-bold mb-4">여행콕콕</h3>
    <div class="row g-4">
      <c:forEach var="article" items="${recommendArticles}">
        <div class="col-md-3">
          <div class="card travel-card"
               onclick="location.href='${pageContext.request.contextPath}/BoardView.do?board_id=${article.board_id}'">
            <img src="${pageContext.request.contextPath}/Img/${article.image}"
                 class="card-img-top" alt="${article.title}">
            <div class="card-body">
              <h6 class="card-title fw-bold">${article.title}</h6>
              <p class="card-text small text-muted">${article.summary}</p>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </section>

  <!-- =============================
       최신 기사 목록
  ============================= -->
  <section class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3 class="fw-bold mb-0">최신 기사</h3>
      <a href="${pageContext.request.contextPath}/BoardList.do" class="text-decoration-none text-primary">더보기</a>
    </div>
    <ul class="list-group">
      <c:forEach var="article" items="${latestArticles}" end="9">
        <li class="list-group-item">
          <a href="${pageContext.request.contextPath}/BoardView.do?board_id=${article.board_id}"
             class="text-dark text-decoration-none">${article.title}</a>
        </li>
      </c:forEach>
    </ul>
  </section>

  <div class="footer-divider"></div>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
          crossorigin="anonymous"></script>
</body>
</html>
