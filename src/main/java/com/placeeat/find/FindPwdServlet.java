package com.placeeat.find;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/Member/findPwd.do")
public class FindPwdServlet extends HttpServlet {

    // 비밀번호 찾기 화면 출력
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Member/ForgotPassword.jsp").forward(request, response);
    }

    // 비밀번호 찾기 폼에서 submit → 여기서 처리
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String userid = request.getParameter("userid");
        String name = request.getParameter("name");
        String email = request.getParameter("email");

        // ★ 생년월일 패딩 처리 (06, 07 자동으로 맞춰줌)
        String year = request.getParameter("birthYear");
        String month = String.format("%02d", Integer.parseInt(request.getParameter("birthMonth")));
        String day = String.format("%02d", Integer.parseInt(request.getParameter("birthDay")));

        String birth = year + "-" + month + "-" + day;

        // 다음 Servlet으로 넘기기
        request.setAttribute("userid", userid);
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("birth", birth);

        // sendResetMail.do 에게 전달 (forward)
        request.getRequestDispatcher("/Member/sendResetMail.do").forward(request, response);
    }
}
