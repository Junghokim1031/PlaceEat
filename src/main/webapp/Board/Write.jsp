<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
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

<!-- Kakao 지도 API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=54ad5c72f0aaa1f9d3ac1211aad9a839&libraries=services"></script>

<!-- CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Footer.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Write.css">

<script>
console.log("Write.jsp 로드 완료");
let addressVerified = false;

function validateForm(form) {
    if(form.title.value.trim() === "") {
        alert("제목을 입력하세요.");
        form.title.focus();
        return false;
    }
    if(form.content.value.trim() === "") {
        alert("내용을 입력하세요.");
        form.content.focus();
        return false;
    }
    if(form.location_name.value === "") {
        alert("지역을 선택하세요.");
        return false;
    }
    if(form.hashtag_name.value === "") {
        alert("해시태그를 선택하세요.");
        return false;
    }
    if(!addressVerified) {
        alert("주소를 검색하고 위치를 등록하세요.");
        return false;
    }
    if(form.ofile.files.length === 0) {
        alert("사진을 업로드 해주세요.");
        return false;
    }

    // ✅ 맛집 정보 검증
    const restNames = document.getElementsByName('rest_name');
    const restAddresses = document.getElementsByName('rest_address');
    
    let hasAnyRestaurant = false;

    for (let i = 0; i < restNames.length; i++) {
        const name = restNames[i].value.trim();
        const addr = restAddresses[i].value.trim();
        
        if (name !== "" || addr !== "") {
            hasAnyRestaurant = true;
            // If one field is filled, both must be filled
            if (name === "" || addr === "") {
                alert("맛집 정보는 이름과 주소를 모두 입력해주세요.");
                return false;
            }
        }
    }

    // Optional: Warn if no restaurants
    if (!hasAnyRestaurant) {
        return confirm("맛집 정보가 없습니다. 계속하시겠습니까?");
    }
    
    return true;
}

function searchAddress() {
    console.log("카카오 API에 요청 시작");
    let geocoder = new kakao.maps.services.Geocoder();
    let address = document.getElementById('addressInput').value;

    if(address.trim() === "") {
        alert("주소를 입력해주세요.");
        return;
    }

    geocoder.addressSearch(address, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            addressVerified = true;
            document.getElementById('latitude').value = result[0].y;
            document.getElementById('longitude').value = result[0].x;

            let coords = new kakao.maps.LatLng(result[0].y, result[0].x);
            let map = new kakao.maps.Map(document.getElementById('map'), {
                center: coords,
                level: 3
            });
            new kakao.maps.Marker({ position: coords, map: map });
            
            alert('주소가 확인되었습니다!');
        } else {
            alert('주소를 찾을 수 없습니다.');
            addressVerified = false;
        }
    });
}

// ✅ 맛집 추가 함수 (수정됨)
function addRestaurantRow() {
    const container = document.getElementById('restaurantList');
    const rows = container.querySelectorAll('.restaurant-row');
    if (rows.length >= 5) {
        alert("맛집은 최대 5개까지만 등록할 수 있습니다.");
        return;
    }

    const tr = document.createElement('tr');
    tr.classList.add('restaurant-row');
    tr.innerHTML = `
        <td><input type="text" name="rest_name" class="form-control" placeholder="맛집 이름" required></td>
        <td><input type="url" name="rest_address" class="form-control" placeholder="맛집 주소" required></td>
        <td class="text-center">
            <button type="button" class="btn btn-outline-danger btn-sm" onclick="removeRestaurantRow(this)">삭제</button>
        </td>
    `;
    container.appendChild(tr);
}

function removeRestaurantRow(button) {
    const container = document.getElementById('restaurantList');
    const rows = container.querySelectorAll('.restaurant-row');
    if (rows.length > 1) {
        button.closest('tr').remove();
    } else {
        alert("최소 1개의 맛집은 남아있어야 합니다.");
    }
}
</script>
</head>

<body class="container-fluid px-0 py-0 mx-0 my-0">
<jsp:include page="/Resources/Header.jsp" />

