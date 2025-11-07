package com.placeeat.board.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.placeeat.board.dao.BoardDAO;
import com.placeeat.board.dao.BoardDTO;
import com.placeeat.util.BoardPage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/controller/mypage.do")
public class MyPageController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public MyPageController() {
        super();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 세션에서 로그인한 사용자 정보 가져오기
        HttpSession session = req.getSession();
        
        //임시 테스트 용 _로그인창이랑 연동시 지우기
        if (session.getAttribute("userId")==null) {
        	session.setAttribute("userId", "user01"); // DB에 존재하는 더미 user_id 테스트 후 삭제
        	System.out.println("테스트용 userId 세션 생성됨: user01"); //테스트 후 삭제
        }
        
        // 서버에서 로그인 인증되면 mypage 띄우고, 로그인 안했으면 로그인 페이지로
        String userId = (String) session.getAttribute("userId"); 

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp"); // 로그인 안했으면 로그인 페이지로
            return;
        }

        BoardDAO dao = new BoardDAO();
        Map<String, Object> map = new HashMap<>();

        // **게시물 개수**
        int totalCount = dao.selectCountByUser(userId);

        // 페이지 처리
        int pageSize = 8; // 한 페이지당 출력할 게시물 수
        int blockPage = 5; // 한 블럭당 출력할 페이지 수

        int pageNum = 1; // 기본값
        String pageTemp = req.getParameter("pageNum");
        if (pageTemp != null && !pageTemp.equals("")) {
            pageNum = Integer.parseInt(pageTemp);
        }

        int start = (pageNum - 1) * pageSize + 1;
        int end = pageNum * pageSize;

        // **사용자 글 목록 조회**
        List<BoardDTO> boardLists = dao.selectListPageByUser(userId, start, end);
        dao.close();

        // 페이지 네비게이션 HTML
        String pagingImg = BoardPage.pagingStr(totalCount, pageSize, blockPage, pageNum,
                req.getContextPath() + "/controller/mypage.do");

        // request에 전달
        map.put("pagingImg", pagingImg);
        map.put("totalCount", totalCount);
        map.put("pageSize", pageSize);
        map.put("pageNum", pageNum);

        req.setAttribute("boardLists", boardLists);
        req.setAttribute("map", map);

        req.getRequestDispatcher("/Board/mypage.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}