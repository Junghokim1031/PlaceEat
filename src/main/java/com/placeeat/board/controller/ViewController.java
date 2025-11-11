package com.placeeat.board.controller;

import java.io.IOException;
import java.util.List;

import com.placeeat.board.dao.BoardDAO;
import com.placeeat.board.dao.BoardDTO;
import com.placeeat.board.dao.CommentDAO;
import com.placeeat.board.dao.CommentDTO;
import com.placeeat.board.dao.RestaurantDAO;
import com.placeeat.board.dao.RestaurantDTO;

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
	
	 protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	        BoardDAO dao = new BoardDAO(); 
	 
			 
		// 2. 파라미터 받기
		 String boardIdStr = req.getParameter("boardId");
	        if (boardIdStr == null || boardIdStr.trim().equals("")) {
	            resp.sendRedirect(req.getContextPath() + "/Board/List.do"); // 게시글 아이디 없으면 목록으로
	            return;
	        }	        
	      
	        try {
	            Integer.parseInt(boardIdStr);
	        } catch (NumberFormatException e) {
	            resp.sendRedirect(req.getContextPath() + "/Board/List.do");
	            return;
	        }
	        
	    	        
	    // 3. 게시글 상세조회
	        int boardId = Integer.parseInt(boardIdStr);
	        BoardDTO board = dao.selectView(boardId);
	        if (board == null || board.getBoardId() == 0) {
	            resp.sendRedirect(req.getContextPath() + "/Board/List.do");
	            return;
	        }
	        
	     // 4. 좋아요 수 조회 (boardlike_table에서 COUNT(*)로 계산)
	        int likeCount = dao.getLikeCount(boardId);
	        req.setAttribute("likeCount", likeCount);

	        // 4-1. 사용자의 좋아요 여부 조회
	        String userId = (String) req.getSession().getAttribute("userId");
	        if (userId == null) {
	            resp.sendRedirect(req.getContextPath() + "/Login.do");
	            return;
	        }

	        boolean userLiked = dao.hasUserLiked(boardId, userId);
	        req.setAttribute("userLiked", userLiked);

	        // 5. 데이터 request 속성으로 저장
	        req.setAttribute("board", board);
	        // req.setAttribute("likeCount", likeCount); // 이미 위에서 설정됨
	        // ⭐ req.setAttribute("userLiked", userLiked); // 이미 위에서 설정됨
	        
	        // 6. 댓글 목록 조회 추가
	        CommentDAO cdao = new CommentDAO();
	        List<CommentDTO> comments = cdao.selectComments(boardId);
	        req.setAttribute("comments", comments);
	        cdao.close();
	        
	        // 7. 맛집 목록
	        RestaurantDAO rdao = new RestaurantDAO();
	        List<RestaurantDTO> restaurants = rdao.selectRestaurants(boardId);
	        //System.out.println(">>> 맛집 개수: " + (restaurants != null ? restaurants.size() : 0));
	        req.setAttribute("restaurants", restaurants);
	        rdao.close();
	        
	        // 8. JSP로 포워드
	        req.getRequestDispatcher("/Board/View.jsp").forward(req, resp);

	        // 9. DAO 연결 닫기
	        dao.close();
	    	}

	    @Override
	    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	        doGet(req, resp);
	    }
		 
	 }
