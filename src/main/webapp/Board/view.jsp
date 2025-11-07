<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>PLACE EAT - 게시글 상세보기</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            margin: 40px auto;
            width: 80%;
        }
        .centered-img {
            display: block;
            margin: 20px auto;
            max-width: 70%;
            height: auto;
            border-radius: 8px;
        }
        #content {
            padding: 15px;
            background-color: #fafafa;
            border-radius: 5px;
        }
        .info-box {
            background-color: #f4f4f4;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        #shortCut{
        	margin: auto;
            width:80%;
            align:center;
            text-align: center;
            font-size: 2rem;
            fontweight: bolder;
            margin-bottom:20px;
        }
        
        #staticMap{
			display:block;
			align:center;
		    border:2px solid black;
            margin-top:10px;
            width:100% auto;
            height:400px;
        }
        
    </style>
</head>
<body>

    <h2 class="text-center mb-4">📍 추천 여행지 상세보기</h2>

    <!-- 게시글 데이터 확인 -->
    
    <c:if test="${empty board or board.boardId eq 0}">
        <div class="alert alert-warning text-center">
            해당 게시글을 찾을 수 없습니다.
        </div>
    </c:if>

    <!-- 게시글 데이터 있을 때 -->
    <c:if test="${not empty board and board.boardId ne 0}">
        
        <!-- 제목 -->
        <div class="info-box text-center">
            <h1>${board.title}</h1>
            <p class="text-muted mb-0">
                작성자: ${board.userId} | 작성일: ${board.createdAt} | 조회수: ${board.viewCount}
            </p>
        </div>

		<table id="shortCut" border="1">
		<tr>
			<td><a href="#title" class="text-dark text-decoration-none"> 사진 보기</a></td>
			<td><a href="#staticMap" class="me-3 text-dark text-decoration-none">지도 보기</a></td>
			<td><a href="#content" class="me-3 text-dark text-decoration-none">상세정보</a></td>
			<td><a href="#replyTable" class="me-3 text-dark text-decoration-none">댓글 보기</a></td>
		</tr>
		</table>


        <div>
        <!-- 이미지 -->
	        <c:choose>
	            <c:when test="${not empty board.imgSfilename}">
	                <img src="${pageContext.request.contextPath}/Resources/Img/${board.imgSfilename}" 
	                     alt="${board.title}" class="centered-img">
	            </c:when>
	            <c:otherwise>
	                <div class="text-center text-muted mb-3">등록된 이미지가 없습니다.</div>
	            </c:otherwise>
	        </c:choose>
        </div>

        <!-- 내용 출력 -->
        <div id="content">
            <h4>📖 상세 정보</h4>
            <p>${board.content}</p>
        </div>
        
		<!-- 지도 출력 -->
		<table id="shortCut" border="1">
		<tr id="staticMap">
			
			<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<APP_KEY_HERE>"></script>
			<script>
			// 이미지 지도에서 마커가 표시될 위치입니다 
			var markerPosition  = new kakao.maps.LatLng(${board.latitude}, ${board.longitude}); 
			
			// 이미지 지도에 표시할 마커입니다
			// 이미지 지도에 표시할 마커는 Object 형태입니다
			var marker = {
			    position: markerPosition
			};
			
			var staticMapContainer  = document.getElementById('staticMap'), // 이미지 지도를 표시할 div  
			    staticMapOption = { 
			        center: new kakao.maps.LatLng(${board.latitude}, ${board.longitude}), // 이미지 지도의 중심좌표
			        level: 3, // 이미지 지도의 확대 레벨
			        marker: marker // 이미지 지도에 표시할 마커 
			    };    
			
			// 이미지 지도를 생성합니다
			var staticMap = new kakao.maps.StaticMap(staticMapContainer, staticMapOption);
			</script>
		</tr>
		<tr>
		    <td>
                <br>
            </td>
		</tr>
		</table>
		
		<!-- 지도 밑 상세정보 출력 -->
        <div class="info-box mt-4">
            <h4>🗺️ 위치 정보</h4>
            <p><b>위치명:</b> ${board.locationName}</p>
            <p><b>위도:</b> ${board.latitude}</p>
            <p><b>경도:</b> ${board.longitude}</p>
        </div>
        
        <!-- 좋아요 -->        
        <div class="text-center mb-5">
		    <button id="likeBtn" type="button" class="btn btn-outline-danger"
		        data-user-id="${sessionScope.userId}" data-board="${board.boardId}" 
		        data-liked="${board.liked}">
		        ❤️ 좋아요 <span id="likeCount">${likeCount}</span>
		    </button>
		</div>
		
			
		<!--  좋아요 버튼 & AJAX 처리 JavaScript -->
    	<script>
	        document.getElementById('likeBtn').addEventListener('click', function() {
	            var boardId = this.getAttribute('data-board');
	            var userId = this.getAttribute('data-user-id');
	            var liked = this.getAttribute('data-liked') === 'true';  // 좋아요 여부
	
	            var actionUrl = liked ? 'deleteLike.do' : 'insertLike.do'; // 좋아요 취소 (delete) or 좋아요 (insert)
	            
	            // AJAX 요청 보내기
	            var xhr = new XMLHttpRequest();
	            xhr.open('POST', actionUrl, true);
	            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	            xhr.onreadystatechange = function() {
	                if (xhr.readyState == 4 && xhr.status == 200) {
	                    var response = JSON.parse(xhr.responseText);
	                    
	                    if (response.success) {
	                        // 좋아요가 성공적으로 등록/취소된 경우
	                        var likeCount = document.getElementById('likeCount');
	                        var newLikeCount = response.newLikeCount;
	                        likeCount.innerText = newLikeCount;
	
	                        // 좋아요 상태 토글
	                        document.getElementById('likeBtn').setAttribute('data-liked', !liked);
	                        document.getElementById('likeBtn').classList.toggle('btn-danger');
	                        document.getElementById('likeBtn').classList.toggle('btn-outline-danger');
	                    } else {
	                        alert('좋아요 처리 중 오류가 발생했습니다.');
	                    }
	                }
	            };
	            
	            xhr.send('boardId=' + boardId + '&userId=' + userId);
	        });
   		</script>			  

        <!-- 해시태그 -->
        <c:if test="${not empty board.hashtagName}">
            <div class="info-box">
                <h4>🏷️ 해시태그</h4>
                <p>${board.hashtagName}</p>
            </div>
        </c:if>

        <!-- 상세 설명 -->
        <c:if test="${not empty board.details}">
            <div class="info-box">
                <h4>📌 상세 설명</h4>
                <p>${board.details}</p>
            </div>
        </c:if>
        
       
        <!-- 목록으로 돌아가기 버튼 -->
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/controller/list.do" class="btn btn-secondary">
                목록으로 돌아가기
            </a>
        </div>

    </c:if>

</body>
</html>