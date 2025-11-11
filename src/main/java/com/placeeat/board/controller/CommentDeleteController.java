package com.placeeat.board.controller;

import java.io.IOException;
import com.placeeat.board.dao.CommentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Board/Delete.do")
public class CommentDeleteController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        int commentId = Integer.parseInt(req.getParameter("commentId"));
        int boardId = Integer.parseInt(req.getParameter("boardId"));

        /* 실제 로그인 사용 시*/
        String userId = (String) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/Login.do");
            return;
        }

        CommentDAO dao = new CommentDAO();
        dao.deleteComment(commentId, userId);
        dao.close();

        resp.sendRedirect(req.getContextPath() + "/Board/View.do?boardId=" + boardId);
    }
}
