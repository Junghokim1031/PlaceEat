package com.placeeat.board.controller;

import java.io.IOException;
import com.placeeat.board.dao.BoardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/likeToggle.do")
public class LikeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        // ------------------------------
        // (1) 사용자 ID 가져오기
        // ------------------------------
        // ⭐ 실제 로그인 세션에서 아이디 가져오는 것을 권장
        String userId = (String) req.getSession().getAttribute("userId");
        if (userId == null) {
            String jsonError = "{\"success\":false,\"message\":\"로그인이 필요합니다.\"}";
            resp.getWriter().write(jsonError);
            return;
        }

        // ------------------------------
        // (2) 게시글 번호 파라미터 처리
        // ------------------------------
        String boardIdStr = req.getParameter("boardId");
        if (boardIdStr == null || boardIdStr.isEmpty()) {
            String jsonError = "{\"success\":false,\"message\":\"게시글 ID가 없습니다.\"}";
            resp.getWriter().write(jsonError);
            return;
        }

        int boardId = Integer.parseInt(boardIdStr);

        // ------------------------------
        // (3) DAO 로직 처리 (좋아요 토글)
        // ------------------------------
        BoardDAO dao = new BoardDAO();
        boolean success = false;

        try {
            boolean alreadyLiked = dao.hasUserLiked(boardId, userId);

            if (alreadyLiked) {
                // 이미 좋아요 -> 취소 (DELETE)
                success = dao.removeLike(boardId, userId) > 0;
            } else {
                // 좋아요 안 함 -> 추가 (INSERT)
                success = dao.addLike(boardId, userId) > 0;
            }

            // ------------------------------
            // (4) 좋아요 수 계산 (COUNT(*)로 재계산)
            // ------------------------------
            int newLikeCount = dao.getLikeCount(boardId);

            // ------------------------------
            // (5) 결과 JSON으로 응답
            // ------------------------------
            String json = "{\"success\":" + success + ",\"newLikeCount\":" + newLikeCount + "}";
            resp.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            String jsonError = "{\"success\":false,\"message\":\"서버 오류 발생\"}";
            resp.getWriter().write(jsonError);
        } finally {
            dao.close();
        }
    }
}