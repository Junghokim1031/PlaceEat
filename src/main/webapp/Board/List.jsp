<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>PlaceEat! 게시판</title>
    
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/List.css">
    
    <!-- List.js - External JavaScript -->
    <script src="${pageContext.request.contextPath}/Resources/Script/List.js"></script>
    
    <script>
        console.log('List.JSP 시작');
    </script>
</head>

<body class="container-fluid p-0 m-0">
    <jsp:include page="/Resources/Header.jsp" />
    
    
    <!-- 검색창 (상단) -->
    <div>
        <div class="row justify-content-center align-items-center g-2 p-3">
            <div class="col-auto">
                <select name="searchField" class="form-select">
                    <option value="title" ${param.searchField eq 'title' ? 'selected' : ''}>제목</option>
                    <option value="content" ${param.searchField eq 'content' ? 'selected' : ''}>내용</option>
                </select>
            </div>
            <div class="col-auto">
                <input type="text" name="searchWord" class="form-control" placeholder="검색어 입력" 
                       value="${param.searchWord}" form="searchForm">
            </div>
            <div class="col-auto">
                <button type="submit" class="btn" form="searchForm">검색하기</button>
            </div>
        </div>
    </div>
    
    <div class="row px-3">
        <!-- 좌측: 카드 리스트 -->
        <div id="list" class="col-12 col-lg-8 mt-3">
            <div class="row g-5">
                <c:forEach items="${boardLists}" var="row">
                    <div class="col-12 col-sm-6 col-lg-4">
                        <div class="card h-100 w-auto">
                            <img src="${pageContext.request.contextPath}/Uploads/${row.imgSfilename}"
                                 class="card-img-top" alt="${row.title}">
                            <div class="card-body">
                                <h5 class="card-title">${row.title}</h5>
                                <p class="card-text text-muted text-truncate">${row.content}</p>
                                <p class="card-text">
                                    <small class="text-muted">작성자: ${row.userId}</small><br>
                                    <small class="text-muted">조회수: ${row.viewCount}</small><br>
                                    <small class="text-muted">작성일: ${row.createdAt}</small>
                                </p>
                                <a href="${pageContext.request.contextPath}/Board/View.do?boardId=${row.boardId}" 
                                   class="stretched-link"></a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <br>
            
            <!-- Pagination -->
            <div align="center">
                ${ map.pagingImg }
            </div>
            <br>
            
           
        </div>
        
        <!-- 우측: 검색/필터 -->
        <div class="col-12 col-lg-4 border p-3 mt-3">
            <form id="searchForm" method="get" action="${pageContext.request.contextPath}/Board/List.do">
                
                <!-- Hidden inputs container -->
                <div id="hiddenHost"></div>
                
               <!-- 글쓰기 버튼 (데스크톱에서만 표시) -->
               <c:if test='${grade eq "R"}'>
               		 <!-- 글쓰기 버튼 (모바일에서 보이도록) -->
		            <div class="d-lg-none text-center mb-3">
		                <a href="${pageContext.request.contextPath}/Board/Write.do" class="btn w-100" role="button">
		                    글쓰기 ✏️
		                </a>
		            </div>
		            <a href="${pageContext.request.contextPath}/Board/Write.do" 
		               class="w-100 my-3 btn d-none d-lg-block" role="button">
		                글쓰기 ✏️
		            </a>
                </c:if>
                <!-- 텍스트 검색 조건 -->
                <div class="mb-3">
                    <label class="form-label">검색 조건</label>
                    <div class="d-flex gap-2">
                        <select name="searchField" class="form-select w-25">
                            <option value="title" ${param.searchField eq 'title' ? 'selected' : ''}>제목</option>
                            <option value="content" ${param.searchField eq 'content' ? 'selected' : ''}>내용</option>
                        </select>
                        <input type="text" name="searchWord" class="form-control" 
                               placeholder="검색어 입력" value="${param.searchWord}">
                    </div>
                </div>
                
                <!-- 지역: 단일 선택 -->
                <div id="locationTags">
                    <div class="search-box d-flex flex-wrap justify-content-center gap-2 p-1">
                        <div class="w-100"><b>지역</b></div>
                        
                        <!-- 전체 button -->
                        <div>
                            <button type="button"
                                    class="tag locationTag btn btn-outline-secondary w-100"
                                    name="locationName"
                                    value="">
                                전체
                            </button>
                        </div>
                        
                        <c:forEach items="${locationName}" var="location">
                            <div>
                                <button type="button"
                                        class="tag locationTag btn btn-outline-secondary w-100"
                                        name="locationName"
                                        value="${location}">
                                    ${location}
                                </button>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- 해시태그: 다중 선택 -->
                <div id="hashtagTags">
                    <div class="search-box d-flex flex-wrap justify-content-center gap-2 p-1">
                        <div class="w-100"><b>해시태그</b></div>
                        <c:forEach items="${hashtagName}" var="hashtag">
                            <div>
                                <button type="button"
                                        class="tag hashtagTag btn btn-outline-secondary w-100"
                                        name="hashtagName"
                                        value="${hashtag}">
                                    ${hashtag}
                                </button>
                            </div>
                        </c:forEach>
                    </div>
                </div>
             <!-- 검색 버튼 -->
                <button type="submit" class="btn w-100 my-3">검색하기</button>
            </form>
            
            
            
        </div>
    </div>
    
    <!-- Initialize List Page - Bridge JSP data to JavaScript -->
    <script>
        // Prepare preselect data from JSTL for JavaScript
        var listPageConfig = {
            locationName: "<c:out value='${param.locationName}'/>",
            hashtags: []
        };

        // Build hashtags array from JSTL
        <c:choose>
            <c:when test="${not empty paramValues.hashtagName}">
                listPageConfig.hashtags = [<c:forEach items="${paramValues.hashtagName}" var="h" varStatus="s">'<c:out value="${h}"/>'${!s.last ? ',' : ''}</c:forEach>];
            </c:when>
            <c:when test="${not empty param.hashtagName}">
                (function() {
                    var raw = "<c:out value='${param.hashtagName}'/>";
                    listPageConfig.hashtags = raw.split(',').map(function(x) { return x.trim(); }).filter(Boolean);
                })();
            </c:when>
        </c:choose>

        // Initialize the list page when DOM is ready
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof initializeListPage === 'function') {
                initializeListPage(listPageConfig);
                console.log("List.jsp initialized with config:", listPageConfig);
            } else {
                console.error("initializeListPage function not found in List.js");
            }
        });
    </script>
    
    <jsp:include page="/Resources/Footer.jsp" />
</body>
</html>
