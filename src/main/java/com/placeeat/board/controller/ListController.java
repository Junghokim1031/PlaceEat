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

/**
 * Servlet implementation class ListController
 */
@WebServlet("/controller/list.do")
public class ListController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ListController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		 // DAO 생성
	       BoardDAO dao = new BoardDAO();

	        // 뷰에 전달할 매개변수 저장용 맵 생성
	        Map<String, Object> map = new HashMap<String, Object>();

	        String searchField = req.getParameter("searchField");
	        String searchWord = req.getParameter("searchWord");
	        if (searchWord != null) {
	            // 쿼리스트링으로 전달받은 매개변수 중 검색어가 있다면 map에 저장
	            map.put("searchField", searchField);
	            map.put("searchWord", searchWord);
	        }
	        
	     
	        
	        int totalCount = dao.selectCount(map);  // 게시물 개수

	        /* 페이지 처리 start */
	        /* int pageSize = 10; // 한 페이지당 출력할 게시물 수 					*/
	        int pageSize = 6; // 한 페이지당 출력할 게시물 수
	        int blockPage = 5; // 한 블럭당 출력할 페이지 수
	        
	        
	        // 현재 페이지 확인
	        int pageNum = 1;  // 기본값
	        String pageTemp = req.getParameter("pageNum");
	        if (pageTemp != null && !pageTemp.equals(""))
	            pageNum = Integer.parseInt(pageTemp); // 요청받은 페이지로 수정

	        // 목록에 출력할 게시물 범위 계산
	        int start = (pageNum - 1) * pageSize + 1;  // 첫 게시물 번호
	        int end = pageNum * pageSize; // 마지막 게시물 번호
	        
	        map.put("start", start);
	        map.put("end", end);
	        /* 페이지 처리 end */

	        //게시물 목록 초회
	        List<BoardDTO> boardLists = dao.selectListPage(map);  // 게시물 목록 받기
	        
	        // 지역 목록 조회
	        List<String> locationList = dao.selectAllLocations();
	        
	        //해시테그 목록 조회
	        List<String> hashtagList = dao.selectAllHashtags();
	        
	        

	        // 뷰에 전달할 매개변수 추가
	        String pagingImg = BoardPage.pagingStr(totalCount, pageSize,
	                blockPage, pageNum, req.getContextPath() + "/controller/list.do");  // 바로가기 영역 HTML 문자열
	        map.put("pagingImg", pagingImg);
	        map.put("totalCount", totalCount);
	        map.put("pageSize", pageSize);
	        map.put("pageNum", pageNum);
	        
	        
	        
	        // 전달할 데이터를 request 영역에 저장 후 List.jsp로 포워드
	        req.setAttribute("boardLists", boardLists);
	        req.setAttribute("map", map);
	        req.setAttribute("locationList", locationList);
	        req.setAttribute("hashtagList", hashtagList);
	        req.getRequestDispatcher("/Board/list.jsp").forward(req, resp);
	        
	        dao.close(); // DB 연결 닫기
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}