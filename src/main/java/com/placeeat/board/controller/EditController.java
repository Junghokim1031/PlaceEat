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

@WebServlet("/board/edit.do")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 2,   // 2MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class EditController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public EditController() { super(); }

    // ✅ Edit.jsp로 이동 (기존 데이터 불러오기)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int boardId = Integer.parseInt(request.getParameter("boardId"));
        BoardDAO dao = new BoardDAO();
        BoardDTO dto = dao.selectView(boardId);
        List<RestaurantDTO> restList = dao.selectRestaurantList(boardId);
        dao.close();

        request.setAttribute("dto", dto);
        request.setAttribute("restList", restList);

        request.getRequestDispatcher("/board/Edit.jsp").forward(request, response);
    }

    // ✅ 수정/삭제 처리
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        int boardId = Integer.parseInt(request.getParameter("boardId"));

        BoardDAO dao = new BoardDAO();

        // ✅ 삭제 처리
        if ("delete".equals(action)) {

            // 기존 썸네일 이미지 삭제
            FileUtil.deleteFile(request, "/img", request.getParameter("prevSfile"));

            int result = dao.deleteWrite(boardId); // ✅ board + restaurant 삭제
            dao.close();

            if (result == 1) {
            	response.sendRedirect("../board/list.do");
            }
            else JSFunction.alertBack(response, "삭제 실패했습니다.");

            return;
        }

        // ✅ 수정 처리
        BoardDTO dto = new BoardDTO();
        dto.setBoardId(boardId);
        dto.setTitle(request.getParameter("title"));
        dto.setContent(request.getParameter("content"));
        dto.setDetails(request.getParameter("details"));
        dto.setHashtagName(request.getParameter("hashtagName"));
        dto.setLocationName(request.getParameter("locationName"));

        // ✅ 파일 업로드 처리
        String saveDir = request.getServletContext().getRealPath("/img");
        String newFile = FileUtil.uploadFile(request, saveDir); // input name="ofile"

        if (newFile != null && !newFile.equals("")) {
            String renamed = FileUtil.renameFile(saveDir, newFile);
            dto.setImgOfilename(newFile);
            dto.setImgSfilename(renamed);

            // 이전 파일 삭제
            FileUtil.deleteFile(request, "/img", request.getParameter("prevSfile"));
        } else {
            dto.setImgOfilename(request.getParameter("prevOfile"));
            dto.setImgSfilename(request.getParameter("prevSfile"));
        }

        // ✅ 맛집 수정 처리
        String[] restNames = request.getParameterValues("restName[]");
        String[] restAddrs = request.getParameterValues("restAddress[]");

        List<RestaurantDTO> restList = new ArrayList<>();

        if (restNames != null) {
            for (int i = 0; i < restNames.length; i++) {

                if (!restNames[i].trim().isEmpty()) {
                    RestaurantDTO r = new RestaurantDTO();
                    r.setBoardId(boardId);  // ✅ 반드시 포함
                    r.setRestName(restNames[i]);
                    r.setRestAddress(restAddrs[i]);
                    restList.add(r);
                }
            }
        }

        // ✅ DAO 실행 (board + restaurant UPDATE 트랜잭션)
        int result = dao.updateWrite(dto, restList);
        dao.close();

        if (result == 1) {
            response.sendRedirect("../board/view.do?boardId=" + boardId);
        } else {
            JSFunction.alertBack(response, "수정 실패했습니다.");
        }
    }
}
