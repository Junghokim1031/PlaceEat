package com.placeeat.find;

import java.io.IOException;
import java.util.UUID;

import com.placeeat.dao.MemberDAO;
import com.placeeat.util.MailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Member/sendResetMail.do")
public class SendResetMailServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String userid = request.getParameter("userid");
        String name = request.getParameter("name");
        String email = request.getParameter("email");

        // JSP에서 받은 생년월일 합치기
        String birthYear = request.getParameter("birthYear");
        String birthMonth = request.getParameter("birthMonth");
        String birthDay = request.getParameter("birthDay");

        // DB 컬럼 형식에 맞춰 합치기
        // 예: YYYYMMDD 형식이면
        String birth = birthYear + birthMonth + birthDay;
        // 예: YYYY-MM-DD 형식이면
        // String birth = birthYear + "-" + birthMonth + "-" + birthDay;

        MemberDAO dao = MemberDAO.getInstance();
        // DAO 메서드도 birth까지 받도록 수정 필요
        String found = dao.findUserByIdNameEmail(userid, name, email, birth);

        if (found == null) {
            request.setAttribute("message", "입력하신 정보와 일치하는 회원이 없습니다.");
            request.getRequestDispatcher("/Member/ForgotPassword.jsp").forward(request, response);
            return;
        }

        String token = UUID.randomUUID().toString();
        dao.saveResetToken(userid, token);

        String resetLink = request.getScheme() + "://" + request.getServerName()
                + (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort())
                + request.getContextPath() + "/Member/resetPassword.do?token=" + token;

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

        request.getRequestDispatcher("/Member/ForgotPassword.jsp").forward(request, response);
    }
}

