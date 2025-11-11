package com.placeeat.controller;

import java.io.IOException;
import com.placeeat.dao.MemberDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/Member/idCheck.do")
public class IdCheckServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userid = request.getParameter("userid");
        MemberDAO dao = MemberDAO.getInstance();
        boolean dup = dao.isUserIdDuplicate(userid);
        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write(dup ? "duplicate" : "available");
    }
}
