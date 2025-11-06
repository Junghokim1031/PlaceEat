<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
String foundId = (String) session.getAttribute("foundId");
if (foundId != null) {
%>
<script>
    alert("아이디를 찾았습니다: <%= foundId %>");
    window.location.href = "Login.jsp";
</script>
<%
    session.removeAttribute("foundId");
} else {
    response.sendRedirect("FindId.jsp");
}
%>
