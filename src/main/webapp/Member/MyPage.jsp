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

  <style>
    body {
      font-family: 'Arial', sans-serif;
      background-color: #ffffff;
      padding-top: 100px;
      padding-bottom: 100px;
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
        <a href="${pageContext.request.contextPath}/Article/Write.do" 
           class="btn mt-2" style="width:200px;">신규 기사 등록</a>
      </c:if>
    </div>
  </section>

  <!-- ============================= -->
  <!-- 여행 기사 / 활동 목록 -->
  <!-- ============================= -->
  <section class="container my-5">

    <c:choose>
      <!-- 기자용 -->
      <c:when test="${sessionScope.loginUser.grade == 'R'}">
        <h4 class="text-center mb-4">내가 작성한 기사</h4>

        <c:if test="${empty articleList}">
          <div class="text-center text-muted my-5">등록한 여행 기사가 없습니다.</div>
        </c:if>

        <div class="row g-4">
          <c:forEach var="article" items="${articleList}">
            <div class="col-md-4 col-lg-3">
              <a href="${pageContext.request.contextPath}/ArticleDetail.do?board_id=${article.board_id}"
                 class="text-decoration-none text-dark">
                <div class="card travel-card h-100">
                  <img src="${pageContext.request.contextPath}/upload/${article.img_sfilename}" 
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
      </c:when>

      <!-- 일반 유저용 -->
      <c:otherwise>
        <h4 class="text-center mb-4">내가 좋아요한 게시글</h4>
        <div class="row g-4">
          <c:forEach var="post" items="${likedList}">
            <div class="col-md-4 col-lg-3">
              <a href="${pageContext.request.contextPath}/ArticleDetail.do?board_id=${post.board_id}" 
                 class="text-decoration-none text-dark">
                <div class="card travel-card h-100">
                  <img src="${pageContext.request.contextPath}/upload/${post.img_sfilename}" 
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

        <h4 class="text-center mb-4 mt-5">내가 댓글 단 게시글</h4>
        <div class="row g-4">
          <c:forEach var="post" items="${commentedList}">
            <div class="col-md-4 col-lg-3">
              <a href="${pageContext.request.contextPath}/ArticleDetail.do?board_id=${post.board_id}" 
                 class="text-decoration-none text-dark">
                <div class="card travel-card h-100">
                  <img src="${pageContext.request.contextPath}/upload/${post.img_sfilename}" 
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

        <!-- 친구 목록 -->
        <h4 class="text-center mb-4 mt-5">내 친구 목록</h4>

        <!-- 친구 검색/요청 -->
        <div class="text-center mb-4">
          <form action="${pageContext.request.contextPath}/Friend/Search.do" method="get" class="d-inline-block">
            <input type="text" name="keyword" placeholder="친구 이름 또는 ID 검색"
                   class="form-control d-inline-block" style="width: 250px;">
            <button type="submit" class="btn btn-primary">검색</button>
          </form>
          <a href="${pageContext.request.contextPath}/Friend/Requests.do" class="btn btn-outline-secondary ms-2">
            친구 요청 관리
          </a>
        </div>

        <div class="row g-4">
          <c:if test="${empty friendList}">
            <div class="text-center text-muted my-5">등록된 친구가 없습니다.</div>
          </c:if>

          <c:forEach var="friend" items="${friendList}">
            <div class="col-md-4 col-lg-3">
              <div class="card text-center p-3 shadow-sm">
                <img src="${pageContext.request.contextPath}/upload/${friend.profile_img}" 
                     alt="프로필" class="rounded-circle mx-auto mb-3" 
                     style="width:80px; height:80px; object-fit:cover;">
                <h6 class="fw-bold mb-1">${friend.name}</h6>
                <p class="text-muted small mb-2">@${friend.userid}</p>
                <p class="small text-secondary">${friend.intro}</p>
                <form action="${pageContext.request.contextPath}/Friend/Delete.do" method="post">
                  <input type="hidden" name="friend_id" value="${friend.userid}">
                  <button type="submit" class="btn btn-outline-danger btn-sm">삭제</button>
                </form>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </section>

  <!-- 페이지네이션 (예시용) -->
  <nav>
    <ul class="pagination justify-content-center">
      <li class="page-item"><a class="page-link" href="#">&laquo;</a></li>
      <li class="page-item"><a class="page-link" href="#">1</a></li>
      <li class="page-item"><a class="page-link" href="#">2</a></li>
      <li class="page-item"><a class="page-link" href="#">3</a></li>
      <li class="page-item"><a class="page-link" href="#">&raquo;</a></li>
    </ul>
  </nav>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
          crossorigin="anonymous"></script>
</body>
</html>
