<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>회원가입</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<h2>회원가입</h2>
<form action="join.do" method="post">
    <label>아이디</label><br>
    <input type="text" id="userid" name="userid" required>
    <button type="button" id="checkBtn">중복확인</button>
    <span id="checkResult" style="margin-left:10px;"></span><br><br>

    <label>비밀번호</label><br>
    <input type="password" name="password" required><br><br>

    <label>이름</label><br>
    <input type="text" name="name" required><br><br>

    <label>생년월일 (예: 19900101)</label><br>
    <input type="text" name="birth" maxlength="8" required><br><br>

    <label>성별</label><br>
    <select name="gender">
        <option value="남">남</option>
        <option value="여">여</option>
    </select><br><br>

    <label>이메일</label><br>
    <input type="email" name="email" required><br><br>

    <label>회원 등급</label><br>
    <input type="radio" name="grade" value="기자" required> 기자
    <input type="radio" name="grade" value="일반" required> 일반<br><br>

    <input type="submit" value="가입하기">
</form>

<p style="color:red;">
<%= request.getAttribute("message") == null ? "" : request.getAttribute("message") %>
</p>

<script>
$("#checkBtn").click(function() {
    var userid = $("#userid").val().trim();
    if(userid === "") {
        alert("아이디를 입력하세요.");
        return;
    }
    $.ajax({
        url: "idCheck.do",
        data: { userid: userid },
        success: function(result) {
            if(result === "duplicate") {
                $("#checkResult").text("이미 사용 중인 아이디입니다.").css("color", "red");
            } else {
                $("#checkResult").text("사용 가능한 아이디입니다.").css("color", "green");
            }
        },
        error: function() {
            alert("중복확인 요청 중 오류가 발생했습니다.");
        }
    });
});
</script>
</body>
</html>
