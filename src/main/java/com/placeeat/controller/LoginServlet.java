package com.placeeat.controller;

import java.io.IOException;
import com.placeeat.dao.MemberDAO;
import com.placeeat.dao.MemberVO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/member/login.do")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String userid = request.getParameter("userid");
        String pwd = request.getParameter("pwd");
        String remember = request.getParameter("remember");

        MemberDAO dao = MemberDAO.getInstance();
        int check = dao.userCheck(userid, pwd);

        if (check == 1) {
            MemberVO mVo = dao.getMember(userid);
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", mVo);

            if (remember != null) {
                Cookie cookie = new Cookie("userid", userid);
                cookie.setMaxAge(60*60*24*7);
                response.addCookie(cookie);
            } else {
                Cookie cookie = new Cookie("userid", "");
                cookie.setMaxAge(0);
                response.addCookie(cookie);
            }
            response.sendRedirect(request.getContextPath() + "/member/Main.jsp");
        } else if (check == 0) {
            request.setAttribute("message", "비밀번호가 올바르지 않습니다.");
            request.getRequestDispatcher("/member/Login.jsp").forward(request, response);
        } else if (check == -1) {
            request.setAttribute("message", "존재하지 않는 아이디입니다.");
            request.getRequestDispatcher("/member/Login.jsp").forward(request, response);
        } else {
            request.setAttribute("message", "로그인 처리 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/member/Login.jsp").forward(request, response);
        }
    }
}
