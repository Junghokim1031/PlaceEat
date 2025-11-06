<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>


<!-- ================================================================================================================== -->
<!--                                       전체 개요 (Edit.JSP → edit.do)
												   ChatGPT 작성 문서
                                            컨트롤러에서 JSP로 전달할 데이터
 ■ Request Attributes (EditController.doGet에서 설정)
 
 1. dto (Map<String, Object> 또는 BoardDTO)
    - boardId (Integer)       : 수정할 게시글 ID
    - title (String)          : 게시글 제목
    - content (String)        : 게시글 내용
    - locationName (String)   : 지역명 (예: "서울특별시")
    - hashtagName (String)    : 해시태그 (예: "#파스타")
    - imgOFileName (String)   : 원본 파일명
    - imgSFileName (String)   : 저장된 파일명
    - latitude (Double)       : 위도
    - longitude (Double)      : 경도
    - address (String)        : 주소 문자열 (Optional)
    - details (List<String>)  : 부가정보 배열 (최대 5개)
    
 2. restaurantLists (List<Map<String, Object>>)
    - restId (Integer)        : 맛집 ID
    - boardId (Integer)       : 게시글 ID (FK)
    - restName (String)       : 식당 이름
    - address (String)        : 식당 링크/주소
    
 3. locationLists (List<Map<String, Object>>)
    - locationName (String)   : 지역명 (드롭다운 옵션)
    
 4. hashtagLists (List<Map<String, Object>>)
    - hashtagName (String)    : 해시태그명 (드롭다운 옵션)


                                        JSP에서 컨트롤러로 전송할 데이터 (POST)

 ■ 단일 값 필드 (req.getParameter 사용)
 - boardId (String → int)     : String boardIdStr = req.getParameter("boardId");
                                 int boardId = Integer.parseInt(boardIdStr);
 - locationSelect (String)     : String locationSelect = req.getParameter("locationSelect");
 - hashtagSelect (String)      : String hashtagSelect = req.getParameter("hashtagSelect");
 - title (String)              : String title = req.getParameter("title");
 - content (String)            : String content = req.getParameter("content");
 - addressInput (String)       : String address = req.getParameter("addressInput");
 
 ■ 좌표 정보 (Hidden 필드)
 - latitude (String → double)  : String latStr = req.getParameter("latitude");
                                  double latitude = Double.parseDouble(latStr);
 - longitude (String → double) : String lngStr = req.getParameter("longitude");
                                  double longitude = Double.parseDouble(lngStr);
 
 ■ 파일 업로드 (Optional - Multipart)
 - ofile (Part)                : Part filePart = req.getPart("ofile");
                                  // null이면 기존 이미지 유지
                                  if (filePart != null && filePart.getSize() > 0) {
                                      String newFileName = filePart.getSubmittedFileName();
                                  }
 
 ■ 배열 필드 (req.getParameterValues 사용)
 - details[] (String[])        : String[] details = req.getParameterValues("details[]");
                                  // 최대 5개, 빈 문자열 필터링 필요
                                  
 - restName[] (String[])       : String[] restNames = req.getParameterValues("restName[]");
 - restAddress[] (String[])    : String[] restAddresses = req.getParameterValues("restAddress[]");
                                  // 배열 길이는 동일 (parallel arrays)
                                  // null 체크 필수


                                                주의사항

 ⚠️ Write.JSP와의 차이점
 - boardId (hidden) 필드 필수 전송
 - ofile (파일 업로드) 선택사항: 업로드하지 않으면 기존 이미지 유지
 - 모든 입력 필드는 기존 값(dto.xxx)으로 pre-fill
 
 ⚠️ 배열 파라미터 처리
 - details[], restName[], restAddress[] 모두 배열 표기법([]) 사용 필수
 - Write.JSP와 동일한 파라미터명 사용
 
 ⚠️ 파일 업로드
 - @MultipartConfig 필수
 - 기존 imgSFileName 유지 로직 필요 (새 파일 없을 때)
 
 ⚠️ 삭제된 레스토랑 처리
 - 사용자가 × 버튼으로 삭제한 맛집은 전송되지 않음
 - 컨트롤러에서 기존 맛집 전체 삭제 후 재등록 또는 Diff 알고리즘 필요
 
 ⚠️ Kakao Maps API
 - 주소 검증: addressVerified flag가 true여야 제출 가능
 - 기존 좌표 존재 시 자동으로 true 설정
 
 ⚠️ MVC 패턴
 - Lines 29-103: 더미 데이터 (개발 전용)
 - 프로덕션 배포 전 EditController.doGet()으로 이동 필수
