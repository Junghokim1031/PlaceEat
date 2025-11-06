package com.placeeat.board.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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

@WebServlet("/board/write.do")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 2,    // 2MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class WriterController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/board/Write.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ✅ BoardDTO 설정
        BoardDTO dto = new BoardDTO();
        dto.setTitle(request.getParameter("title"));
        dto.setContent(request.getParameter("content"));

        // ✅ details[] 배열 → 문자열 합치기
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

        // ✅ 콤보박스 선택
        dto.setLocationName(request.getParameter("locationSelect"));
        dto.setHashtagName(request.getParameter("hashtagSelect"));

        // ✅ 좌표 설정
        dto.setLatitude(Double.parseDouble(request.getParameter("latitude")));
        dto.setLongitude(Double.parseDouble(request.getParameter("longitude")));

        // ✅ 이미지 업로드
        String saveDir = request.getServletContext().getRealPath("/img");
        String newFile = FileUtil.uploadFile(request, saveDir);

        if (newFile != null && !newFile.isEmpty()) {
            String renamed = FileUtil.renameFile(saveDir, newFile);
            dto.setImgOfilename(newFile);
            dto.setImgSfilename(renamed);
        }

        // ✅ 맛집 리스트 처리
        String[] restNames = request.getParameterValues("restName[]");
        String[] restAddrs = request.getParameterValues("restAddress[]");

        List<RestaurantDTO> restList = new ArrayList<>();
        if (restNames != null) {
            for (int i = 0; i < restNames.length; i++) {
                if (restNames[i].trim().isEmpty()) continue;

                RestaurantDTO r = new RestaurantDTO();
                r.setRestName(restNames[i]);
                r.setRestAddress(restAddrs[i]);
                restList.add(r);
            }
        }

        // ✅ DB 저장
        BoardDAO dao = new BoardDAO();
        int result = dao.insertWrite(dto, restList);
        dao.close();

        // ✅ success → list.do 이동
        if (result == 1) {
            response.sendRedirect("../board/list.do");
        } else {
            JSFunction.alertLocation(response, "글 등록 실패!", "../board/write.do");
        }
    }
}
