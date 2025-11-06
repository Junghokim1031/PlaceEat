<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>

	<!-- ================================================================================================================== -->
<!--                                       전체 개요 (Write.JSP → write.do)
 
 
                                            백엔드에서 받을 데이터 방법 
 ■ 단일 값 필드 (getParameter 사용)
 - locationSelect (String) : String locationSelect = req.getParameter("locationSelect");
 - hashtagSelect (String)  : String hashtagSelect = req.getParameter("hashtagSelect");
 - title (String)          : String title = req.getParameter("title");
 - content (String)        : String content = req.getParameter("content");
 
 ■ 좌표 정보 (Hidden 필드 - 주소 검색 후 자동 입력됨)
 - latitude (String → double) : String latStr = req.getParameter("latitude");
                                 double latitude = Double.parseDouble(latStr);
 - longitude (String → double): String lngStr = req.getParameter("longitude");
                                 double longitude = Double.parseDouble(lngStr);
 
 ■ 파일 업로드 (Multipart - getPart 사용)
 - ofile (Part) : Part filePart = req.getPart("ofile");
                  String originalFileName = filePart.getSubmittedFileName();
                  // FileUtil.java를 이용하여 파일 저장
                  
 ■ 배열 필드 (getParameterValues 사용)
 - details[] (String[]) : String[] details = req.getParameterValues("details");
                          // 5개의 input 필드 (name="details")
                          // 빈 문자열 필터링 필요: if (!detail.trim().isEmpty())
 
 ■ 평행 배열 (동적 추가 가능 - 맛집 정보)
 - restName[] (String[])    : String[] restNames = req.getParameterValues("restName[]");
 - restAddress[] (String[]) : String[] restAddresses = req.getParameterValues("restAddress[]");
   
   
 
                                            주의사항
 - KAKAO Key 
 - addressVerified 검증: JavaScript에서 주소 검색 버튼 클릭 후 좌표가 설정되어야 제출 가능
 - 파일 크기 제한: @MultipartConfig에서 maxFileSize 설정 가능
 - details 필드: 사용자가 입력하지 않으면 빈 문자열로 전송되므로 필터링 필수
 - restName/restAddress: 사용자가 "맛집 추가" 버튼을 클릭하지 않으면 null일 수 있음 (null 체크 필수)
 - locationName/hashtagName: 현재 JSP에서 scriptlet으로 생성 중 → 추후 Controller의 doGet에서 설정 권장 (MVC 패턴)
-->
<!-- ================================================================================================================== -->

<%
	//========================================
	// 더미 데이터임. (시험용)
	// ========================================
	// 위치 
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
	request.setAttribute("locationName", locationLists);
	
	
	// 해쉬태그
	List<Map<String,Object>> hashtagLists = new ArrayList<>();
	String[] hashtags = {"#한식","#브런치","#디저트","#치킨","#회","#파스타","#비건","#카페","#가성비","#분위기좋은"};
	
	for (String tag : hashtags) {
		Map<String,Object> m = new HashMap<>();
		m.put("hashtagName", tag);
		hashtagLists.add(m);
	}
	
	request.setAttribute("hashtagName", hashtagLists);
	// 더미데이터 끝==================================================================================================================
%>

<html>
<head>
	<meta charset="UTF-8">
	<title>PLACE EAT 게시글 작성</title>
	
	
	<!-- Bootstrap 5 CSS 및 JS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" 
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" 
        crossorigin="anonymous"></script>

	<!-- Kakao API -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<APP_KEY_HERE>&libraries=services"></script>

	<style>
		<jsp:include page="../Resources/CSS/FooterCSS.jsp" />
	</style>

	<script>
		//디버깅을 위한 코드 
		console.log("Write.jsp 로드 완료");
		
		//KAKAO DEV를 사용하여 주소가 맞게 작성되었는지 확인하는 Flag
		let addressVerified = false;
		
		
		//========================================
		// helper 함수
		//========================================
		// 제목, 내용, 지도, 사진이 존재하는 지 확인함.
		function validateForm(form){
			if(form.title.value == ""){
				alert("제목을 입력하세요.");
				form.title.focus();
				return false;
			}
			if(form.content.value == ""){
				alert("내용을 입력하세요.");
				form.content.focus();
				return false;
			}
			if(!addressVerified){
				alert("지도를 입력하세요.");
				form.addressInput.focus();
				return false;
			}
			var fileInput = form.ofile;
			if(fileInput.files.length === 0){
				alert("사진을 업로드해주세요.");
				fileInput.focus();
				return false;
			}
			return true;
		}
		
		// KAKAO DEV API 사용하여 주소 받아옴.
		function searchAddress() {
			console.log("카카오 API에 요청 시작");
			var geocoder = new kakao.maps.services.Geocoder();
			var address = document.getElementById('addressInput').value;
			
			geocoder.addressSearch(address, function(result, status) {
				if (status === kakao.maps.services.Status.OK) {
					addressVerified = true;
					document.getElementById('latitude').value = result[0].y;
					document.getElementById('longitude').value = result[0].x;
					
					// Show map preview (optional)
					var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
					var map = new kakao.maps.Map(document.getElementById('map'), {
					center: coords,
					level: 3
					});
					new kakao.maps.Marker({ position: coords, map: map });
				} else {
					alert('주소를 찾을 수 없습니다.');
				}
			});
			console.log("카카오 API에 요청 완료");
		}
		
		// 맛집을 추가할 수 있도록 하는 버튼 
		function addRestaurant() {
			const html = `
				<div class="restaurant-entry mb-2">
					<div class="d-flex gap-2 align-items-center">
						<input type="text" name="restName[]" class="form-control w-25" placeholder="식당 이름">
						<input type="url" name="restAddress[]" class="form-control w-75" placeholder="링크">
						<button type="button" class="btn btn-outline-danger btn-sm" onclick="this.closest('.restaurant-entry').remove()">×</button>
					</div>
				</div>
			`;
			document.getElementById('restaurantList').insertAdjacentHTML('beforeend', html);
			console.log("레스토랑 추가 완료");
		}
	</script>
	
