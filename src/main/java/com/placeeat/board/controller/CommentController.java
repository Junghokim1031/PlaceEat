package com.placeeat.board.controller;

import java.io.IOException;
import com.placeeat.board.dao.CommentDAO;
import com.placeeat.board.dao.CommentDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Board/Insert.do")
public class CommentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        int boardId = Integer.parseInt(req.getParameter("boardId"));
        String content = req.getParameter("content");



        /* 실제 로그인 사용 시*/
        String userId = (String) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/Login.do");
            return;
        }
        

        CommentDAO dao = new CommentDAO();
        CommentDTO dto = new CommentDTO();
        dto.setBoardId(boardId);
        dto.setUserId(userId);
        dto.setContent(content);

        dao.insertComment(dto);
        dao.close();

        // 댓글 등록 후 게시글 상세보기로 이동
        resp.sendRedirect(req.getContextPath() + "/Board/View.do?boardId=" + boardId);
    }
}
