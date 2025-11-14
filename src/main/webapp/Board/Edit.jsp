<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>

<html>
<head>
	<meta charset="UTF-8">
	<title>PLACE EAT 게시글 수정</title>
	
	<!-- BootStrap CSS 및 JS-->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" 
	        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" 
	        crossorigin="anonymous"></script>
	        
	<!-- KAKAO API -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=54ad5c72f0aaa1f9d3ac1211aad9a839&libraries=services"></script>
	
	<!-- Header 및 Footer CSS -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Header.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Footer.css">

	<script>
		console.log("Edit.jsp 로드 완료");
		
		// 기존 주소가 있으면 검증된 것으로 간주
		let addressVerified = ${not empty board.latitude ? 'true' : 'false'};
		
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
		  // 파일은 선택적 (기존 이미지 유지 가능)
		  return true;
		}
		
		function searchAddress() {
		  var geocoder = new kakao.maps.services.Geocoder();
		  var address = document.getElementById('addressInput').value;
		
		  geocoder.addressSearch(address, function(result, status) {
		    if (status === kakao.maps.services.Status.OK) {
		      addressVerified = true;
		      document.getElementById('latitude').value = result[0].y;
		      document.getElementById('longitude').value = result[0].x;
		
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
		}
		
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
		}
		
		// 페이지 로드 시 기존 지도 표시
		window.addEventListener('DOMContentLoaded', function() {
		  <c:if test="${not empty board.latitude and not empty board.longitude}">
		    var coords = new kakao.maps.LatLng(${board.latitude}, ${board.longitude});
		    var map = new kakao.maps.Map(document.getElementById('map'), {
		      center: coords,
		      level: 3
		    });
		    new kakao.maps.Marker({ position: coords, map: map });
		  </c:if>
		});
	</script>
</head>
<body class="container-fluid  px-0 py-0 mx-0 my-0">
	<jsp:include page="/Resources/Header.jsp" />
	<c:if test="${empty locationName}">
	    <p style="color:red;">locationName is empty or null!</p>
	</c:if>
	<h1 class="text-center"><b>추천 여행지</b></h1>
	<div class="d-flex justify-content-center">
		<form name="editFrm" method="post" enctype="multipart/form-data" 
		action="../Board/Edit.do" onsubmit="return validateForm(this);" class="w-75 px-3 border border-dark">
	
			<!--  Hidden: 수정할 게시글 ID  -->
			<input type="hidden" name="boardId" value="${board.boardId}">
			<input type="hidden" name="existingImgO" value="${board.imgOfilename}">
			<input type="hidden" name="existingImgS" value="${board.imgSfilename}">
			<input type="hidden" name="mode" value="update">

			<h4 class="text-center my-3"><b>게시글 수정</b></h4>
			
			<div class="container mx-auto mb-3" style="max-width: 800px;">
				<div class="row g-2 align-items-center">
				    <!-- Location dropdown with pre-selected value -->
					<select name="locationSelect" class="form-select w-25">
						<option value="">선택하세요</option>
						<c:forEach items="${locationName}" var="location">
							<option value="${location}" ${board.locationName eq location ? 'selected' : ''}>
								${location}
							</option>
						</c:forEach>
					</select>
					
					<!-- Hashtag dropdown with pre-selected value -->
					<select name="hashtagSelect" class="form-select w-25">
						<option value="">선택하세요</option>
						<c:forEach items="${hashtagName}" var="hashtag">
							<option value="${hashtag}" ${board.hashtagName eq hashtag ? 'selected' : ''}>
								${hashtag}
							</option>
						</c:forEach>
					</select>
			
				    <!-- 제목 (기존 값 채우기) -->
					<div class="col">
						<input type="text" name="title" class="form-control" 
							value="${board.title}">
					</div>
				</div>
			</div>
		
			<div>
				<h4>사진등록</h4>
				<!-- 기존 이미지 표시 -->
				<c:if test="${not empty board.imgSfilename}">
					<p class="text-muted">현재 이미지: ${board.imgOfilename}</p>
					<img src="${pageContext.request.contextPath}/Uploads/${board.imgSfilename}"
					   style="max-width: 200px; height: auto;" class="mb-2">
					<p class="text-muted small">새 파일을 선택하면 기존 이미지가 교체됩니다.</p>
				</c:if>
				<input type="file" name="ofile" class="form-control my-3" />
			</div>
			
			<br>
		
			<div>
				<h4>상세정보 등록</h4>
				<!-- 기존 내용 채우기 -->
				<textarea name="content" class="form-control w-100 my-3" rows="10" >
					${board.content}
				</textarea>
			</div>
		
			<!-- 지도 (기존 주소 채우기) -->
			<div class="row mb-5 px-3">
				<div class="col-10">
					<!--  주의: dto에 address 필드가 있다고 가정. 없으면 제거  -->
					<input type="text" id="addressInput" class="form-control">
				</div>
				<div class="col-2">
					<button type="button" class="btn btn-primary w-100" onclick="searchAddress()">주소 검색</button>
				</div>
				
				<!-- 기존 좌표 채우기 -->
				<input type="hidden" name="latitude" id="latitude" value="${board.latitude}">
				<input type="hidden" name="longitude" id="longitude" value="${board.longitude}">
				
				<div id="map" class="w-100 mt-3 border border-dark" style="height:300px;"></div>
			</div>
		
			<!-- 부가정보 (기존 details 배열 채우기) -->
			<div class="my-5">
				<h4>부가 정보 등록</h4>
			
				<input type="text" name="details" class="form-control bordered-input mb-2" 
                           placeholder="운영 시간, 입장료, 주차 정보, 연락처 등을 자유롭게 작성하세요" value="${board.details}" >
                           
			</div>
		
			<!-- 맛집 (기존 restaurants 채우기) -->
			<div id="restaurantList" class="my-5">
				<h4>주변 맛집 등록</h4>
			
				<!-- 기존 맛집 표시 -->
				<button type="button" class="btn btn-primary w-25 mb-4" onclick="addRestaurant()">맛집 추가</button>
				<c:forEach items="${restaurants}" var="rest">
					<div class="restaurant-entry mb-2">
						<div class="d-flex gap-2 align-items-center">
							<input type="text" name="restName[]" class="form-control w-25" 
							       placeholder="식당 이름" value="${rest.restName}">
							<input type="url" name="restAddress[]" class="form-control w-75" 
							       placeholder="링크" value="${rest.restAddress}">
							<button type="button" class="btn btn-outline-danger btn-sm" 
							       onclick="this.closest('.restaurant-entry').remove()">×</button>
						</div>
					</div>
				</c:forEach>
		  
			</div>
		
			<div>
				<!--  버튼 텍스트 변경  -->
				<button type="submit" class="btn btn-primary text-center w-100 mb-3">수정하기</button>
			</div>
		</form>
	</div>
	<jsp:include page="/Resources/Footer.jsp" />
</body>
</html>