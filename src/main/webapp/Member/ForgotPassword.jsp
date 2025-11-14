<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기 | Place & Eat</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
      rel="stylesheet" crossorigin="anonymous">

<link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Footer.css">

<style>
html, body {
    height: 100%;
    margin: 0;
}

body {
    display: flex;
    flex-direction: column;
    font-family: 'Arial', sans-serif;
    background-color: #ffffff;
}

/* 콘텐츠가 공간을 채우게 하기 */
.main-wrapper {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: flex-start;   /* ★ 여기로 변경 */
    padding-top: 60px;         /* 너무 넓으면 숫자 줄이기 */
}


/* 카드 박스 디자인 */
.pwd-box {
    width: 420px;
    padding: 40px 30px;
    border: 1px solid #ddd;
    border-radius: 12px;
    background: #fff;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

/* 제목 */
.pwd-title {
    font-size: 26px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 25px;
}

/* 인풋 라인폼 */
.form-control {
    border: none;
    border-bottom: 1px solid #999;
    border-radius: 0;
    box-shadow: none;
}
.form-control:focus {
    border-bottom: 2px solid #007bff;
    box-shadow: none;
}

/* 버튼 */
.btn-send {
    background-color: #007bff;
    color: #fff;
    width: 100%;
    padding: 10px;
    font-weight: bold;
    margin-top: 20px;
    border-radius: 6px;
}
.btn-send:hover {
    background-color: #0066d3;
}

/* 링크 */
.back-login {
    text-align: center;
    margin-top: 15px;
}
.back-login a {
    font-size: 14px;
    text-decoration: none;
    color: #666;
}
.back-login a:hover {
    text-decoration: underline;
}
</style>

</head>

<body>

<jsp:include page="/Resources/Header.jsp" />

<!-- 메인 콘텐츠 -->
<div class="main-wrapper">

    <div class="pwd-box">

        <div class="pwd-title">비밀번호 찾기</div>

        <!-- 오류 메시지 -->
        <p style="color:red; text-align:center; font-size:14px;">
            <%= request.getAttribute("message") == null ? "" : request.getAttribute("message") %>
        </p>

        <form action="${pageContext.request.contextPath}/Member/findPwd.do" method="post">


            <!-- 아이디 -->
            <div class="mb-3">
                <label class="form-label">아이디</label>
                <input type="text" name="userid" class="form-control" required>
            </div>

            <!-- 이름 -->
            <div class="mb-3">
                <label class="form-label">이름</label>
                <input type="text" name="name" class="form-control" required>
            </div>

            <!-- 이메일 -->
            <div class="mb-3">
                <label class="form-label">이메일</label>
                <input type="email" name="email" class="form-control" required>
            </div>

            <!-- 생년월일 -->
            <label class="form-label mb-1">생년월일</label>
            <div class="d-flex mb-3">
                <input type="text" name="birthYear" class="form-control me-2" placeholder="YYYY" maxlength="4" required>
                <input type="text" name="birthMonth" class="form-control me-2" placeholder="MM" maxlength="2" required>
                <input type="text" name="birthDay" class="form-control" placeholder="DD" maxlength="2" required>
            </div>

            <button type="submit" class="btn btn-send">재설정 메일 보내기</button>

        </form>

        <div class="back-login">
            <a href="${pageContext.request.contextPath}/Member/Login.do">로그인으로 돌아가기</a>
        </div>

    </div><!-- pwd-box -->

</div><!-- main-wrapper -->

<jsp:include page="/Resources/Footer.jsp" />

</body>
</html>
