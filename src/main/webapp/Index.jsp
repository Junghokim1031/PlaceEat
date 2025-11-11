<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Place & Eat</title>

  <!-- =============================
       CSS / Library Import
  ============================== -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
        crossorigin="anonymous" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Header.css">

  <style>
    body {
      font-family: 'Arial', sans-serif;
    }

    /* =============================
       캐러셀 (Main Carousel)
    ============================== */
    #travel-carousel {
      position: relative;
      overflow: hidden;
    }

    .carousel-item {
      height: 500px;
      position: relative;
    }

    .carousel-item img {
      width: 100%;
      height: 500px;
      object-fit: cover;
      transition: transform 0.6s ease;
    }

    .carousel-caption {
      position: absolute;
      bottom: 40px;
      left: 50px;
      text-align: left;
      color: #ffffff;
      text-shadow: 0 2px 6px rgba(0, 0, 0, 0.6);
    }

    .carousel-caption h2 {
      font-size: 2rem;
      font-weight: 700;
      margin-bottom: 8px;
    }

    .carousel-caption p {
      font-size: 1.05rem;
      line-height: 1.5;
      max-width: 500px;
      opacity: 0.9;
      color: #e0e0e0;
    }

    .carousel-indicators {
      bottom: 20px;
    }

    .carousel-indicators [data-bs-target] {
      background-color: rgba(255, 255, 255, 0.6);
      width: 10px;
      height: 10px;
      border-radius: 50%;
      margin: 0 5px;
      transition: background-color 0.3s ease;
    }

    .carousel-indicators .active {
      background-color: #64c3db;
    }

    /* =============================
       추천 기사 카드 (Recommend Section)
    ============================== */
    .travel-card {
      height: 340px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      overflow: hidden;
    }

    .travel-card img {
      width: 100%;
      height: 180px;
      object-fit: cover;
    }

    .card:hover {
      transform: scale(1.02);
      transition: 0.2s;
      cursor: pointer;
    }

    .travel-card .card-body {
      flex: 1;
      padding: 8px 10px;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .travel-card .card-title {
      font-weight: bold;
      font-size: 1rem;
      margin-bottom: 6px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .travel-card .card-text {
      font-size: 0.9rem;
      color: #666;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    /* =============================
       최신 기사 (Latest Articles)
    ============================== */
    .latest-list a {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 14px 10px;
      border-bottom: 1px solid #eee;
      color: #333;
      text-decoration: none;
      transition: all 0.25s ease;
    }

    .latest-list a:hover {
      background: #f9f9f9;
      color: #007bff;
      padding-left: 15px;
    }

    .latest-list .title {
      font-weight: 500;
      font-size: 1rem;
      flex: 1;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .latest-list .meta {
      flex-shrink: 0;
      font-size: 0.85rem;
      color: #888;
      white-space: nowrap;
    }

    .latest-list .meta i {
      margin-right: 5px;
      color: #aaa;
    }

    .header-divider {
      height: 4px;
      background: linear-gradient(to right, #bdf3ff, #2193b0);
      border: none;
    }

    .divider {
      height: 1px;
      background: gray;
      border: none;
    }
  </style>
</head>

<body>
  <jsp:include page="/Resources/Header.jsp" />

  <!-- =============================
       메인 캐러셀 (Main Carousel)
  ============================== -->
  <c:if test="${not empty mainArticles}">
    <div id="travel-carousel" class="carousel slide" data-bs-ride="carousel">
      <div class="carousel-inner">
        <c:forEach var="article" items="${mainArticles}" varStatus="status">
          <div class="carousel-item ${status.first ? 'active' : ''}">
            <img src="${pageContext.request.contextPath}/resources/img/${article.img_sfilename}" alt="${article.title}">
            <div class="carousel-caption">
              <h2>${article.title}</h2>
              <p>${article.details}</p>
            </div>
          </div>
        </c:forEach>
      </div>

      <div class="carousel-indicators">
        <c:forEach var="i" begin="0" end="${fn:length(mainArticles)-1}">
          <button type="button" data-bs-target="#travel-carousel" data-bs-slide-to="${i}"
                  class="${i == 0 ? 'active' : ''}"></button>
        </c:forEach>
      </div>
    </div>
  </c:if>

  <c:if test="${empty mainArticles}">
    <div class="text-center text-muted py-5">등록된 메인 기사가 없습니다.</div>
  </c:if>

  <div class="header-divider"></div>

  <!-- =============================
       여행콕콕 (Recommend Section)
  ============================== -->
  <section class="container my-5">
    <h3 class="fw-bold mb-4">여행콕콕</h3>

    <c:if test="${not empty recommendArticles}">
      <div class="row g-4">
        <c:forEach var="article" items="${recommendArticles}">
          <div class="col-md-3">
            <div class="card travel-card"
                 onclick="location.href='${pageContext.request.contextPath}/board/view.do?board_id=${article.board_id}'">
              <img src="${pageContext.request.contextPath}/resources/img/${article.img_sfilename}" class="card-img-top" alt="${article.title}">
              <div class="card-body">
                <h6 class="card-title fw-bold">${article.title}</h6>
                <p class="card-text small text-muted">${article.details}</p>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:if>

    <c:if test="${empty recommendArticles}">
      <div class="text-center text-muted my-5">추천 기사가 없습니다.</div>
    </c:if>
  </section>

  <div class="divider"></div>

  <!-- =============================
       최신 기사 목록 (Latest Section)
  ============================== -->
  <section class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3 class="fw-bold mb-0">최신 기사</h3>
      <a href="${pageContext.request.contextPath}/board/list.do" class="text-decoration-none text-primary">더보기</a>
    </div>

    <c:if test="${not empty latestArticles}">
      <div class="latest-list">
        <c:forEach var="article" items="${latestArticles}">
          <a href="${pageContext.request.contextPath}/board/view.do?board_id=${article.board_id}">
            <span class="title">${article.title}</span>
            <span class="meta">
              <i class="fa-regular fa-eye"></i> ${article.viewcount} |
              <i class="fa-regular fa-calendar"></i> ${article.created_at}
            </span>
          </a>
        </c:forEach>
      </div>
    </c:if>

    <c:if test="${empty latestArticles}">
      <div class="text-center text-muted my-5">최근 등록된 기사가 없습니다.</div>
    </c:if>
  </section>

  <!-- =============================
       JS / Bootstrap Script
  ============================== -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
          crossorigin="anonymous"></script>
</body>
</html>
