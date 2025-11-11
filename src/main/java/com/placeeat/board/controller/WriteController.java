package com.placeeat.board.controller;

import java.io.IOException;

import com.placeeat.board.dao.BoardDAO;
import com.placeeat.board.dao.BoardDTO;
import com.placeeat.board.dao.RestaurantDAO;
import com.placeeat.board.dao.RestaurantDTO;
import com.placeeat.utils.FileUtil;
import com.placeeat.utils.JSFunction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/Board/Write.do")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 10)
public class WriteController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		BoardDAO dao = new BoardDAO();
		req.setAttribute("locationList", dao.selectLocations());
		req.setAttribute("hashtagList", dao.selectHashtags());
		dao.close();

		req.getRequestDispatcher("/Board/Write.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String saveDirectory = req.getServletContext().getRealPath("/Uploads");
		String originalFileName = "";

		try {
			originalFileName = FileUtil.uploadFile(req, saveDirectory);
		} catch (Exception e) {
			e.printStackTrace();
			JSFunction.alertLocation(resp, "파일 업로드 오류입니다.", "../Board/Write.do");
			return;
		}

		/* 실제 로그인 사용 시
        String userId = (String) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/Login.do");
            return;
        }*/
		// 게시글 DTO 생성
		BoardDTO dto = new BoardDTO();
		dto.setTitle(req.getParameter("title"));
		dto.setContent(req.getParameter("content"));
		dto.setDetails(req.getParameter("details"));
		dto.setUserId(req.getParameter("userId")); // 테스트용
		dto.setHashtagName(req.getParameter("hashtag_name"));
		dto.setLocationName(req.getParameter("location_name"));

		// 위도 / 경도
		try {
			dto.setLatitude(Double.parseDouble(req.getParameter("latitude")));
			dto.setLongitude(Double.parseDouble(req.getParameter("longitude")));
		} catch (NumberFormatException e) {
			dto.setLatitude(0);
			dto.setLongitude(0);
		}

		if (!originalFileName.isEmpty()) {
			String savedFileName = FileUtil.renameFile(saveDirectory, originalFileName);
			dto.setImgOfilename(originalFileName);
			dto.setImgSfilename(savedFileName);
		}

		// 게시글 저장
		BoardDAO dao = new BoardDAO();
		int boardId = dao.insertWrite(dto);
		dao.close();

		if (boardId <= 0) {
			JSFunction.alertLocation(resp, "게시글 등록 실패", "../Board/Write.do");
			return;
		}

		// 맛집 정보 등록
		String[] restNames = req.getParameterValues("rest_name");
		String[] restaddresses = req.getParameterValues("rest_address");
		System.out.println(restNames.length);
		System.out.println(restaddresses.length);
		if (restNames != null && restaddresses != null) {
			RestaurantDAO rdao = new RestaurantDAO();

			for (int i = 0; i < restNames.length && i < 5; i++) {
				String name = restNames[i];
				String addr = restaddresses[i];

				if (name != null && !name.trim().isEmpty() &&
				    addr != null && !addr.trim().isEmpty()) {

					RestaurantDTO r = new RestaurantDTO();
					r.setRestName(name.trim());
					r.setRestAddress(addr.trim());
					r.setBoardId(boardId);
					rdao.insertRestaurant(r);
				}
			}
			rdao.close();
		}

		resp.sendRedirect("../Board/List.do");
	}
}
