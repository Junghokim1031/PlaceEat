package com.placeeat.board.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.placeeat.board.dao.BoardDAO;
import com.placeeat.board.dao.BoardDTO;
import com.placeeat.board.dao.RestaurantDAO;
import com.placeeat.board.dao.RestaurantDTO;
import com.placeeat.dao.MemberVO;
import com.placeeat.util.FileUtil;
import com.placeeat.util.JSFunction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/Board/Edit.do")
@MultipartConfig(maxFileSize = 1024*1024*10, maxRequestSize = 1024*1024*10)
public class EditController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 수정 페이지 진입(GET)
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check if user is logged in
        MemberVO loginUser = (MemberVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            JSFunction.alertLocation(resp, "로그인이 필요합니다.", "../Member/Login.jsp");
            return;
        }

        String boardIdStr = req.getParameter("boardId");
        if (boardIdStr == null || boardIdStr.trim().isEmpty()) {
            resp.sendRedirect("../Board/List.do");
            return;
        }

        int boardId = Integer.parseInt(boardIdStr);

        // 게시글 정보 불러오기
        BoardDAO dao = new BoardDAO();
        BoardDTO dto = dao.selectView(boardId);
        dao.close();

        if (dto == null) {
            JSFunction.alertBack(resp, "게시글을 찾을 수 없습니다.");
            return;
        }

        // Check if current user is the author
        if (!loginUser.getUserid().equals(dto.getUserId())) {
            JSFunction.alertBack(resp, "수정 권한이 없습니다.");
            return;
        }
        
        // Add dropdown options
        BoardDAO boardDAO = new BoardDAO();
        List<String> locations = boardDAO.selectAllLocations(); // You need this method
        List<String> hashtags = boardDAO.selectAllHashtags();   // You need this method
        boardDAO.close();

        req.setAttribute("locationName", locations);
        req.setAttribute("hashtagName", hashtags);


        // 맛집 리스트 불러오기
        RestaurantDAO rdao = new RestaurantDAO();
        List<RestaurantDTO> restaurantLists = rdao.selectRestaurants(boardId);
        rdao.close();

        req.setAttribute("board", dto);
        req.setAttribute("restaurants", restaurantLists);
        req.getRequestDispatcher("/Board/Edit.jsp").forward(req, resp);
    }

    // 수정 및 삭제 처리(POST)
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("mode");
        int boardId = Integer.parseInt(req.getParameter("boardId"));

     // --------------------------
     // 삭제 처리
     // --------------------------
     if ("delete".equals(action)) {
         MemberVO loginUser = (MemberVO) req.getSession().getAttribute("loginUser");
         if (loginUser == null) {
             JSFunction.alertLocation(resp, "로그인이 필요합니다.", "../Member/Login.jsp");
             return;
         }

         BoardDAO dao = new BoardDAO();
         BoardDTO dto = dao.selectView(boardId);

         if (dto == null || !loginUser.getUserid().equals(dto.getUserId())) {
             dao.close();
             JSFunction.alertBack(resp, "삭제 권한이 없습니다.");
             return;
         }

         int result = dao.deleteBoard(boardId);
         dao.close();

         if (result > 0) {
             JSFunction.alertLocation(resp, "게시글이 삭제되었습니다.", "../Board/List.do");
         } else {
             JSFunction.alertBack(resp, "게시글 삭제 실패");
         }
         return;
     }

        // --------------------------
        // 수정 처리
        // --------------------------
        String saveDir = req.getServletContext().getRealPath("/Uploads");

        // 파일 업로드 처리
        String originalFileName = "";
        try {
            Part part = req.getPart("ofile");
            if (part != null && part.getSize() > 0) {
                originalFileName = FileUtil.uploadFile(req, saveDir);
            }
        } catch (Exception e) {
            e.printStackTrace();
            JSFunction.alertLocation(resp, "파일 업로드 실패", "../Board/Edit.do?boardId=" + boardId);
            return;
        }

        // BoardDTO 세팅
        BoardDTO dto = new BoardDTO();
        dto.setBoardId(boardId);
        dto.setTitle(req.getParameter("title"));
        dto.setContent(req.getParameter("content"));
        dto.setDetails(req.getParameter("details"));
        dto.setHashtagName(req.getParameter("hashtagSelect"));
        dto.setLocationName(req.getParameter("locationSelect"));
        MemberVO loginUser = (MemberVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            JSFunction.alertLocation(resp, "로그인이 필요합니다.", "../Member/Login.jsp");
            return;
        }
        dto.setUserId(loginUser.getUserid());

        try {
            dto.setLatitude(Double.parseDouble(req.getParameter("latitude")));
            dto.setLongitude(Double.parseDouble(req.getParameter("longitude")));
        } catch (NumberFormatException e) {
            dto.setLatitude(0);
            dto.setLongitude(0);
        }

        String existingImgO = req.getParameter("existingImgO");
        String existingImgS = req.getParameter("existingImgS");

        if (!originalFileName.isEmpty()) {
            String savedFileName = FileUtil.renameFile(saveDir, originalFileName);
            dto.setImgOfilename(originalFileName);
            dto.setImgSfilename(savedFileName);
        } else {
            dto.setImgOfilename(existingImgO);
            dto.setImgSfilename(existingImgS);
        }

        // 게시글 수정
        BoardDAO dao = new BoardDAO();
        int result = dao.updateBoard(dto);
        dao.close();

        if (result <= 0) {
            JSFunction.alertLocation(resp, "게시글 수정 실패", "../Board/Edit.do?boardId=" + boardId);
            return;
        }

        // 맛집 수정 처리
        String[] restNames = req.getParameterValues("restName[]");
        String[] restAddresses = req.getParameterValues("restAddress[]");

        if (restNames != null && restAddresses != null) {
            List<RestaurantDTO> restaurants = new ArrayList<>();
            for (int i = 0; i < restNames.length; i++) {
                if (restNames[i] != null && !restNames[i].trim().isEmpty()) {
                    RestaurantDTO r = new RestaurantDTO();
                    r.setRestName(restNames[i].trim());
                    r.setRestAddress(restAddresses[i].trim());
                    r.setBoardId(boardId);
                    restaurants.add(r);
                }
            }

            RestaurantDAO rdao = new RestaurantDAO();
            rdao.updateRestaurants(boardId, restaurants);
            rdao.close();
        }

        // 완료 후 이동
        JSFunction.alertLocation(resp, "게시글 수정이 완료되었습니다.",
                req.getContextPath() + "/Board/View.do?boardId=" + boardId);
    }
}
