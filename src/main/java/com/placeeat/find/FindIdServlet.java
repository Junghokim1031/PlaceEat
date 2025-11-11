package com.placeeat.find;

import java.io.IOException;
import com.placeeat.dao.MemberDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/member/findid.do")
public class FindIdServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        String birth = request.getParameter("birth");

        MemberDAO dao = MemberDAO.getInstance();
        String userid = dao.findIdByNameBirth(name, birth);

        if (userid != null) request.setAttribute("foundId", userid);
        else request.setAttribute("message", "일치하는 회원이 없습니다.");

        request.getRequestDispatcher("/member/FindId.jsp").forward(request, response);
    }
}
