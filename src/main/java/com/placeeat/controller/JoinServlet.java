package com.placeeat.controller;

import java.io.IOException;
import com.placeeat.dao.MemberDAO;
import com.placeeat.dao.MemberVO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/Member/join.do")
public class JoinServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String userid = request.getParameter("userid");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");
        String name = request.getParameter("name");
        String birth = request.getParameter("birthYear") + "-" +
               request.getParameter("birthMonth") + "-" +
               request.getParameter("birthDay");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String grade = request.getParameter("grade");

        if (userid == null || userid.trim().length() < 4) {
            request.setAttribute("message", "아이디는 4자 이상이어야 합니다.");
            request.getRequestDispatcher("/Member/SignUp.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirm)) {
            request.setAttribute("message", "비밀번호가 일치하지 않습니다.");
            request.getRequestDispatcher("/Member/SignUp.jsp").forward(request, response);
            return;
        }

        MemberDAO dao = MemberDAO.getInstance();
        if (dao.isUserIdDuplicate(userid)) {
            request.setAttribute("message", "이미 사용중인 아이디입니다.");
            request.getRequestDispatcher("/Member/SignUp.jsp").forward(request, response);
            return;
        }
        if (dao.isEmailDuplicate(email)) {
            request.setAttribute("message", "이미 사용중인 이메일입니다.");
            request.getRequestDispatcher("/Member/SignUp.jsp").forward(request, response);
            return;
        }

        String hashed = org.mindrot.jbcrypt.BCrypt.hashpw(password, org.mindrot.jbcrypt.BCrypt.gensalt(12));
        MemberVO mVo = new MemberVO();
        mVo.setUserid(userid);
        mVo.setPassword(hashed);
        mVo.setName(name);
        mVo.setBirth(birth);
        mVo.setGender(gender);
        mVo.setEmail(email);
        mVo.setGrade(grade);

        int result = dao.insertMember(mVo);
        if (result == 1) {
            response.sendRedirect(request.getContextPath() + "/Member/Login.jsp");
        } else {
            request.setAttribute("message", "회원가입 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/Member/SignUp.jsp").forward(request, response);
        }
    }
}
