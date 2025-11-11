package com.placeeat.controller;

import java.io.IOException;
import com.placeeat.dao.MemberDAO;
import com.placeeat.dao.MemberVO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/Member/UpdateInfo.do")
public class UpdateInfoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/Member/Login.jsp");
            return;
        }

        MemberDAO dao = MemberDAO.getInstance();
        MemberVO mVo = dao.getMember(loginUser.getUserid());

        request.setAttribute("mVo", mVo);
        request.getRequestDispatcher("/Member/ChangeUserData.jsp").forward(request, response);
    }
}
