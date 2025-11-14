<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" crossorigin="anonymous">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Footer.css">

<style>
/* body를 flex로 만들어 footer를 아래로 밀기 */
html, body {
    height: 100%;
    margin: 0;
}

body {
    display: flex;
    flex-direction: column;
}

/* 메인 콘텐츠 공간 (footer 위까지 자동 확장됨) */
.main-wrapper {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;   /* ★ 수직 중앙 */
    padding-top: 0px;      /* ★ 필요 없음 */
}


/* 중앙 박스 */
.id-box {
    width: 400px;
    padding: 40px 30px;
    border: 1px solid #ddd;
    border-radius: 10px;
    background: #fff;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.find-title {
    font-size: 26px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 30px;
}

.form-control {
    border: none;
    border-bottom: 1px solid #000;
    border-radius: 0;
    box-shadow: none;
}

.btn-find {
    background-color: #007bff;
    color: #fff;
    width: 100%;
    padding: 10px;
    font-weight: bold;
    margin-top: 20px;
}
</style>
</head>

<body>

<jsp:include page="/Resources/Header.jsp" />

<!-- 메인 콘텐츠 영역 -->
<div class="main-wrapper">

    <div class="id-box">

        <div class="find-title">아이디 찾기</div>

        <c:if test="${not empty message}">
            <div class="alert alert-info text-center">${message}</div>
        </c:if>

        <c:if test="${not empty foundId}">
            <div class="alert alert-success text-center">
                회원님의 아이디는 <strong>${foundId}</strong> 입니다.
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/Member/findId.do" method="post">

            <div class="mb-3">
                <input type="text" name="name" class="form-control"
                       placeholder="이름" required />
            </div>

            <label class="mb-1">생년월일</label>
            <div class="d-flex mb-3">
                <input type="text" name="birthYear" class="form-control me-2"
                       placeholder="YYYY" maxlength="4" required />
                <input type="text" name="birthMonth" class="form-control me-2"
                       placeholder="MM" maxlength="2" required />
                <input type="text" name="birthDay" class="form-control"
                       placeholder="DD" maxlength="2" required />
            </div>

            <button type="submit" class="btn btn-find">아이디 찾기</button>
        </form>

    </div><!-- id-box -->

</div><!-- main-wrapper -->

<jsp:include page="/Resources/Footer.jsp" />

</body>
</html>
