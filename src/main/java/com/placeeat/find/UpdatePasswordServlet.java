package com.placeeat.find;

import java.io.IOException;
import com.placeeat.dao.MemberDAO;
import com.placeeat.dao.MemberVO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/member/updatePassword.do")
public class UpdatePasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        if (token == null || token.isEmpty()) {
            request.setAttribute("message", "잘못된 요청입니다.");
            request.getRequestDispatcher("/member/ForgotPassword.jsp").forward(request, response);
            return;
        }
        if (!newPassword.equals(confirm)) {
            request.setAttribute("message", "비밀번호가 일치하지 않습니다.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/member/ResetPassword.jsp").forward(request, response);
            return;
        }

        MemberDAO dao = MemberDAO.getInstance();
        MemberVO m = dao.findMemberByToken(token);
        if (m == null) {
            request.setAttribute("message", "유효하지 않은 token입니다.");
            request.getRequestDispatcher("/member/ForgotPassword.jsp").forward(request, response);
            return;
        }

        String hashed = org.mindrot.jbcrypt.BCrypt.hashpw(newPassword, org.mindrot.jbcrypt.BCrypt.gensalt(12));
        dao.updatePassword(m.getUserid(), hashed);
        dao.clearResetToken(m.getUserid());

        request.setAttribute("message", "비밀번호가 변경되었습니다. 로그인 해주세요.");
        request.getRequestDispatcher("/member/Login.jsp").forward(request, response);
    }
}
