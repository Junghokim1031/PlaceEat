<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<style>
    /* 카드 스타일 */
    .card-container {
        display: flex;
        gap: 20px;
        flex-wrap: wrap;
        margin-top: 20px;
    }
    .card {
        width: 220px;
        border: 1px solid #ddd;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    .card img {
        width: 100%;
        height: 140px;
        object-fit: cover;
    }
    .card-content {
        padding: 10px;
    }
    .card-content h4 {
        margin: 5px 0;
    }
    .card-content a {
        text-decoration: none;
        color: #333;
    }
    .card-content p {
        margin: 5px 0;
        color: #777;
        font-size: 12px;
    }

    /* 최신글 테이블 스타일 */
    table.latest-boards {
        width: 100%;
        border-collapse: collapse;
        margin-top: 40px;
    }
    table.latest-boards th, table.latest-boards td {
        border: 1px solid #ccc;
        padding: 8px;
        text-align: left;
    }
    table.latest-boards th {
        background-color: #f5f5f5;
    }
    table.latest-boards img {
        width: 80px;
        height: 60px;
        object-fit: cover;
    }
</style>
</head>
<body>
<h2>조회수 많은 것 3개 추출</h2>
<div class="card-container">
    <c:forEach var="board" items="${topViewedBoards}">
        <div class="card">
            <img src="${pageContext.request.contextPath}/uploads/${board.imgSfilename}" alt="${board.title}">
            <div class="card-content">
                <h4>
                    <a href="${pageContext.request.contextPath}/controller/view.do?boardId=${board.boardId}">
                        ${board.title}
                    </a>
                </h4>
                <p>조회수: ${board.viewCount}</p>
                <p><fmt:formatDate value="${board.createdAt}" pattern="yyyy-MM-dd"/></p>
            </div>
        </div>
    </c:forEach>
</div>



<h2>좋아요 많은 게시글 Top 4</h2>
<div class="card-container">
    <c:forEach var="board" items="${topLikedBoards}">
        <div class="card">
            <img src="${pageContext.request.contextPath}/uploads/${board.imgSfilename}" alt="${board.title}">
            <div class="card-content">
                <h4>
                    <a href="${pageContext.request.contextPath}/controller/view.do?boardId=${board.boardId}">
                        ${board.title}
                    </a>
                </h4>
                <p>좋아요: ${board.likeCount}</p>
                <p><fmt:formatDate value="${board.createdAt}" pattern="yyyy-MM-dd"/></p>
            </div>
        </div>
    </c:forEach>
</div>

<h2>최신 게시글 5개</h2>
<table class="latest-boards">
    <tr>
        <th>사진</th>
        <th>제목</th>
        <th>등록일자</th>
    </tr>
    <c:forEach var="board" items="${latestBoards}">
        <tr>
            <td><img src="${pageContext.request.contextPath}/uploads/${board.imgSfilename}" alt="${board.title}"></td>
            <td>
                <a href="${pageContext.request.contextPath}/controller/view.do?boardId=${board.boardId}">
                    ${board.title}
                </a>
            </td>
            <td><fmt:formatDate value="${board.createdAt}" pattern="yyyy-MM-dd"/></td>
        </tr>
    </c:forEach>
</table>

</body>
</html>