</head>
<body class="container-fluid px-0 py-0 mx-0 my-0">
	<!-- ================================================================================================================== -->
	<!--                                            댓글목록 
		 - 
		 -Java/FileUpload/FileUtil.java을 이용해서 파일을 업로드 함.
	<!-- ================================================================================================================== -->
	
	<h1 class="text-center">추천 여행지</h1>
	<div class="d-flex justify-content-center ">
		<!-- form html -->
		<!-- 목적지 : "../board/write.do" -->
		<!-- form 이름: writeFrm - Board와 같게 작성함 -->
		<!-- enctype="multipart/form-data" - 이미지를 포함하여 필요함 -->
		<!-- onsubmit="return validateForm(this);" : 등록하기 클릭 시 작료 확인 (함수에 존재함) -->
		<form name="writeFrm" method="post" enctype="multipart/form-data"
			action="../board/write.do" onsubmit="return validateForm(this);"
			class="w-75 px-3 border border-dark">
			<h4 class="text-center my-3">게시글 등록</h4>
			<div class="container mx-auto mb-3" style="max-width: 800px;">
				<!-- row가 있어야 밑에 col을 사용하여 틀에 맞출 수 있음 -->
				<!-- g-2는 div 사이 공간을 생성함 -->
				<div class="row g-2 align-items-center">
					<!-- 위치를 선택하는 콤보박스 -->
					<div class="col-auto">
						<select name="locationSelect" class="form-select">
							<c:forEach items="${locationName}" var="loc">
								<option value="${loc.locationName}">${loc.locationName}</option>
							</c:forEach>
						</select>
					</div>
				
					<!-- 해쉬태그를 선택하는 콤보박스 -->
					<div class="col-auto">
						<select name="hashtagSelect" class="form-select">
							<c:forEach items="${hashtagName}" var="tag">
								<option value="${tag.hashtagName}">${tag.hashtagName}</option>
							</c:forEach>
						</select>
					</div>
					
					<!-- 제목 col에 auto가 없어 남은 공간을 차지함-->
					<div class="col">
						<input type="text" name="title" class="form-control" placeholder="제목 입력" />
					</div>
				</div>
			</div>
			<div>
				<h4>사진등록</h4>
				<input type="file" name="ofile" class="form-control my-3" />
			</div>
			<br>
			<div>
				<h4>상세정보 등록</h4>
				<textarea name="content" class="form-control w-100 my-3" rows="10" placeholder="내용을 입력하세요"></textarea>
			</div>
			
			<!-- 지도를 작성하는 부분 -->
			<div class="row mb-5 px-3">
				<div class="col-10">
					<input type="text" id="addressInput" name="addressInput" class="form-control" placeholder="주소 입력 (예: 서울 강남구 역삼동 123-45)">
				</div>
				<div class="col-2">
					<button type="button" class="btn btn-secondary w-100" onclick="searchAddress()">주소 검색</button>
				</div>
				<!-- 위도 및 경도  -->
				<input type="hidden" name="latitude" id="latitude">
				<input type="hidden" name="longitude" id="longitude">
				<!-- 지도 -->
				<div id="map" class="w-100 mt-3 border border-dark" style="height:300px;"></div>
			</div>
			<div class="my-5">
				<h4>부가 정보 등록</h4>
				<input type="text" name="details[]" class="form-control w-100 mb-2" placeholder="관련정보를 작성해 주세요. (예. 운영시간)">
				<input type="text" name="details[]" class="form-control w-100 mb-2" placeholder="관련정보를 작성해 주세요. (예. 운영시간)">
				<input type="text" name="details[]" class="form-control w-100 mb-2" placeholder="관련정보를 작성해 주세요. (예. 운영시간)">
				<input type="text" name="details[]" class="form-control w-100 mb-2" placeholder="관련정보를 작성해 주세요. (예. 운영시간)">
				<input type="text" name="details[]" class="form-control w-100 mb-2" placeholder="관련정보를 작성해 주세요. (예. 운영시간)">
			</div>
			<div id="restaurantList" class="my-5">
				<h4>주변 맛집 등록</h4>
				<button type="button" class="btn btn-secondary w-25 mb-4" onclick="addRestaurant()">맛집 추가</button>
			</div>
			<div>
				<button type="submit" class="btn btn-primary text-center w-100 mb-5">등록하기</button>
			</div>
		</form>
	</div>
	<jsp:include page="/Resources/Footer.jsp" />

</body>
</html>