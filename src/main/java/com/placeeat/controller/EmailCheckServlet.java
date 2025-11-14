package com.placeeat.controller;

import java.io.IOException;
import com.placeeat.dao.MemberDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/Member/emailCheck.do")
public class EmailCheckServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        MemberDAO dao = MemberDAO.getInstance();
        boolean dup = dao.isEmailDuplicate(email);
        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write(dup ? "duplicate" : "available");
    }
}
