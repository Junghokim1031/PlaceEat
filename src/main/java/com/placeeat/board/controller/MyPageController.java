package com.placeeat.board.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.placeeat.board.dao.BoardDAO;
import com.placeeat.board.dao.BoardDTO;
import com.placeeat.dao.MemberVO;
import com.placeeat.util.BoardPage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Member/Mypage.do")
public class MyPageController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public MyPageController() {
        super();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 세션에서 로그인한 사용자 정보 가져오기
        HttpSession session = req.getSession();
        
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        String userId = loginUser.getUserid();

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/Login.jsp"); // 로그인 안했으면 로그인 페이지로
            return;
        }

        BoardDAO dao = new BoardDAO();
        Map<String, Object> map = new HashMap<>();

        // **게시물 개수**
        int totalCount = dao.selectCountByUser(userId);
        int likedCount = dao.countLikedBoards(userId);
        int commentCount = dao.countCommentedBoards(userId);

        // 페이지 처리
        int pageSize = 8; // 한 페이지당 출력할 게시물 수
        int blockPage = 5; // 한 블럭당 출력할 페이지 수

        int pageNum = 1; // 기본값
        String pageTemp = req.getParameter("pageNum");
        if (pageTemp != null && !pageTemp.equals("")) {
            pageNum = Integer.parseInt(pageTemp);
        }
        
        int likedPageNum = 1;
        String likedTemp = req.getParameter("likedPageNum");
        if (likedTemp != null && !likedTemp.equals("")) {
        	likedPageNum = Integer.parseInt(likedTemp);
        }
        	
        int commentPageNum = 1;
        String commentTemp = req.getParameter("commentPageNum");
        if (commentTemp != null && !commentTemp.equals("")) {
        	commentPageNum = Integer.parseInt(commentTemp);
        }

        int start = (pageNum - 1) * pageSize + 1;
        int end = pageNum * pageSize;
        
        int likedStart = (likedPageNum - 1) * pageSize + 1;
        int likedEnd = likedPageNum * pageSize;

        int commentStart = (commentPageNum - 1) * pageSize + 1;
        int commentEnd = commentPageNum * pageSize;

        // **사용자 글 목록 조회**
        List<BoardDTO> boardLists = dao.selectListPageByUser(userId, start, end);
        
        // **좋아요 글 목록 조회**
        List<BoardDTO> likedLists = dao.selectLikedBoards(userId, likedStart, likedEnd);
        
        // **댓글 작성 글 목록 조회**
        List<BoardDTO> commentedLists = dao.selectCommentedBoards(userId, commentStart, commentEnd);
        dao.close();

        // 페이지 네비게이션 HTML
        String pagingImg = BoardPage.pagingStr(totalCount, pageSize, blockPage, pageNum,
                req.getContextPath() + "/Member/Mypage.do","pageNum");
        
        // 좋아요 페이징
        String likedPaging = BoardPage.pagingStr(likedCount, pageSize, blockPage, likedPageNum,
                req.getContextPath() + "/Member/Mypage.do", "likedPageNum");

        // 댓글 페이징
        String commentPaging = BoardPage.pagingStr(commentCount, pageSize, blockPage, commentPageNum,
                req.getContextPath() + "/Member/Mypage.do", "commentPageNum");
        
        dao.close();
        
        // request에 전달
        map.put("pagingImg", pagingImg);
        map.put("likedPaging", likedPaging);
        map.put("commentPaging", commentPaging);
        map.put("totalCount", totalCount);
        map.put("pageSize", pageSize);
        map.put("pageNum", pageNum);


        req.setAttribute("boardLists", boardLists);
        req.setAttribute("likedLists", likedLists);
        req.setAttribute("commentedLists", commentedLists);
        req.setAttribute("map", map);

        req.getRequestDispatcher("/Member/MyPage.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}