package com.placeeat.find;

import java.io.IOException;
import com.placeeat.dao.MemberDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/member/resetPassword.do")
public class ResetPasswordServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        MemberDAO dao = MemberDAO.getInstance();
        String userid = dao.findUserByToken(token);

        if (userid == null) {
            request.setAttribute("message", "유효하지 않은 토큰입니다.");
            request.getRequestDispatcher("/member/Login.jsp").forward(request, response);
            return;
        }

        // 토큰이 유효하면 비밀번호 재설정 JSP로 이동
        request.setAttribute("token", token);
        request.getRequestDispatcher("/member/ResetPassword.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPw = request.getParameter("newPassword");

        MemberDAO dao = MemberDAO.getInstance();
        String userid = dao.findUserByToken(token);

        if (userid == null) {
            request.setAttribute("message", "유효하지 않은 토큰입니다.");
            request.getRequestDispatcher("/member/Login.jsp").forward(request, response);
            return;
        }

        dao.updatePassword(userid, newPw);
        dao.clearResetToken(userid);

        request.setAttribute("message", "비밀번호가 성공적으로 변경되었습니다.");
        request.getRequestDispatcher("/member/Login.jsp").forward(request, response);
    }
}
