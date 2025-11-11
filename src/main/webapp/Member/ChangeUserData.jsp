<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>회원 정보 수정</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
        crossorigin="anonymous" />
        
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Header.css">

  <style>
    /* =============================
       기본 스타일
    ============================= */
    body {
      font-family: 'Arial', sans-serif;
      background-color: #ffffff;
      padding-bottom: 100px;
    }

    /* =============================
       회원 정보 수정 박스
    ============================= */
    .edit-box {
      max-width: 500px;
      margin: 100px auto;
      padding: 40px 30px;
      border: 1px solid #ddd;
      border-radius: 10px;
      background: #fff;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    .edit-title {
      font-size: 26px;
      font-weight: bold;
      text-align: center;
      margin-bottom: 30px;
    }

    .btn-edit {
      background-color: #888;
      color: #fff;
      width: 100%;
      padding: 10px;
      font-weight: bold;
      margin-top: 25px;
      border: none;
      transition: background-color 0.2s ease;
    }

    .btn-edit:hover {
      background-color: #666;
    }

    .label {
      margin-right: 10px;
    }

    input[readonly],
    select[disabled] {
      background-color: #f0f0f0;
      cursor: not-allowed;
    }

    .form-check-input[disabled] + .form-check-label {
      color: #999;
    }
  </style>
</head>

<!-- =============================
     비밀번호 일치 검사 스크립트
============================= -->
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
    form.addEventListener('submit', (e) => {
      const pw = form.password.value.trim();
      const pw2 = form.password2.value.trim();

      if (pw === '' || pw2 === '') {
        alert('비밀번호를 입력해주세요.');
        e.preventDefault();
        return;
      }

      if (pw !== pw2) {
        alert('비밀번호가 일치하지 않습니다.');
        e.preventDefault();
      }
    });
  });
</script>

<body>

	<jsp:include page="/Resources/Header.jsp" />

  <!-- =============================
       회원 정보 수정 폼
  ============================= -->
  <div class="edit-box">
    <div class="edit-title">회원 정보 수정</div>

    <form action="${pageContext.request.contextPath}/Member/ChangeUserData.do" method="post" name="frm">


      <!-- 아이디 (수정 불가) -->
      <div class="mb-3">
        <label class="form-label">아이디</label>
        <input type="text" name="userId" class="form-control" value=${mVo.userid} readonly />
      </div>

      <!-- 새 비밀번호 -->
      <div class="mb-3">
        <label class="form-label">새 비밀번호</label>
        <input type="password" name="password" class="form-control" placeholder="새 비밀번호 입력" />
      </div>

      <!-- 비밀번호 확인 -->
      <div class="mb-3">
        <label class="form-label">비밀번호 확인</label>
        <input type="password" name="password2" class="form-control" placeholder="비밀번호 재입력" />
      </div>

      <!-- 이름 -->
      <div class="mb-3">
        <label class="form-label">이름</label>
        <input type="text" name="userName" class="form-control" value="${mVo.name}" />
      </div>

      <!-- 생년월일 -->
			<div class="mb-3">
	  <label class="form-label">생년월일</label>
	  <div class="d-flex">
	    <input type="text" name="birthYear" class="form-control me-2 only-number" placeholder="년도" maxlength="4" />
	    <input type="text" name="birthMonth" class="form-control me-2 only-number" placeholder="월" maxlength="2" />
	    <input type="text" name="birthDay" class="form-control only-number" placeholder="일" maxlength="2" />
	  </div>
	</div>
	
	<script>
	  // 숫자만 입력 가능하게 (한글, 영문, 특수문자 제거)
	  document.querySelectorAll('.only-number').forEach(input => {
	    input.addEventListener('input', e => {
	      e.target.value = e.target.value.replace(/[^0-9]/g, ''); // 숫자 아닌 건 전부 제거
	    });
	  });
	</script>



      <!-- 성별 (수정 불가) -->
      <div class="mb-3">
        <label class="form-label">성별</label>
        <select name="gender" class="form-select" disabled>
          <option value="M" <c:if test="${mVo.gender eq 'M'}">selected</c:if>>남성</option>
          <option value="F" <c:if test="${mVo.gender eq 'F'}">selected</c:if>>여성</option>
        </select>
      </div>

      <!-- 이메일 (수정 불가) -->
      <div class="mb-3">
        <label class="form-label">이메일</label>
        <input type="email" name="email" class="form-control" value="${mVo.email}" readonly />
      </div>

      <!-- 회원등급 (수정 불가) -->
      <div class="mb-3">
        <span class="label">회원 등급</span>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="grade" id="reporter" value="R"
                 <c:if test="${mVo.grade eq 'R'}">checked</c:if> disabled />
          <label class="form-check-label" for="reporter">기자</label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="grade" id="user" value="U"
                 <c:if test="${mVo.grade eq 'U'}">checked</c:if> disabled />
          <label class="form-check-label" for="user">일반</label>
        </div>
      </div>

      <!-- 수정 버튼 -->
      <button type="submit" class="btn btn-edit">정보 수정하기</button>
    </form>
  </div>


  <!-- =============================
       Bootstrap JS
  ============================= -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
          crossorigin="anonymous"></script>
</body>
</html>
