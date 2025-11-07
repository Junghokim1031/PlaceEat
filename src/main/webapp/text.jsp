<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ page import="java.util.*" %>
<!DOCTYPE html>

<!-- ==================================================================================================================
                                           전체 개요 (List.jsp)
            - 검색 클릭 시 넘어가는 정보를 받는 방법
				// Multi-select hashtags
				String[] hashtags = req.getParameterValues("hashtag"); // may be null if none selected
				List<String> hashtagList = hashtags != null ? Arrays.asList(hashtags) : Collections.emptyList();
				
				// Single-select location
				String location = req.getParameter("locationTagParam"); // null if none selected
				
				// Optional: search text inputs
				String searchField = req.getParameter("searchField");   // "title" or "content"
				String searchWord  = req.getParameter("searchWord");    // user text
                                           
	        - 받기 원하는 형식: request attribute
            request.setAttribute("boardLists", boardLists);
            req.setAttribute("locationLists", locationLists);
			req.setAttribute("hashtagLists", hashtagLists);
			req.getRequestDispatcher("/WEB-INF/views/List.jsp").forward(req, resp);
			
			 - boardLists 6개에서 다음과 같은 내용을 활용함 (총 7개)
					 		- boardId, title, imgSFileName, content, userId, viewCount, createdAt
			 - locationLists에서 다음과 같은 내용을 활용함
							- locationName	 
			 - hashtagLists에서 다음과 같은 내용을 활용함
							- hashtagName (#포함한 이름)
  ================================================================================================================== -->


<%
	// ========================================
	// 더미 데이터임. (시험용)
	// ========================================
	List<Map<String,Object>> boardLists = new ArrayList<>();
	
	// Board 1
	Map<String,Object> board1 = new HashMap<>();
	board1.put("boardId", 1);
	board1.put("title", "맛집 리뷰: 김밥천국");
	board1.put("imgSFileName", "1.jpg");
	board1.put("content", "바쁜 점심시간에 방문했던 김밥천국에서 주문한 김밥과 라면 세트는 가격 대비 만족도가 매우 높았습니다. 따끈하고 감칠맛이 도는 육수에 쫄깃한 면발이 잘 어울렸고, 김밥은 밥의 간이 과하지 않으면서 속재료가 신선해 한 입마다 균형 있는 풍미가 느껴졌습니다.");
	board1.put("userId", "홍길동");
	board1.put("viewCount", 12);
	board1.put("createdAt", "2025-10-31");
	boardLists.add(board1);
	
	// Board 2
	Map<String,Object> board2 = new HashMap<>();
	board2.put("boardId", 2);
	board2.put("title", "카페 추천: 블루보틀");
	board2.put("imgSFileName", "2.jpg");
	board2.put("content", "이번에 들른 블루보틀 매장은 넓은 통창으로 자연광이 부드럽게 들어와 여유로운 분위기를 만들어 주었습니다. 라떼는 우유의 고소함과 에스프레소의 산미가 균형을 이루며 깔끔하게 떨어졌고, 미세한 폼 텍스처가 입안을 부드럽게 감싸주었습니다.");
	board2.put("userId", "김영희");
	board2.put("viewCount", 34);
	board2.put("createdAt", "2025-10-30");
	boardLists.add(board2);
	
	// Board 3
	Map<String,Object> board3 = new HashMap<>();
	board3.put("boardId", 3);
	board3.put("title", "강남 파스타 집");
	board3.put("imgSFileName", "3.jpg");
	board3.put("content", "점심 특선으로 주문한 알리오 올리오는 마늘의 향을 과하지 않게 살리면서 올리브 오일의 고소함을 충분히 담아낸 스타일이었습니다. 면은 알 덴테로 삶아져 식감이 살아 있었고, 페퍼론치노의 매콤함이 뒷부분에서 산뜻하게 치고 올라와 물리지 않았습니다.");
	board3.put("userId", "이철수");
	board3.put("viewCount", 27);
	board3.put("createdAt", "2025-10-28");
	boardLists.add(board3);
	
	// Board 4
	Map<String,Object> board4 = new HashMap<>();
	board4.put("boardId", 4);
	board4.put("title", "제주 흑돼지 맛집");
	board4.put("imgSFileName", "4.jpg");
	board4.put("content", "제주 흑돼지 전문점의 가장 큰 장점은 탄탄한 기본기였습니다. 숯의 온도를 일정하게 유지해 겉은 바삭하고 속은 육즙이 가득하도록 구워 주었고, 고기의 결이 부드러워 씹을수록 감칠맛이 배어나왔습니다.");
	board4.put("userId", "박민수");
	board4.put("viewCount", 51);
	board4.put("createdAt", "2025-10-25");
	boardLists.add(board4);
	
	// Board 5
	Map<String,Object> board5 = new HashMap<>();
	board5.put("boardId", 5);
	board5.put("title", "부산 밀면 투어");
	board5.put("imgSFileName", "5.jpg");
	board5.put("content", "부산 도심과 원도심을 오가며 세 곳의 밀면집을 비교 시식했습니다. 첫 번째 매장은 육수의 동치미 베이스가 청량해 한입 들어가자마자 갈증이 풀리는 느낌이었고, 면발은 탄성이 좋지만 금방 퍼지지 않아 끝까지 식감이 유지되었습니다.");
	board5.put("userId", "최수지");
	board5.put("viewCount", 19);
	board5.put("createdAt", "2025-10-24");
	boardLists.add(board5);
	
	// Board 6
	Map<String,Object> board6 = new HashMap<>();
	board6.put("boardId", 6);
	board6.put("title", "비건 레스토랑");
	board6.put("imgSFileName", "6.jpg");
	board6.put("content", "도심의 비건 레스토랑에서 코스 형태로 식사를 했습니다. 스타터로 나온 시즌 샐러드는 제철 채소의 식감이 살아 있었고, 오일 드레싱에 견과류 향을 더해 담백하면서도 고소했습니다.");
	board6.put("userId", "장서윤");
	board6.put("viewCount", 42);
	board6.put("createdAt", "2025-10-22");
	boardLists.add(board6);
	
	// Set as request attribute for EL access
	request.setAttribute("boardLists", boardLists);
	
	// ========================================
	// locationLists 및 hashtagLists
	// ========================================
	List<Map<String,Object>> locationLists = new ArrayList<>();
	String[] locations = {
	  "서울특별시","부산광역시","대구광역시","인천광역시","광주광역시","대전광역시","울산광역시","세종특별자치시",
	  "경기도","강원특별자치도","충청북도","충청남도","전라북도","전라남도","경상북도","경상남도","제주특별자치도"
	};
	for (String name : locations) {
	  Map<String,Object> m = new HashMap<>();
	  m.put("locationName", name);
	  locationLists.add(m);
	}
	request.setAttribute("locationLists", locationLists);
	
	List<Map<String,Object>> hashtagLists = new ArrayList<>();
	String[] hashtags = {"#한식","#브런치","#디저트","#치킨","#회","#파스타","#비건","#카페","#가성비","#분위기좋은"};
	for (String tag : hashtags) {
	  Map<String,Object> m = new HashMap<>();
	  m.put("hashtagName", tag);
	  hashtagLists.add(m);
	}
	request.setAttribute("hashtagLists", hashtagLists);
%>


<html>
<head>
	<meta charset="UTF-8">
	<title>PlaceEat! 게시판</title>

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
		integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

	<style>
		/* 카드 이미지 공통 스타일 */
		img.card-img-top {
			object-fit: cover;
			width: 100%;
			height: 200px;
		}
		
		/* 검색 박스 스타일 */
		.search-box {
			width: 100%;
			margin-top: 20px;
			padding: 5px;
			border: 1px solid #ddd;
			border-radius: 5px;
			background-color: #91d7f2;
		}
		
		.card-text{
            overflow: hidden; 
            text-overflow: ellipsis;
        }

		/* 태그 버튼 활성화 시 반전(회색 배경 + 흰 글씨) */
		.tag.btn.btn-outline-secondary.active {
			color: #fff;
			background-color: #385da6;
			border-color: #fff;
		}
		
		#list{
			background-color:#f8f9fa; 
			padding:20px; 
			margin-top:50px;
		}
	</style>
	<script>
		console.log('List.JSP 시작');
	</script>
