package com.placeeat.board.controller;

import java.io.IOException;
import com.placeeat.board.dao.RestaurantDAO;
import com.placeeat.board.dao.RestaurantDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Restaurant/Insert.do")
public class RestaurantController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        RestaurantDTO dto = new RestaurantDTO();
        dto.setRestId(req.getParameter("restId"));
        dto.setRestName(req.getParameter("restName"));
        dto.setDescription(req.getParameter("description"));
        dto.setRestAddress(req.getParameter("restAddress"));
        dto.setPhone(req.getParameter("phone"));
        dto.setMainmenu(req.getParameter("mainmenu"));
        dto.setBoardId(Integer.parseInt(req.getParameter("boardId")));

        // 이미지 업로드 처리 시 파일명 설정 부분 추가 가능
        dto.setImgOfilename(null);
        dto.setImgSfilename(null);

        RestaurantDAO dao = new RestaurantDAO();
        dao.insertRestaurant(dto);
        dao.close();

        resp.sendRedirect(req.getContextPath() + "/Board/View.do?boardId=" + dto.getBoardId());
    }
}
