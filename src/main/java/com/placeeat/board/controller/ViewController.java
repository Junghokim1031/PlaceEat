package com.placeeat.board.controller;

import java.io.IOException;

import com.placeeat.board.dao.BoardDAO;
import com.placeeat.board.dao.BoardDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/controller/view.do")
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
	            resp.sendRedirect(req.getContextPath() + "/controller/list.do"); // 게시글 아이디 없으면 목록으로
	            return;
	        }	        
	      
	        try {
	            Integer.parseInt(boardIdStr);
	        } catch (NumberFormatException e) {
	            resp.sendRedirect(req.getContextPath() + "/controller/list.do");
	            return;
	        }
	        
	    	        
	    // 3. 게시글 상세조회
	        int boardId = Integer.parseInt(boardIdStr);
	        BoardDTO board = dao.selectView(boardId);
	        if (board == null || board.getBoardId() == 0) {
	            resp.sendRedirect(req.getContextPath() + "/controller/list.do");
	            return;
	        }
	        
	     // 4. 좋아요 수 조회 (메서드 있다고 가정)
		    int likeCount = dao.getLikeCount(boardId);
			req.setAttribute("likeCount", likeCount);
	        
	     /* 5. 댓글 목록 조회 (댓글 DAO 메서드가 있다고 가정)
	        List<CommentDTO> comments = dao.selectComments(boardId); */

	     /* 6. 해시태그 목록 조회 (메서드 있다고 가정)
	        List<String> hashtags = dao.selectHashtags(boardId);*/

	     // 7. 데이터 request 속성으로 저장
	        req.setAttribute("board", board);
	        /*req.setAttribute("comments", comments);
	        req.setAttribute("likeCount", likeCount);
	        req.setAttribute("hashtags", hashtags);*/

	     // 8. JSP로 포워드
	        req.getRequestDispatcher("/Board/view.jsp").forward(req, resp);

        // 9. DAO 연결 닫기
	        dao.close();
	    }

	    @Override
	    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	        doGet(req, resp);
	    }
		 
	 }