</head>

<body class="container py-3">

	<!-- ================================================================================================================== -->
	<!--                                            게시판 (카드 목록)  
		 - 검색/필터 영역과 카드 리스트를 8:4 컬럼으로 구성
		 - 좌측: 카드 리스트
		 - 우측: 검색/필터 + 태그(지역 단일선택, 해시태그 다중선택)                                                         -->
	<!-- ================================================================================================================== -->
	<div class="row">
		<!-- 좌측: 카드 리스트 -->
		<div id="list" class="col-12 col-lg-8" >
			<div class="row g-3">
				<c:forEach items="${boardLists}" var="row">
					<div class="col-12 col-sm-6 col-lg-4">
						<div class="card h-100">
							<img src="${pageContext.request.contextPath}/Resources/Img/${row.imgSFileName}"
								class="card-img-top" alt="${row.title}">
							<div class="card-body">
								<h5 class="card-title">${row.title}</h5>
								<p class="card-text text-muted text-truncate">${row.content}</p>
								<p class="card-text">
                                    <small class="text-muted">작성자: ${row.userId}</small>
                                    <small class="text-muted">조회수: ${row.viewCount}</small><br>
                                    <small class="text-muted">작성일: ${row.createdAt}</small>
								</p>
								<a href="../mvcboard/view.do?idx=${row.boardId}" class="stretched-link" aria-label="${row.title}"></a>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
			<div align="center">
				${ map.pagingImg }
			</div>
		</div>
		
		<!-- 게시판 (카드 목록) ========================================================================================================== -->
		

		<!-- ================================================================================================================== -->
		<!--                                            검색/필터                                                            -->
		<!-- ================================================================================================================== -->
		<div class="col-12 col-lg-4" style="margin-top:50px;">
			<form id="searchForm" method="get" action="../mvcboard/list.do">
				<!--
					다중 파라미터를 전달하기 위한 hidden 입력 호스트
					- hashtag: 다중선택(동일 name 반복)
					- locationTagParam: 단일선택(1개만 유지)
				-->
				<div id="hiddenHost"></div>

				<!-- 검색 버튼 -->
				<button type="submit" class="btn btn-primary w-100 mb-3">검색하기</button>

				<!-- 텍스트 검색 조건 -->
				<div class="mb-3">
					<label class="form-label">검색 조건</label>
					<div class="d-flex gap-2">
						<select name="searchField" class="form-select">
							<option value="title">제목</option>
							<option value="content">내용</option>
						</select>
						<input type="text" name="searchWord" class="form-control" placeholder="검색어 입력">
					</div>
				</div>

				<!-- 지역: 단일 선택 -->
				<div id="locationTags" class="search-box row mx-auto">
					<div class="col-12 mb-2 fw-bold">지역</div>
					<c:forEach items="${locationLists}" var="row">
						<div class="col-4 mb-2">
							<button type="button"
								class="tag tag-location btn btn-outline-secondary w-100"
								data-name="locationTagParam"
								data-value="${row.locationName}">
								${row.locationName}
							</button>
						</div>
					</c:forEach>
				</div>

				<!-- 해시태그: 다중 선택 -->
				<div id="hashtagTags" class="search-box row mx-auto mt-3">
					<div class="col-12 mb-2 fw-bold">해시태그</div>
					<c:forEach items="${hashtagLists}" var="row">
						<div class="col-4 mb-2">
							<button type="button"
								class="tag tag-hashtag btn btn-outline-secondary w-100"
								data-name="hashtag"
								data-value="${row.hashtagName}">
								${row.hashtagName}
							</button>
						</div>
					</c:forEach>
				</div>
			</form>
		</div>
		
		<!-- 검색/필터 ========================================================================================================== -->
	</div>

	<script>
		// ------------------------------
		// 공통 유틸: hidden input 추가
		// ------------------------------
		function addHidden(host, name, value) {
			// 동일 항목 중복 방지 위해 data-key 사용
			const key = name + '::' + value;
			let input = host.querySelector('input[type="hidden"][data-key="' + CSS.escape(key) + '"]');
			if (!input) {
				input = document.createElement('input');
				input.type = 'hidden';
				input.name = name;
				input.value = value;
				input.dataset.key = key;
				host.appendChild(input);
			}
		}
	
		// 공통 유틸: hidden input 추가 끝
	
		
		// ------------------------------
		// 공통 유틸: hidden input 삭제
		// ------------------------------
		function removeHidden(host, name, value) {
			const key = name + '::' + value;
			const input = host.querySelector('input[type="hidden"][data-key="' + CSS.escape(key) + '"]');
			if (input) input.remove();
		}
		
		// 공통 유틸: hidden input 삭제 끝

		
		document.addEventListener('DOMContentLoaded', function () {
			// 폼/히든 호스트 참조
			const form = document.getElementById('searchForm');
			const host = document.getElementById('hiddenHost');

			// ------------------------------
			// 해시태그: 다중 선택 토글
			// ------------------------------
			const hashtagRoot = document.getElementById('hashtagTags');
			if (hashtagRoot) {
				hashtagRoot.addEventListener('click', function (e) {
					const btn = e.target.closest('.tag-hashtag');
					if (!btn) return;

					const name = btn.getAttribute('data-name');		// "hashtag"
					const value = btn.getAttribute('data-value') || btn.textContent.trim();

					// 다중 선택: 형제 초기화 금지, 클릭한 것만 토글
					btn.classList.toggle('active');

					if (btn.classList.contains('active')) {
						addHidden(host, name, value);
					} else {
						removeHidden(host, name, value);
					}
				});
			}
			
			// 해시태그: 다중 선택 토글 끝

			
			// ------------------------------
			// 지역: 단일 선택
			// ------------------------------
			const locationRoot = document.getElementById('locationTags');
			if (locationRoot) {
				locationRoot.addEventListener('click', function (e) {
					const btn = e.target.closest('.tag-location');
					if (!btn) return;

					const name = btn.getAttribute('data-name');		// "locationTagParam"
					const value = btn.getAttribute('data-value') || btn.textContent.trim();

					// 기존 활성 해제 + hidden 제거
					locationRoot.querySelectorAll('.tag-location.active').forEach(function (el) {
						el.classList.remove('active');
						const v = el.getAttribute('data-value') || el.textContent.trim();
						removeHidden(host, name, v);
					});

					// 현재 선택 반영
					btn.classList.add('active');
					addHidden(host, name, value);
				});
			}
			
			// 지역: 단일 선택 끝
			

			// ------------------------------
			// 최초 로딩: URL 파라미터 기반 프리셀렉트
			// - locationTagParam: 단일 문자열
			// - hashtag: 반복 파라미터(여러 개) 또는 CSV 모두 지원
			// ------------------------------
			(function preselectFromQuery() {
				// locationTagParam 미리 선택
				<c:if test="${not empty param.locationTagParam}">
					(function () {
						const locationTag = "<c:out value='${param.locationTagParam}'/>";
						const buttons = document.querySelectorAll('.tag-location');
						buttons.forEach(function (btn) {
							if ((btn.getAttribute('data-value') || btn.textContent.trim()) === locationTag) {
								btn.classList.add('active');
								addHidden(host, 'locationTagParam', locationTag);
							}
						});
					})();
				</c:if>

				// hashtag 미리 선택 (반복 파라미터/CSV 모두 허용)
				<c:choose>
					<c:when test="${not empty paramValues.hashtag}">
						(function () {
							// 반복 파라미터를 JS 배열로 출력
							const hashtags = [<c:forEach items="${paramValues.hashtag}" var="h" varStatus="s">'<c:out value="${h}"/>'${!s.last ? ',' : ''}</c:forEach>];
							const buttons = document.querySelectorAll('.tag-hashtag');
							buttons.forEach(function (btn) {
								const val = btn.getAttribute('data-value') || btn.textContent.trim();
								if (hashtags.indexOf(val) !== -1) {
									btn.classList.add('active');
									addHidden(host, 'hashtag', val);
								}
							});
						})();
					</c:when>
					<c:when test="${not empty param.hashtag}">
						(function () {
							// CSV 한 줄로 들어온 경우 분할
							const raw = "<c:out value='${param.hashtag}'/>";
							const hashtags = raw.split(',').map(function (x) { return x.trim(); }).filter(Boolean);
							const buttons = document.querySelectorAll('.tag-hashtag');
							buttons.forEach(function (btn) {
								const val = btn.getAttribute('data-value') || btn.textContent.trim();
								if (hashtags.indexOf(val) !== -1) {
									btn.classList.add('active');
									addHidden(host, 'hashtag', val);
								}
							});
						})();
					</c:when>
				</c:choose>
			})();
		});
	</script>
</body>
</html>
