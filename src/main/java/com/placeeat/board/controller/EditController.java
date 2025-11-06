package com.placeeat.board.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.placeeat.board.dao.BoardDAO;
import com.placeeat.board.dao.BoardDTO;
import com.placeeat.board.dao.RestaurantDTO;
import com.placeeat.utils.FileUtil;
import com.placeeat.utils.JSFunction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/board/edit.do")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 2,
    maxRequestSize = 1024 * 1024 * 10
)
public class EditController extends HttpServlet {

    // ✅ Edit.jsp 화면 이동 (기존 DB 데이터 불러오기 + 드롭다운 목록 제공)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int boardId = Integer.parseInt(request.getParameter("boardId"));

        BoardDAO dao = new BoardDAO();
        BoardDTO dto = dao.selectView(boardId); // 게시글
        List<RestaurantDTO> restaurantLists = dao.selectRestaurantList(boardId); // 맛집 목록
        dao.close();

        // ✅ locationLists 생성
        List<Map<String,Object>> locationLists = new ArrayList<>();
        String[] locations = {
            "서울특별시","부산광역시","대구광역시","인천광역시","광주광역시","대전광역시","울산광역시","세종특별자치시",
            "경기도","강원특별자치도","충청북도","충청남도","전라북도","전라남도","경상북도","경상남도","제주특별자치도"
        };
        for (String name : locations) {
            Map<String,Object> m = new HashMap<>();
            m.put("locationName", name);
            locationLists.add(m);
        }

        // ✅ hashtagLists 생성
        List<Map<String,Object>> hashtagLists = new ArrayList<>();
        String[] hashtags = {"#한식","#브런치","#디저트","#치킨","#회","#파스타","#비건","#카페","#가성비","#분위기좋은"};
        for (String tag : hashtags) {
            Map<String,Object> m = new HashMap<>();
            m.put("hashtagName", tag);
            hashtagLists.add(m);
        }

        // ✅ request에 전달
        request.setAttribute("dto", dto);
        request.setAttribute("restaurantLists", restaurantLists);
        request.setAttribute("locationLists", locationLists);
        request.setAttribute("hashtagLists", hashtagLists);

        request.getRequestDispatcher("/board/Edit.jsp").forward(request, response);
    }

    // ✅ 수정 처리
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int boardId = Integer.parseInt(request.getParameter("boardId"));

        BoardDTO dto = new BoardDTO();
        dto.setBoardId(boardId);
        dto.setTitle(request.getParameter("title"));
        dto.setContent(request.getParameter("content"));
        dto.setLocationName(request.getParameter("locationSelect"));
        dto.setHashtagName(request.getParameter("hashtagSelect"));
        dto.setLatitude(Double.parseDouble(request.getParameter("latitude")));
        dto.setLongitude(Double.parseDouble(request.getParameter("longitude")));

        // ✅ details[] 배열 처리
        String[] detailsArr = request.getParameterValues("details[]");
        if (detailsArr != null) {
            StringBuilder sb = new StringBuilder();
            for (String d : detailsArr) {
                if (d != null && !d.trim().isEmpty()) {
                    sb.append(d.trim()).append("\n");
                }
            }
            dto.setDetails(sb.toString());
        }

        // ✅ 파일 업로드 (없으면 기존 유지)
        String saveDir = request.getServletContext().getRealPath("/img");
        String newFile = FileUtil.uploadFile(request, saveDir);

        if (newFile != null && !newFile.isEmpty()) {
            String renamed = FileUtil.renameFile(saveDir, newFile);
            dto.setImgOfilename(newFile);
            dto.setImgSfilename(renamed);
        } else {
            dto.setImgOfilename(request.getParameter("prevOfile"));
            dto.setImgSfilename(request.getParameter("prevSfile"));
        }

        // ✅ 맛집 배열 처리
        String[] restNames = request.getParameterValues("restName[]");
        String[] restAddrs = request.getParameterValues("restAddress[]");
        List<RestaurantDTO> restList = new ArrayList<>();

        if (restNames != null) {
            for (int i = 0; i < restNames.length; i++) {
                if (!restNames[i].trim().isEmpty()) {
                    RestaurantDTO r = new RestaurantDTO();
                    r.setBoardId(boardId);
                    r.setRestName(restNames[i]);
                    r.setRestAddress(restAddrs[i]);
                    restList.add(r);
                }
            }
        }

        // ✅ DB update
        BoardDAO dao = new BoardDAO();
        int result = dao.updateWrite(dto, restList);
        dao.close();

        if (result == 1) {
            response.sendRedirect("../board/view.do?boardId=" + boardId);
        } else {
            JSFunction.alertBack(response, "수정 실패했습니다.");
        }
    }
}
