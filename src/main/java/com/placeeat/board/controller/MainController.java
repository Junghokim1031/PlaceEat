package com.placeeat.board.controller;

import java.io.IOException;
import java.util.List;

import com.placeeat.board.dao.BoardDAO;
import com.placeeat.board.dao.BoardDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ListController
 */
@WebServlet("/Board/Main.do")
public class MainController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        BoardDAO dao = new BoardDAO();     	  	               
        
        // 조회수 많은 게시물 3개
        	List<BoardDTO> topViewedBoards  = dao.selectTopViewedBoards(3);
        	req.setAttribute("topViewedBoards", topViewedBoards);             
	        
	   // 좋아요 많은 게시물 4개
        	List<BoardDTO> topLikedBoards = dao.selectTopLikedBoards(4);
        	req.setAttribute("topLikedBoards", topLikedBoards);

	     // 최신 게시물 5개
	        List<BoardDTO> latestBoards = dao.selectLatestBoards(5);
	        req.setAttribute("latestBoards", latestBoards);
	        
	        dao.close();

	        // main.jsp로 포워딩
	        req.getRequestDispatcher("/Board/Main.jsp").forward(req, resp);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(req, resp);
	}

}