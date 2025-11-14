package com.placeeat.find;

import java.io.IOException;
import com.placeeat.dao.MemberDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/Member/findId.do")
public class FindIdServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // GET 요청 시 단순히 FindId.jsp 페이지 열기
        request.getRequestDispatcher("/Member/FindId.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String birthYear = request.getParameter("birthYear");
        String birthMonth = request.getParameter("birthMonth");
        String birthDay = request.getParameter("birthDay");
        String birth = birthYear + "-" + birthMonth + "-" + birthDay; // DB 형식 확인 필요

        MemberDAO dao = MemberDAO.getInstance();
        String userid = dao.findIdByNameBirth(name, birth);

        if (userid != null) {
            request.setAttribute("foundId", userid);
        } else {
            request.setAttribute("message", "일치하는 회원이 없습니다.");
        }

        request.getRequestDispatcher("/Member/FindId.jsp").forward(request, response);
    }
}
