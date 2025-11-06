package com.placeeat.find;

import java.io.IOException;
import java.util.UUID;
import com.placeeat.dao.MemberDAO;
import com.placeeat.util.MailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/member/sendResetMail.do")
public class SendResetMailServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String userid = request.getParameter("userid");
        String name = request.getParameter("name");
        String email = request.getParameter("email");

        MemberDAO dao = MemberDAO.getInstance();
        String found = dao.findUserByIdNameEmail(userid, name, email);

        if (found == null) {
            request.setAttribute("message", "입력하신 정보와 일치하는 회원이 없습니다.");
            request.getRequestDispatcher("/member/ForgotPassword.jsp").forward(request, response);
            return;
        }

        String token = UUID.randomUUID().toString();
        dao.saveResetToken(userid, token);

        String resetLink = request.getScheme() + "://" + request.getServerName()
                + (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort())
                + request.getContextPath() + "/member/resetPassword.do?token=" + token;

        String subject = "[PlaceEat] 비밀번호 재설정";
        String html = "<p>비밀번호 재설정을 요청하셨습니다.</p>"
                    + "<p><a href='" + resetLink + "'>비밀번호 재설정 링크</a></p>";

        try {
            MailUtil.sendMail(email, subject, html);
            request.setAttribute("message", "메일이 발송되었습니다. 메일함을 확인하세요.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "메일 발송 중 오류가 발생했습니다.");
        }

        request.getRequestDispatcher("/member/ForgotPassword.jsp").forward(request, response);
    }
}

