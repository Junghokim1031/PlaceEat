<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>

<!-- ================================================================================================================== -->
<!--	                                       전체 개요
		 - request.setAttribute("dto", dto)로 ViewController.java에서 전달받음 
		 - request.setAttribute("restaurantTable", restaurantTable)로 ViewController.java에서 전달받음 
		 - request.setAttribute("commentTable", commentTable);로 ViewController.java에서 전달받음
		 - 댓글 작성 정보는 어디로 보내면 될까요?
		 ** - src="//dapi.kakao.com/v2/maps/sdk.js?appkey=에 본인의 카카오 지도 API 키를 입력하세요."  **
		 
		 
                                                게시글 
		 - dto 1개에서 다음과 같은 내용을 활용함 (총 12개)
		 		- userId, createdAt, viewCount, title, content, 
		 		- imgOFileName, imgSFileName, details, latitude, longitude, 
		 		- hashtagName, locationName 
		 		
                                                 맛집 
		 - restaurantTable 전체에서 다음과 같은 내용을 활용함 (총 2개)
		 		- restName, address
		 		
                                                댓글목록 
		 - commentTable 전체에서 다음과 같은 내용을 활용함 (총 3개)
		 		- userId, createdAt, content
												 댓글작성 
		 - 무엇을 어디로 전달해야 할까요? -->
<!-- ================================================================================================================== -->	

<html>
<head>
	<meta charset="UTF-8">
	<title>PLACE EAT 게시판</title>
	
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
	
	
	<style>
		body {
            font-family: 'Noto Sans KR', sans-serif;
            margin: 20px;
        }
		html { scroll-behavior: smooth; }

        
        #shortCut{
        	margin: auto;
            width:80%;
            align:center;
            text-align: center;
            font-size: 2rem;
            fontweight: bolder;
            margin-bottom:20px;
        }
        
        .centered-img {
			max-width: 75%;
			max-height: 50vh;
			height: auto;
			object-fit: contain;
		}
		
		#main-content{
            padding:10px;
            height: auto;
        }
		
		#staticMap{
			display:block;
			align:center;
		    border:2px solid black;
            margin-top:10px;
            width:100% auto;
            height:400px;
        }
        
        #detail{
        	padding-left:10px;
        }
        
        textarea{
        	width: 100%;
        	resize: none;
        }
	</style>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		console.log("View.jsp 로드 완료");
	</script>
</head>
<body>
	<!-- 페이지에 문제 없는지 확인 -->
<%
	Map<String,Object> dto = new HashMap<>();
	dto.put("boardId", 1);
	dto.put("createdAt", "2025-10-31");
	dto.put("updatedAt", "2025-11-01");
	dto.put("title", "맛집 리뷰: 김밥천국");
	dto.put("viewCount", 12); // or remove if you only use visitcount
	dto.put("content", "바쁜 점심시간에 방문했던 김밥천국에서 주문한 김밥과 라면 세트는 가격 대비 만족도가 매우 높았습니다. 따끈하고 감칠맛이 도는 육수에 쫄깃한 면발이 잘 어울렸고, 김밥은 밥의 간이 과하지 않으면서 속재료가 신선해 한 입마다 균형 있는 풍미가 느껴졌습니다. 단무지의 산뜻함과 참기름 향이 뒷맛을 정리해 주어 부담 없이 계속 손이 갔습니다. 매장 회전율이 빨라 대기 시간이 짧았고 직원 응대도 친절했습니다. 포장 옵션이 다양하고 늦은 시간에도 안정적인 품질을 유지하는 점이 인상적이었습니다. 주변 직장인에게 추천할 만한 합리적인 선택으로, 재방문 의사가 충분합니다. 좌석 간격은 다소 좁지만 회전이 빨라 큰 불편은 없었습니다.");
	dto.put("imgOFileName", "1.jpg");
	dto.put("imgSFileName", "1.jpg");
	dto.put("details", Arrays.asList("위치: 서울 강남구 역삼동 123-45", "운영시간: 매일 10:00 - 22:00", "추천메뉴: 김밥, 라면, 떡볶이", "가격대: 3,000원 ~ 8,000원"));
	dto.put("latitude", 37.4999); // 역삼동 근처
	dto.put("longitude", 127.0365); // 역삼동 근처
	dto.put("userId", "hkd");
	dto.put("hashtagName", Arrays.asList("김밥맛집","가성비","점심추천"));
	dto.put("locationName", "서울 강남구 역삼동");
	
	request.setAttribute("dto", dto);
	
	List<Map<String, String>> restaurantTable = new ArrayList<>();
	
	Map<String, String> restaurant1 = new HashMap<>();
	restaurant1.put("restName", "맛있는 김밥천국");
	restaurant1.put("address", "http://map.example.com/restaurant1");
	restaurantTable.add(restaurant1);
	
	Map<String, String> restaurant2 = new HashMap<>();
	restaurant2.put("restName", "역삼동 분식집");
	restaurant2.put("address", "http://map.example.com/restaurant2");
	restaurantTable.add(restaurant2);
	
	Map<String, String> restaurant3 = new HashMap<>();
	restaurant3.put("restName", "분식의 달인");
	restaurant3.put("address", "http://map.example.com/restaurant3");
	restaurantTable.add(restaurant3);
	
	Map<String, String> restaurant4 = new HashMap<>();
	restaurant4.put("restName", "한남동 국밥집");
	restaurant4.put("address", "http://map.example.com/restaurant4");
	restaurantTable.add(restaurant4);

	Map<String, String> restaurant5 = new HashMap<>();
	restaurant5.put("restName", "청담동 초밥수");
	restaurant5.put("address", "http://map.example.com/restaurant5");
	restaurantTable.add(restaurant5);

	Map<String, String> restaurant6 = new HashMap<>();
	restaurant6.put("restName", "을지로 골뱅이집");
	restaurant6.put("address", "http://map.example.com/restaurant6");
	restaurantTable.add(restaurant6);

	Map<String, String> restaurant7 = new HashMap<>();
	restaurant7.put("restName", "홍대 닭칼국수");
	restaurant7.put("address", "http://map.example.com/restaurant7");
	restaurantTable.add(restaurant7);

	Map<String, String> restaurant8 = new HashMap<>();
	restaurant8.put("restName", "서촌 쌈밥정식");
	restaurant8.put("address", "http://map.example.com/restaurant8");
	restaurantTable.add(restaurant8);

	// Keep attribute updated for the JSP
	request.setAttribute("restaurantTable", restaurantTable);

	
	List<Map<String, String>> commentTable = new ArrayList<>();
	Map<String, String> comment1 = new HashMap<>();
	comment1.put("userId", "user123");
	comment1.put("createdAt", "2025-11-01 10:15");
	comment1.put("content", "저도 이곳 자주 가는데 정말 맛있죠!");
	commentTable.add(comment1);
	
	Map<String, String> comment2 = new HashMap<>();
	comment2.put("userId", "foodie456");
	comment2.put("createdAt", "2025-11-01 11:20");
	comment2.put("content", "김밥천국 라면은 언제 먹어도 최고에요!");
	commentTable.add(comment2);
	
	request.setAttribute("commentTable", commentTable);