-->
<!-- ================================================================================================================== -->

<%
	//========================================
	//DUMMY DATA for Edit.JSP (Testing purposes only)
	//========================================
	
	//1. Dummy DTO (existing board data)
	Map<String, Object> dto = new HashMap<>();
	dto.put("boardId", 3);
	dto.put("title", "강남 파스타 집");
	dto.put("content", "점심 특선으로 주문한 알리오 올리오는 마늘의 향을 과하지 않게 살리면서 올리브 오일의 고소함을 충분히 담아낸 스타일이었습니다. 면은 알 덴테로 삶아져 식감이 살아 있었고, 페퍼론치노의 매콤함이 뒷부분에서 산뜻하게 치고 올라와 물리지 않았습니다. 사이드로 제공된 샐러드는 신선했고 산미가 과하지 않아 파스타와 잘 어울렸습니다.");
	dto.put("locationName", "서울특별시");
	dto.put("hashtagName", "#파스타");
	dto.put("imgOFileName", "pasta_original.jpg");
	dto.put("imgSFileName", "3.jpg");
	dto.put("latitude", 37.4979);
	dto.put("longitude", 127.0276);
	dto.put("address", "서울 강남구 역삼동 123-45");  // Optional if you store original address
	dto.put("userId", "이철수");
	dto.put("viewCount", 27);
	dto.put("createdAt", "2025-10-28");
	
	//Details array (부가정보)
	List<String> details = new ArrayList<>();
	details.add("운영시간: 11:30 ~ 21:00");
	details.add("주차: 건물 지하 주차장 이용 가능");
	details.add("예약: 필수 (주말)");
	details.add("가격대: 15,000원 ~ 25,000원");
	details.add("휴무: 매주 월요일");
	dto.put("details", details);
	
	request.setAttribute("dto", dto);
	
	//2. Dummy restaurantLists (existing restaurants)
	List<Map<String, Object>> restaurantLists = new ArrayList<>();
	
	Map<String, Object> rest1 = new HashMap<>();
	rest1.put("restId", 1);
	rest1.put("boardId", 3);
	rest1.put("restName", "파스타 하우스");
	rest1.put("address", "https://map.kakao.com/link/12345");
	restaurantLists.add(rest1);
	
	Map<String, Object> rest2 = new HashMap<>();
	rest2.put("restId", 2);
	rest2.put("boardId", 3);
	rest2.put("restName", "이탈리안 키친");
	rest2.put("address", "https://map.kakao.com/link/67890");
	restaurantLists.add(rest2);
	
	Map<String, Object> rest3 = new HashMap<>();
	rest3.put("restId", 3);
	rest3.put("boardId", 3);
	rest3.put("restName", "트라토리아");
	rest3.put("address", "https://map.kakao.com/link/11111");
	restaurantLists.add(rest3);
	
	request.setAttribute("restaurantLists", restaurantLists);
	
	//3. Location lists (dropdown options)
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
	
	//4. Hashtag lists (dropdown options)
	List<Map<String,Object>> hashtagLists = new ArrayList<>();
	String[] hashtags = {"#한식","#브런치","#디저트","#치킨","#회","#파스타","#비건","#카페","#가성비","#분위기좋은"};
	for (String tag : hashtags) {
		Map<String,Object> m = new HashMap<>();
		m.put("hashtagName", tag);
		hashtagLists.add(m);
	}
	request.setAttribute("hashtagLists", hashtagLists);
	
	//========================================
	//DUMMY DATA 끝
	//프로덕션에서는 이 부분을 모두 삭제하고
	//EditController.doGet()에서 setAttribute로 전달
	//========================================
%>

<html>
<head>
<meta charset="UTF-8">
<title>PLACE EAT 게시글 수정</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" 
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" 
        crossorigin="anonymous"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<APP_KEY_HERE>&libraries=services"></script>
	<style>
		<jsp:include page="../Resources/CSS/FooterCSS.jsp" />
	</style>


<script>
console.log("Edit.jsp 로드 완료");

// 기존 주소가 있으면 검증된 것으로 간주
let addressVerified = ${not empty dto.latitude ? 'true' : 'false'};

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
  <c:if test="${not empty dto.latitude and not empty dto.longitude}">
    var coords = new kakao.maps.LatLng(${dto.latitude}, ${dto.longitude});
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

<h1 class="text-center">추천 여행지</h1>
<div class="d-flex justify-content-center">
<!--  핵심 변경사항  
     1. action="../board/edit.do" 
     2. hidden field로 boardId 추가
     3. value="${dto.abc}" 로 모든 필드 pre-fill -->
