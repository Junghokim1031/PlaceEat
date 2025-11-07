<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - 내가 쓴 글</title>

<style>
    body { 
        font-family: "맑은 고딕", sans-serif; 
        background-color: #f5f6f7; 
        margin: 20px; 
    }
    a { text-decoration: none; color: #333; }
    h2 { margin-bottom: 20px; }

    /* 프로필 영역 */
    .profile-box {
        width: 90%;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        display: flex;
        align-items: center;
        padding: 20px;
        margin-bottom: 30px;
    }

    .profile-box img {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
        margin-right: 20px;
        background-color: #eee;
    }

    .profile-info {
        flex-grow: 1;
    }

    .profile-info h3 {
        margin: 0;
        font-size: 1.4em;
        color: #333;
    }

    .profile-info p {
        margin: 5px 0 0;
        color: #666;
        font-size: 0.95em;
    }

    /* 카드 레이아웃 */
    .card-container {
        width: 90%;
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .card {
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        overflow: hidden;
        cursor: pointer;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .card img {
        width: 100%;
        height: 180px;
        object-fit: cover;
        background-color: #eee;
    }

    .card-content {
        padding: 15px;
    }

    .card-title {
        font-weight: bold;
        font-size: 1.1em;
        margin: 8px 0;
        color: #333;
    }

    .card-date {
        font-size: 0.85em;
        color: #777;
        margin-bottom: 8px;
    }

    /* 하단 메뉴 */
    .bottom-menu {
        width: 90%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #fff;
        padding: 15px;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .bottom-menu button {
        background-color: #28a745;
        border: none;
        color: #fff;
        padding: 8px 15px;
        border-radius: 4px;
        cursor: pointer;
    }

    .bottom-menu button:hover {
        background-color: #218838;
    }
</style>
</head>
<body>

<!-- ✅ 프로필 카드 -->
<div class="profile-box">
    <img src="../images/default_profile.png" alt="프로필 이미지">
    <div class="profile-info">
        <h3>안녕하세요, <strong>${sessionScope.userId}</strong> 님 👋</h3>
        <p>총 <strong>${map.totalCount}</strong>개의 글을 작성하셨습니다.</p>
    </div>
</div>

<h2>📋 내가 쓴 글 목록</h2>

<!-- 게시물 카드 리스트 -->
<c:choose>    
    <c:when test="${ empty boardLists }">
        <div style="width:90%; text-align:center; padding:40px; background:#fff; border-radius:8px; box-shadow:0 2px 5px rgba(0,0,0,0.1);">
            등록된 글이 없습니다 😊
        </div>
    </c:when>
    <c:otherwise>
        <div class="card-container">
            <c:forEach items="${ boardLists }" var="row">
                <div class="card" onclick="location.href='../controller/view.do?boardId=${row.boardId}'">
                    
                    <!-- 이미지 -->
                    <c:choose>
                        <c:when test="${ not empty row.imgSfilename }">
                            <img src="../Uploads/${ row.imgSfilename }" alt="첨부 이미지" />
                        </c:when>
                        <c:otherwise>
                            <img src="../images/noimage.png" alt="이미지 없음" />
                        </c:otherwise>
                    </c:choose>

                    <div class="card-content">
                        <!-- 제목 -->
                        <div class="card-title">${ row.title }</div>
                        <!-- 등록일자 -->
                        <div class="card-date">${ row.createdAt }</div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<!-- 하단 메뉴 -->
<div class="bottom-menu">
    <div>${ map.pagingImg }</div>
    <button type="button" onclick="location.href='write.do';">글쓰기</button>
</div>

</body>
</html>
