<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>📋 파일 첨부형 게시판 (카드형 + 해시태그)</title>

<style>
    body {
        font-family: "Pretendard", "맑은 고딕", sans-serif;
        background-color: #f5f6fa;
        margin: 0;
        padding: 30px;
    }

    h2 {
        margin-bottom: 20px;
        color: #333;
    }

    a {
        text-decoration: none;
        color: inherit;
    }

    /* 🔍 검색창 */
    .search-box {
        width: 100%;
        display: flex;
        align-items: center;
        gap: 10px;
        background: #fff;
        padding: 15px 20px;
        border-radius: 10px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        margin-bottom: 25px;
    }

    .search-box select,
    .search-box input[type="text"] {
        padding: 8px 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        outline: none;
        font-size: 0.95em;
    }

    .search-box input[type="submit"] {
        padding: 8px 16px;
        background-color: #4a90e2;
        color: white;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .search-box input[type="submit"]:hover {
        background-color: #3578d4;
    }

    /* 📦 메인 레이아웃 */
    .main-content {
        display: flex;
        gap: 25px;
        align-items: flex-start;
    }

    /* 🧾 카드 영역 */
    .card-container {
        flex: 1;
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
    }

    .card {
        background-color: #fff;
        border-radius: 12px;
        box-shadow: 0 3px 6px rgba(0,0,0,0.1);
        overflow: hidden;
        cursor: pointer;
        transition: transform 0.25s ease, box-shadow 0.25s ease;
    }

    .card:hover {
        transform: translateY(-6px);
        box-shadow: 0 6px 14px rgba(0,0,0,0.15);
    }

    .card img {
        width: 100%;
        height: 180px;
        object-fit: cover;
        background-color: #f0f0f0;
    }

    .card-content {
        padding: 15px;
    }

    .card-title {
        font-weight: bold;
        font-size: 1.1em;
        color: #333;
        margin-bottom: 8px;
        line-height: 1.3;
    }

    .card-body {
        font-size: 0.9em;
        color: #666;
        line-height: 1.5;
    }

    /* 🏷 해시태그 영역 */
    .hashtag-panel {
        width: 300px;
        background: #fff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 3px 6px rgba(0,0,0,0.1);
    }

    .hashtag-panel h3 {
        margin-bottom: 10px;
        padding-bottom: 5px;
        border-bottom: 2px solid #eee;
        color: #333;
    }

    .hashtag-group {
        margin-bottom: 20px;
    }

    .hashtag {
        display: inline-block;
        margin: 5px 6px 5px 0;
        padding: 6px 12px;
        font-size: 0.9em;
        border-radius: 20px;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    /* 🎨 지역/테마 해시태그 색상 구분 */
    .hashtag.location {
        background-color: #e8f4ff;
        color: #3578d4;
        border: 1px solid #bcd9ff;
    }

    .hashtag.location:hover {
        background-color: #3578d4;
        color: white;
    }

    .hashtag.theme {
        background-color: #fdf3e7;
        color: #d97a00;
        border: 1px solid #ffd9a3;
    }

    .hashtag.theme:hover {
        background-color: #d97a00;
        color: white;
    }

    /* 🚀 하단 메뉴 */
    .bottom-menu {
        margin-top: 30px;
        text-align: center;
    }

    .bottom-menu button {
        padding: 10px 20px;
        background-color: #4a90e2;
        color: white;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.2s ease;
        font-size: 0.95em;
    }

    .bottom-menu button:hover {
        background-color: #3578d4;
    }

</style>
</head>
<body>
    <h2>✈️ 여행기사</h2>
	
	<!-- 🧭 전체 목록으로 버튼 -->
        <div class="go-list">
            <button type="button" onclick="location.href='list.do';">
                🔄 전체 목록으로 보기
            </button>
        </div>
    </div>
    
    <!-- 🔍 검색 폼 -->
    <form method="get" class="search-box">
        <select name="searchField">
            <option value="title">제목</option>
            <option value="content">내용</option>
        </select>
        <input type="text" name="searchWord" placeholder="검색어를 입력하세요" />
        <input type="submit" value="검색하기" />
    </form>

    <!-- 🧱 메인 영역 -->
    <div class="main-content">

        <!-- 🧾 카드 리스트 -->
        <c:choose>
            <c:when test="${ empty boardLists }">
                <div style="width:100%; text-align:center; padding:60px; background:#fff; border-radius:8px; box-shadow:0 2px 5px rgba(0,0,0,0.1); font-size:1.1em; color:#666;">
                    등록된 게시물이 없습니다 😊
                </div>
            </c:when>
            <c:otherwise>
                <div class="card-container">
                    <c:forEach items="${ boardLists }" var="row">
                        <div class="card" onclick="location.href='../controller/view.do?boardId=${row.boardId}'">
                            <c:choose>
                                <c:when test="${ not empty row.imgOfilename }">
                                    <c:if test="${ fn:endsWith(row.imgOfilename, '.jpg') or fn:endsWith(row.imgOfilename, '.png') or fn:endsWith(row.imgOfilename, '.jpeg') or fn:endsWith(row.imgOfilename, '.gif') }">
                                        <img src="../Uploads/${ row.imgSfilename }" alt="첨부 이미지" />
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <img src="../images/noimage.png" alt="이미지 없음" />
                                </c:otherwise>
                            </c:choose>
                            <div class="card-content">
                                <div class="card-title">${ row.title }</div>
                                <div class="card-body">${ fn:substring(row.content, 0, 80) }...</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- 🏷 해시태그 패널 -->
        <div class="hashtag-panel">
            <div class="hashtag-group">
                <h3>📍 지역</h3>
                <c:forEach var="loc" items="${locationList}">
                    <a href="list.do?searchField=location_name&searchWord=${loc}" class="hashtag location">#${loc}</a>
                </c:forEach>
            </div>

            <div class="hashtag-group">
                <h3>🎨 테마</h3>
                <c:forEach var="tag" items="${hashtagList}">
                    <a href="list.do?searchField=hashtag_name&searchWord=${tag}" class="hashtag theme">#${tag}</a>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- 🚀 하단 메뉴 -->
    <div class="bottom-menu">
        <div>${ map.pagingImg }</div>
        <button type="button" onclick="location.href='write.do';">글쓰기 ✏️</button>
    </div>

</body>
</html>