%>


	<h2>추천 여행지</h2>
	
	<!-- ================================================================================================================== -->
	<!--                                            게시글 
		 - 추천 여행지에 대한 글
		 - dto의 다음과 같은 내용을 활용함 (총 12개)
		 		- userId, createdAt, viewCount, title, content, 
		 		- imgOFileName, imgSFileName, details, latitude, longitude, 
		 		- hashtagName, locationName 
		 - request.setAttribute("dto", dto)로 ViewController.java에서 전달받음 -->
	<!-- ================================================================================================================== -->
	<!-- 제목  & 작성자, 작성일, 및 조회수 -->
	<table id="title" border="1" class="w-100 mb-1">
		<tr>
            <td align="center" height="80px"  bgcolor="#CCCCCC">
                <h1> <b> ${dto.title} </b> </h1>
            </td>
        </tr>
	</table>
	<table class="w-100 mt-0 mb-4">
		<tr>
		    <td class="text-center pe-2">
            	<b>작성자: </b> ${dto.userId}
            </td>
			<td class="text-center pe-2">
            	<b>작성일: </b> ${dto.createdAt}
            </td>
		    <td class="text-center pe-2">
            	<b>조회수: </b> ${dto.viewCount}
            </td>
		</tr>
	</table>
	
	<!-- Figma에 따라 단축키 작성 -->
	<table id="shortCut" border="1">
		<tr>
			<td><a href="#title" class="text-dark text-decoration-none"> 사진 보기</a></td>
			<td><a href="#staticMap" class="me-3 text-dark text-decoration-none">지도 보기</a></td>
			<td><a href="#content" class="me-3 text-dark text-decoration-none">상세정보</a></td>
			<td><a href="#replyTable" class="me-3 text-dark text-decoration-none">댓글 보기</a></td>
		</tr>
	</table>
	
	<!-- 이미지 출력 -->
	<c:if test="${not empty dto.imgOFileName}">
		<img src="${pageContext.request.contextPath}/Resources/Img/${dto.imgSFileName}" class="centered-img my-3 mx-auto d-block"/>
	</c:if>
	
	<!-- 내용 출력 -->
	<table id="content" border="1" width="90%" align="center">
		<!-- 게시글 -->
		<tr>
		    <td colspan="4" align="center" bgcolor="#CCCCCC">
                <h3>상세정보</h3>
            </td>
		</tr>
		<tr>
			<td id="main-content">
		    	${dto.content}
		    </td>
		</tr>
	
	<!-- 지도 출력 -->
		<tr id="staticMap">
			
			<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey="></script>
			<script>
			// 이미지 지도에서 마커가 표시될 위치입니다 
			var markerPosition  = new kakao.maps.LatLng(${dto.latitude}, ${dto.longitude}); 
			
			// 이미지 지도에 표시할 마커입니다
			// 이미지 지도에 표시할 마커는 Object 형태입니다
			var marker = {
			    position: markerPosition
			};
			
			var staticMapContainer  = document.getElementById('staticMap'), // 이미지 지도를 표시할 div  
			    staticMapOption = { 
			        center: new kakao.maps.LatLng(${dto.latitude}, ${dto.longitude}), // 이미지 지도의 중심좌표
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
	<!-- 지도 밑 상세정보 출력 -->
		<c:forEach  items="${dto.details}" var="detail">
			<tr>
            	<td id="detail">
					<b>${detail}</b><br>
				</td>
			</tr>
		</c:forEach>
		
	<!-- 위치 와 해쉬태그 출력 -->
		<tr>
            <td id="detail">
                <b>위치: </b> ${dto.locationName} <br>
                <b>해시태그: </b> 
                <c:forEach items="${dto.hashtagName}" var="tag" varStatus="status">
                    #${tag}
                    <c:if test="${!status.last}">, </c:if>
                </c:forEach>
            </td>
        </tr>
        <tr>
        	<td align="center">
				<button id="like" type="button"
			        data-user-id="${sessionScope.userId}"
			        data-board="${dto.boardId}">
				  좋아요
				</button>
				<!-- ChatGPT 작성 변경이 필요함 -->
				<script>
				$(function() {
					$(document).on("click", "#like", function (e) {
						e.preventDefault();
						const $btn = $(this);
						const userId = $btn.data("userId");
						const boardId = $btn.data("board");
						if (!userId) { alert("로그인이 필요합니다."); return; }
						const base = "<%= request.getContextPath() %>";
						$.ajax({
							type: "POST",
							url: base + "/like",
							data: { userId: userId, boardId: boardId, action: "like" },
							success: function (res) {
								$btn.toggleClass("btn-primary text-white");
							},
							error: function (xhr) {
								console.error(xhr.responseText);
								alert("좋아요 처리 중 오류가 발생했습니다.");
							}
						});
					});
				});
				</script>
			</td>
		</tr>
	</table>
	<br>
	
	<!-- 게시글 끝 ==================================================================================================== -->
	
	<!-- ================================================================================================================== -->
	<!--                                            맛집 
		 - 추천 여행지관련 맛집 정보
		 - restaurantTable의 다음과 같은 내용을 활용함 (총 2개)
		 		- restName, address
		 - request.setAttribute("restaurantTable", restaurantTable)로 ViewController.java에서 전달받음 -->
	<!-- ================================================================================================================== -->
	<div border="1" width="90%" align="center" bgcolor="#CCCCCC">
                <h3>근처 맛집</h3>
	</div>
	<div class="row">
		<c:forEach items="${ restaurantTable }" var="restaurant">
		    <div class="col-sm-3" align="center">
		    	<a href="${restaurant.address}" class="text-dark text-decoration-none">${restaurant.restName}</a>
		    </div>
		</c:forEach>
	</div>
	<br>
	<br>
	
	<!-- 맛집 끝 ==================================================================================================== -->
	
		
	<!-- ================================================================================================================== -->
	<!--                                            댓글목록 
		 - 댓글 목록
		 - commentTable의 다음과 같은 내용을 활용함 (총 3개)
		 		- userId, createdAt, content
		 - request.setAttribute("commentTable", commentTable);로 ViewController.java에서 전달받음 -->
	<!-- ================================================================================================================== -->
	<table id="replyTable" border="1" width="90%" align="center">
		<tr>
		    <td colspan="3" align="center" bgcolor="#CCCCCC">
                <h3>댓글</h3>
            </td>
		</tr>
	</table>

	<table style="width:90%; margin:0 auto; border-collapse:collapse;" border="1">
		<c:forEach items="${commentTable}" var="comment">
			<tr>
				<td>
					<b>${comment.userId}</b> | ${comment.createdAt}<br>
					${comment.content}
					<hr>
				</td>
			</tr>
		</c:forEach>
		<!-- 댓글 페이지 처리 Board에서 복사함 -->
		<tr>
			<td align="center" style="padding:8px;">
				<!-- ViewController에서 작성한 것으로 이름 변경 필요 -->
				${map.pagingImg}
			</td>
		</tr>
	</table>

	<!-- 댓글 끝  ==================================================================================================== -->
	
	
	<!-- ================================================================================================================== -->
	<!--                                            댓글작성 
		 - 무엇을 어디로 전달해야 할까요? -->
	<!-- ================================================================================================================== -->
	<div style="width:90%; margin:12px auto 0;">
		<textarea id="replyContent" rows="4"></textarea><br />
		<button id="addReplyBtn" type="button" style="float:right;">댓글등록</button>
	</div>
	<script>
		// 댓글 등록 버튼 클릭 이벤트 핸들러
		const myButton = document.getElementById("addReplyBtn");
		myButton.addEventListener("click", function() {
			alert("댓글 등록 기능은 현재 구현 중입니다.");
		});
	</script>
	<!-- 댓글작성 끝 ==================================================================================================== -->
	
</body>
</html>