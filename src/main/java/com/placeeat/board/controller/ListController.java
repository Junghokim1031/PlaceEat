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

/**
 * Servlet implementation class ListController
 */
@WebServlet("/Board/List.do")
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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        BoardDAO dao = new BoardDAO();
        
        try {
            // 뷰에 전달할 매개변수 저장용 맵 생성
            Map<String, Object> map = new HashMap<String, Object>();

            // ======================================
            // 1) 텍스트 검색 조건 (제목/내용)
            // ======================================
            String searchField = req.getParameter("searchField");
            String searchWord = req.getParameter("searchWord");
            if (searchWord != null && !searchWord.isEmpty()) {
                map.put("searchField", searchField);
                map.put("searchWord", searchWord);
            }
            
            // ======================================
            // 2) 위치 필터 (단일 선택)
            // ======================================
            String locationName = req.getParameter("locationName");
            if (locationName != null && !locationName.isEmpty()) {
                map.put("locationName", locationName);  // ✅ ADD THIS
            }
            
            // ======================================
            // 3) 해시태그 필터 (다중 선택)
            // ======================================
            String[] hashtagNames = req.getParameterValues("hashtagName");  // ✅ ADD THIS
            if (hashtagNames != null && hashtagNames.length > 0) {
                map.put("hashtagNames", hashtagNames);  // ✅ ADD THIS
            }
            
            int totalCount = dao.selectCount(map);  // 게시물 개수

            /* 페이지 처리 start */
            int pageSize = 6;
            int blockPage = 5;
            
            int pageNum = 1;
            String pageTemp = req.getParameter("pageNum");
            if (pageTemp != null && !pageTemp.equals(""))
                pageNum = Integer.parseInt(pageTemp);

            int start = (pageNum - 1) * pageSize + 1;
            int end = pageNum * pageSize;
            
            map.put("start", start);
            map.put("end", end);
            /* 페이지 처리 end */
 
            //멤버 등급 조회 
            HttpSession session = req.getSession();
   		 	MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
   		 	if(loginUser != null) {
   		 		String grade = loginUser.getGrade();   
   	            req.setAttribute("grade", grade);		 		
   		 	}
   		 	
            // 게시물 목록 조회
            List<BoardDTO> boardLists = dao.selectListPage(map);
            
            // 지역 목록 조회
            List<String> locationList = dao.selectAllLocations();
            
            // 해시태그 목록 조회
            List<String> hashtagList = dao.selectAllHashtags();

            // 뷰에 전달할 매개변수 추가
            String pagingImg = BoardPage.pagingStr(totalCount, pageSize,
                    blockPage, pageNum, req.getContextPath() + "/Board/List.do","pageNum");
            map.put("pagingImg", pagingImg);
            map.put("totalCount", totalCount);
            map.put("pageSize", pageSize);
            map.put("pageNum", pageNum);
            
            // 전달할 데이터를 request 영역에 저장
            req.setAttribute("boardLists", boardLists);
            req.setAttribute("map", map);
            req.setAttribute("locationName", locationList);
            req.setAttribute("hashtagName", hashtagList);
            dao.close();
            
            req.getRequestDispatcher("/Board/List.jsp").forward(req, resp);
            
        } catch (Exception e) {
            System.out.println("ListController Failure");
            e.printStackTrace();
        }
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}