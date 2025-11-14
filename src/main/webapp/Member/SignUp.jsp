<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>회원가입</title>

  <!-- Bootstrap CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
        crossorigin="anonymous" />

  <link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Footer.css">

  <style>
  	
	  /* ================================
	     기본 스타일
	   ================================ */
  	
    body {
      font-family: 'Arial', sans-serif;
      background-color: #ffffff;
      padding-bottom: 100px;
    }

    .join-box {
      max-width: 500px;
      margin: 100px auto;
      padding: 40px 30px;
      border: 1px solid #ddd;
      border-radius: 10px;
      background: #fff;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    .join-title {
      font-size: 26px;
      font-weight: bold;
      text-align: center;
      margin-bottom: 30px;
    }

    .btn-checkid {
      background-color: #888;
      color: #fff;
      width: 100px;
      border: none;
      font-size: 14px;
      padding: 8px 15px;
      border-radius: 4px;
    }

    .btn-checkid:hover {
      background-color: #666;
    }

    .btn-join {
      background-color: #888;
      color: #fff;
      width: 100%;
      padding: 10px;
      font-weight: bold;
      margin-top: 25px;
    }

    .btn-join:hover {
      background-color: #666;
    }

    .label {
      margin-right: 10px;
    }
  </style>
</head>

<!-- ============================= -->
<!--  아이디 중복확인  -->
<!-- ============================= -->
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const checkBtn = document.querySelector('.btn-checkid');
    const userIdInput = document.querySelector('input[name="userid"]');

    checkBtn.addEventListener('click', function() {
      const userId = userIdInput.value.trim();

      if (userId === '') {
        alert('아이디를 입력해주세요.');
        userIdInput.focus();
        return;
      }

      //  Ajax 요청 (아이디 중복확인)
      fetch("${pageContext.request.contextPath}/Member/idCheck.do?userid=" + encodeURIComponent(userId))
        .then(response => response.text())
        .then(result => {
        	if (result.trim() === 'available') {
       		  alert('사용 가능한 아이디입니다.');
       		} else if (result.trim() === 'duplicate') {
       		  alert('이미 사용 중인 아이디입니다.');
       		} else {
       		  alert('서버 응답이 올바르지 않습니다.');
       		}
        })
        .catch(error => {
          console.error('에러 발생:', error);
          alert('서버 요청 중 오류가 발생했습니다.');
        });
    });
  });
</script>

<!-- ============================= -->
<!--  비밀번호 일치 확인 -->
<!-- ============================= -->
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
    form.addEventListener('submit', (e) => {
      const pw = form.password.value.trim();
      const pwCheck = form.password2.value.trim();

      if (pw === '' || pwCheck === '') {
        alert('비밀번호를 입력해주세요.');
        e.preventDefault();
        return;
      }

      if (pw !== pwCheck) {
        alert('비밀번호가 일치하지 않습니다.');
        e.preventDefault();
      }
    });
  });
</script>
<script>
document.addEventListener('DOMContentLoaded', function() {
  const emailCheckBtn = document.querySelector('.btn-checkemail');
  const emailInput = document.querySelector('input[name="email"]');

  emailCheckBtn.addEventListener('click', function() {
    const email = emailInput.value.trim();

    if (email === '') {
      alert('이메일을 입력해주세요.');
      emailInput.focus();
      return;
    }

    fetch("${pageContext.request.contextPath}/Member/emailCheck.do?email=" + encodeURIComponent(email))
      .then(response => response.text())
      .then(result => {
    	  if (result.trim() === 'available') {
       		  alert('사용 가능한 이메일입니다.');
       		} else if (result.trim() === 'duplicate') {
       		  alert('이미 사용 중인 이메일입니다.');
       		} else {
       		  alert('서버 응답이 올바르지 않습니다.');
       		}
      })
      .catch(error => {
        console.error('에러 발생:', error);
        alert('서버 요청 중 오류가 발생했습니다.');
      });
  });
});
</script>


<body>

	<jsp:include page="/Resources/Header.jsp" />

  <!-- ============================= -->
  <!-- 회원가입 폼 -->
  <!-- ============================= -->
  <div class="join-box">
    <div class="join-title">회원 가입</div>

    <!-- JSTL 메시지 출력 -->
    <c:if test="${not empty message}">
      <div class="alert alert-info text-center">${message}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/Member/join.do" method="post">

   
      <!-- 아이디 -->
      <div class="mb-3 d-flex">
        <input type="text" name="userid" class="form-control me-2" placeholder="아이디" value="${param.userid}" />
        <button type="button" class="btn-checkid">중복확인</button>
      </div>

      <!-- 비밀번호 -->
      <div class="mb-3">
        <input type="password" name="password" class="form-control" placeholder="비밀번호" />
      </div>

      <!-- 비밀번호 확인 -->
      <div class="mb-3">
        <input type="password" name="confirmPassword" class="form-control" placeholder="비밀번호 확인" />
      </div>

      <!-- 이름 -->
      <div class="mb-3">
        <input type="text" name="name" class="form-control" placeholder="이름" />
      </div>

      <!-- 생년월일 -->
      <div class="mb-3">
        <label class="form-label">생년월일</label>
        <div class="d-flex">
          <input type="text" name="birthYear" class="form-control me-2" placeholder="년도" maxlength="4" />
          <input type="text" name="birthMonth" class="form-control me-2" placeholder="월" maxlength="2" />
          <input type="text" name="birthDay" class="form-control" placeholder="일" maxlength="2" />
        </div>
      </div>

      <!-- 성별 -->
      <div class="mb-3">
        <select name="gender" class="form-select">
          <option value="" selected>성별</option>
          <option value="M">남성</option>
          <option value="F">여성</option>
        </select>
      </div>

      <!-- 이메일 -->
	 <div class="mb-3 d-flex">
		 <input type="email" name="email" class="form-control me-2" placeholder="이메일" />
		 <button type="button" class="btn btn-secondary btn-checkemail">중복확인</button>
	 </div>


      <!-- 회원등급 -->
      <div class="mb-3">
        <span class="label">회원 등급</span>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="grade" id="reporter" value="R" />
          <label class="form-check-label" for="reporter">기자</label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="grade" id="user" value="U" />
          <label class="form-check-label" for="user">일반</label>
        </div>
      </div>

      <!-- 가입 버튼 -->
      <button type="submit" class="btn btn-join">가입하기</button>
    </form>
  </div>
  <jsp:include page="/Resources/Footer.jsp" />
  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
          crossorigin="anonymous"></script>

</body>