<form name="editFrm" method="post" enctype="multipart/form-data"
action="../board/edit.do" onsubmit="return validateForm(this);"
class="w-75 px-3 border border-dark">

<!--  Hidden: 수정할 게시글 ID  -->
<input type="hidden" name="boardId" value="${dto.boardId}">

<h4 class="text-center my-3">게시글 수정</h4>

<div class="container mx-auto mb-3" style="max-width: 800px;">
  <div class="row g-2 align-items-center">
    <!-- 위치 (기존 값 선택) -->
    <div class="col-auto">
      <select name="locationSelect" class="form-select">
        <c:forEach items="${locationLists}" var="loc">
          <option value="${loc.locationName}" 
                  ${dto.locationName eq loc.locationName ? 'selected' : ''}>
            ${loc.locationName}
          </option>
        </c:forEach>
      </select>
    </div>

    <!-- 해시태그 (기존 값 선택) -->
    <div class="col-auto">
      <select name="hashtagSelect" class="form-select">
        <c:forEach items="${hashtagLists}" var="tag">
          <option value="${tag.hashtagName}"
                  ${dto.hashtagName eq tag.hashtagName ? 'selected' : ''}>
            ${tag.hashtagName}
          </option>
        </c:forEach>
      </select>
    </div>

    <!-- 제목 (기존 값 채우기) -->
    <div class="col">
      <input type="text" name="title" class="form-control" 
             placeholder="제목 입력" value="${dto.title}" />
    </div>
  </div>
</div>

<div>
  <h4>사진등록</h4>
  <!-- 기존 이미지 표시 -->
  <c:if test="${not empty dto.imgSFileName}">
    <p class="text-muted">현재 이미지: ${dto.imgOFileName}</p>
    <img src="${pageContext.request.contextPath}/Resources/Img/${dto.imgSFileName}" 
         style="max-width: 200px; height: auto;" class="mb-2">
    <p class="text-muted small">새 파일을 선택하면 기존 이미지가 교체됩니다.</p>
  </c:if>
  <input type="file" name="ofile" class="form-control my-3" />
</div>
<br>

<div>
  <h4>상세정보 등록</h4>
  <!-- 기존 내용 채우기 -->
  <textarea name="content" class="form-control w-100 my-3" rows="10" 
            placeholder="내용을 입력하세요">${dto.content}</textarea>
</div>

<!-- 지도 (기존 주소 채우기) -->
<div class="row mb-5 px-3">
  <div class="col-10">
    <!--  주의: dto에 address 필드가 있다고 가정. 없으면 제거  -->
    <input type="text" id="addressInput" class="form-control" 
           placeholder="주소 입력 (예: 서울 강남구 역삼동 123-45)"
           value="${dto.address}">
  </div>
  <div class="col-2">
    <button type="button" class="btn btn-secondary w-100" onclick="searchAddress()">주소 검색</button>
  </div>

  <!-- 기존 좌표 채우기 -->
  <input type="hidden" name="latitude" id="latitude" value="${dto.latitude}">
  <input type="hidden" name="longitude" id="longitude" value="${dto.longitude}">

  <div id="map" class="w-100 mt-3 border border-dark" style="height:300px;"></div>
</div>

<!-- 부가정보 (기존 details 배열 채우기) -->
<div class="my-5">
  <h4>부가 정보 등록</h4>
  <!--  dto.details가 List<String>이라고 가정  -->
  <c:forEach begin="0" end="4" var="i">
    <input type="text" name="details[]" class="form-control w-100 mb-2" 
           placeholder="관련정보를 작성해 주세요. (예. 운영시간)"
           value="${dto.details[i]}">
  </c:forEach>
</div>

<!-- 맛집 (기존 restaurants 채우기) -->
<div id="restaurantList" class="my-5">
  <h4>주변 맛집 등록</h4>
  
  <!-- 기존 맛집 표시 -->
  <button type="button" class="btn btn-secondary w-25 mb-4" onclick="addRestaurant()">맛집 추가</button>
  <c:forEach items="${restaurantLists}" var="rest">
    <div class="restaurant-entry mb-2">
      <div class="d-flex gap-2 align-items-center">
        <input type="text" name="restName[]" class="form-control w-25" 
               placeholder="식당 이름" value="${rest.restName}">
        <input type="url" name="restAddress[]" class="form-control w-75" 
               placeholder="링크" value="${rest.address}">
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