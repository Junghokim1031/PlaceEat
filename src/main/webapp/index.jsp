<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <table>
        <tr>
            <td>
                <a href="${pageContext.request.contextPath}/controller/main.do">메인 페이지</a>
            </td>
            <td>
                <a href="${pageContext.request.contextPath}/controller/list.do">게시글 목록</a>
            </td>
            <td>
                <a href="${pageContext.request.contextPath}/controller/mypage.do">마이 페이지</a>
            </td>
        </tr>
    </table>
</body>
</html>