<div class="content-wrapper">
    <!-- Decorative Top Border -->
    <div class="border-decoration-top"></div>
    
    <!-- Page Title -->
    <h1 class="page-title">추천 여행지 등록</h1>

    <!-- Main Form Container -->
    <form name="writeFrm" method="post" enctype="multipart/form-data"
          action="../Board/Write.do" onsubmit="return validateForm(this);"
          class="write-form">

        <!-- Form Title -->
        <h2 class="form-section-title">게시글 등록</h2>

        <!-- Location, Hashtag, Title Section -->
        <div class="form-section">
            <label class="form-label">기본 정보</label>
            <div class="bordered-group">
                <div class="row g-2">
                    <!-- Location Select -->
                    <div class="col-md-3">
                        <label class="form-sublabel">지역</label>
                        <select name="location_name" class="form-select bordered-input">
                            <c:forEach items="${locationList}" var="loc">
                                <option value="${loc.locationName}">${loc.locationName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Hashtag Select -->
                    <div class="col-md-3">
                        <label class="form-sublabel">해시태그</label>
                        <select name="hashtag_name" class="form-select bordered-input">
                            <c:forEach items="${hashtagList}" var="tag">
                                <option value="${tag.hashtagName}">${tag.hashtagName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Title Input -->
                    <div class="col-md-6">
                        <label class="form-sublabel required">제목</label>
                        <input type="text" name="title" class="form-control bordered-input" 
                               placeholder="제목을 입력하세요" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Photo Upload Section -->
        <div class="form-section">
            <label class="form-label required">사진 등록</label>
            <div class="bordered-group">
                <input type="file" name="ofile" class="form-control bordered-input file-input" 
                       accept="image/*" />
                <div class="help-text">권장 사이즈: 1200x800px, 최대 5MB</div>
            </div>
        </div>

        <!-- Content Section -->
        <div class="form-section">
            <label class="form-label required">상세 정보</label>
            <div class="bordered-group">
                <textarea name="content" class="form-control bordered-input" rows="10" 
                          placeholder="여행지에 대한 상세한 설명을 입력하세요..."></textarea>
            </div>
        </div>

        <!-- Map Section -->
        <div class="form-section">
            <label class="form-label required">위치 정보</label>
            <div class="bordered-group">
                <div class="row g-2 mb-3">
                    <div class="col-md-9">
                        <input type="text" id="addressInput" name="addressInput" 
                               class="form-control bordered-input" 
                               placeholder="주소를 입력하세요 (예: 서울 강남구 역삼동 123-45)">
                    </div>
                    <div class="col-md-3">
                        <button type="button" class="btn btn-secondary w-100" onclick="searchAddress()">
                            주소 검색
                        </button>
                    </div>
                </div>
                
                <!-- Hidden Coordinates -->
                <input type="hidden" name="latitude" id="latitude">
                <input type="hidden" name="longitude" id="longitude">
                
                <!-- Map Display -->
                <div id="map" class="map-container"></div>
                <div class="help-text mt-2">주소를 입력하고 '주소 검색' 버튼을 클릭하세요</div>
            </div>
        </div>

        <!-- Additional Details Section -->
        <div class="form-section">
            <label class="form-label">부가 정보</label>
            <div class="bordered-group">
                <div class="details-list">
                    <input type="text" name="details" class="form-control bordered-input mb-2" 
                           placeholder="운영 시간, 입장료, 주차 정보, 연락처 등을 자유롭게 작성하세요">
                </div>
                <div class="help-text">선택 사항입니다. 필요한 정보를 입력하세요</div>
            </div>
        </div>

        <!-- ✅ 맛집 등록 영역 (수정됨) -->
        <div class="form-section">
            <label class="form-label">주변 맛집 (최대 5개)</label>
            <div class="bordered-group">
                <table class="table table-bordered restaurant-table">
                    <thead class="table-light">
                        <tr>
                            <th style="width:40%">맛집 이름</th>
                            <th style="width:50%">주소</th>
                            <th style="width:10%" class="text-center">관리</th>
                        </tr>
                    </thead>
                    <tbody id="restaurantList">
                        <tr class="restaurant-row">
                            <td><input type="text" name="rest_name" class="form-control" placeholder="맛집 이름"></td>
                            <td><input type="text" name="rest_address" class="form-control" placeholder="맛집 주소"></td>
                            <td class="text-center">
                                <button type="button" class="btn btn-outline-danger btn-sm" 
                                        onclick="removeRestaurantRow(this)">삭제</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <button type="button" class="btn btn-outline-primary btn-sm" onclick="addRestaurantRow()">
                    + 맛집 추가
                </button>
                <div class="help-text mt-2">추천할 맛집이 있다면 추가해주세요</div>
            </div>
        </div>

        <!-- Submit Button -->
        <div class="button-group">
            <button type="submit" class="btn-primary">등록하기</button>
            <a href="${pageContext.request.contextPath}/Board/List.do" class="btn-cancel">취소</a>
        </div>

    </form>

    <!-- Decorative Bottom Border -->
    <div class="border-decoration-bottom"></div>
</div>

<jsp:include page="/Resources/Footer.jsp" />
</body>
</html>
