package com.placeeat.controller;

import java.io.IOException;
import com.placeeat.dao.MemberDAO;
import com.placeeat.dao.MemberVO;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/Member/ChangeUserData.do")
public class ChangeUserDataServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/Member/Login.jsp");
            return;
        }

        // ✅ 폼 데이터 받기
        String userid = loginUser.getUserid(); // 수정 불가
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("password2");
        String name = request.getParameter("userName");
        String year = request.getParameter("birthYear");
        String month = request.getParameter("birthMonth");
        String day = request.getParameter("birthDay");


        if (month != null && month.length() == 1) month = "0" + month;
        if (day != null && day.length() == 1) day = "0" + day;

        String birth = year + "-" + month + "-" + day;

        // ✅ 유효성 검사
        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "비밀번호가 일치하지 않습니다.");
            request.getRequestDispatcher("/Member/ChangeUserData.jsp").forward(request, response);
            return;
        }

        // ✅ 암호화 후 업데이트
        String hashedPwd = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));

        MemberDAO dao = MemberDAO.getInstance();
        MemberVO updatedUser = new MemberVO();

        updatedUser.setUserid(userid);
        updatedUser.setPassword(hashedPwd);
        updatedUser.setName(name);
        updatedUser.setBirth(birth);
        updatedUser.setGender(loginUser.getGender());
        updatedUser.setEmail(loginUser.getEmail());
        updatedUser.setGrade(loginUser.getGrade());

        int result = dao.updateMember(updatedUser);

        if (result == 1) {
            // 세션 정보 갱신
            session.setAttribute("loginUser", updatedUser);
            request.setAttribute("message", "회원 정보가 성공적으로 수정되었습니다!");
            request.getRequestDispatcher("/Member/MyPage.jsp").forward(request, response);
        } else {
            request.setAttribute("message", "회원정보 수정 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/Member/ChangeUserData.jsp").forward(request, response);
        }
    }
}
