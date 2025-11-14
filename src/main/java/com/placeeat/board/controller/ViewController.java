package com.placeeat.board.controller;

import java.io.IOException;
import java.util.List;

import com.placeeat.board.dao.BoardDAO;
import com.placeeat.board.dao.BoardDTO;
import com.placeeat.board.dao.CommentDAO;
import com.placeeat.board.dao.CommentDTO;
import com.placeeat.board.dao.RestaurantDAO;
import com.placeeat.board.dao.RestaurantDTO;
import com.placeeat.dao.MemberVO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Board/View.do")
public class ViewController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ViewController() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        BoardDAO dao = new BoardDAO(); 

        // 1. 게시글 ID 파라미터 받기
        String boardIdStr = req.getParameter("boardId");
        if (boardIdStr == null || boardIdStr.trim().equals("")) {
            resp.sendRedirect(req.getContextPath() + "/Board/List.do");
            return;
        }

        int boardId;
        try {
            boardId = Integer.parseInt(boardIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/Board/List.do");
            return;
        }

        // 2. 조회수 증가
        try {
            dao.increaseViewCount(boardId);
        } catch (Exception e) {
            System.out.println("[ERROR] 조회수 증가 중 문제 발생");
            e.printStackTrace();
        }

        // 3. 게시글 상세조회
        BoardDTO board = dao.selectView(boardId);
        if (board == null || board.getBoardId() == 0) {
            resp.sendRedirect(req.getContextPath() + "/Board/List.do");
            return;
        }

        // 4. 좋아요 수 조회
        int likeCount = dao.getLikeCount(boardId);
        req.setAttribute("likeCount", likeCount);

        // 5. 로그인 정보
        MemberVO loginUser = (MemberVO) req.getSession().getAttribute("loginUser");
        req.setAttribute("isLoggedIn", loginUser != null);
        req.setAttribute("loginUser", loginUser);

        // 6. 사용자의 좋아요 여부 조회
        boolean userLiked = false;
        String userId = null;
        if (loginUser != null) {
            userId = loginUser.getUserid();
            userLiked = dao.hasUserLiked(boardId, userId);
        }
        req.setAttribute("userLiked", userLiked);
        req.setAttribute("userId", userId);

        // 7. 게시글 정보 request에 저장
        req.setAttribute("board", board);

        // 8. 댓글 목록 조회
        CommentDAO cdao = new CommentDAO();
        List<CommentDTO> comments = cdao.selectComments(boardId);
        req.setAttribute("comments", comments);
        cdao.close();

        // 9. 맛집 목록 조회
        RestaurantDAO rdao = new RestaurantDAO();
        List<RestaurantDTO> restaurants = rdao.selectRestaurants(boardId);
        req.setAttribute("restaurants", restaurants);
        rdao.close();

        // 10. JSP로 포워드
        req.getRequestDispatcher("/Board/View.jsp").forward(req, resp);

        // 11. DAO 연결 닫기
        dao.close();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
