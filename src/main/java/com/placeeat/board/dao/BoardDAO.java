package com.placeeat.board.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.placeeat.utils.DBConnPool;

public class BoardDAO extends DBConnPool {

	// 기본 생성자
	public BoardDAO() {
		// DBConnPool의 기본 생성자 호출. DBCP 연결
		super();
	}
	
	// ✅ 게시글 목록 + 페이징 + 검색 + 해시태그 + 지역 필터 모두 적용
	public List<BoardDTO> selectList(Map<String, Object> map) {
		List<BoardDTO> boardList = new ArrayList<>();

		String query = "SELECT * FROM ("
				+ " SELECT Tb.*, ROWNUM rNum FROM ("
				+ " SELECT * FROM board WHERE 1=1 ";

		// 검색
		if (map.get("searchWord") != null && !map.get("searchWord").equals("")) {
			query += " AND " + map.get("searchField") + " LIKE '%" + map.get("searchWord") + "%' ";
		}

		// 지역 필터
		if (map.get("location") != null && !map.get("location").equals("")) {
			query += " AND location_name = '" + map.get("location") + "' ";
		}

		// 해시태그 필터
		@SuppressWarnings("unchecked")
		List<String> hashtags = (List<String>) map.get("hashtags");
		if (hashtags != null && !hashtags.isEmpty()) {
			query += " AND (";
			for (int i = 0; i < hashtags.size(); i++) {
				query += " hashtag_name LIKE '%" + hashtags.get(i) + "%' ";
				if (i < hashtags.size() - 1) {
					query += " OR ";
				}
			}
			query += ")";
		}

		query += " ORDER BY board_id DESC"
				+ " ) Tb"
				+ " ) WHERE rNum BETWEEN ? AND ?";

		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, (int) map.get("start"));
			psmt.setInt(2, (int) map.get("end"));
			rs = psmt.executeQuery();

			while (rs.next()) {
				BoardDTO dto = new BoardDTO();

				dto.setBoardId(rs.getInt("board_id"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setViewCount(rs.getInt("viewcount"));
				dto.setImgOfilename(rs.getString("img_ofilename"));
				dto.setImgSfilename(rs.getString("img_sfilename"));
				dto.setDetails(rs.getString("details"));
				dto.setLatitude(rs.getDouble("latitude"));
				dto.setLongitude(rs.getDouble("longitude"));
				dto.setHashtagName(rs.getString("hashtag_name"));
				dto.setLocationName(rs.getString("location_name"));
				dto.setCreatedAt(rs.getDate("created_at"));

				boardList.add(dto);
			}
		} catch (Exception e) {
			System.out.println("selectList() 오류");
			e.printStackTrace();
		}
		return boardList;
	}
	
    // ✅ 전체 글 개수 조회 (검색 + 해시태그 + 지역 조건 반영)
 	public int selectCount(Map<String, Object> map) {
 		int totalCount = 0;

 		try {
 			String query = "SELECT COUNT(*) FROM board WHERE 1=1 ";

 			// 검색 필터
 			if (map.get("searchWord") != null && !map.get("searchWord").equals("")) {
 				query += " AND " + map.get("searchField") + " LIKE '%" + map.get("searchWord") + "%' ";
 			}

 			// 지역 필터
 			if (map.get("location") != null && !map.get("location").equals("")) {
 				query += " AND location_name = '" + map.get("location") + "' ";
 			}

 			// 해시태그 다중 필터
 			@SuppressWarnings("unchecked")
 			List<String> hashtags = (List<String>) map.get("hashtags");
 			if (hashtags != null && !hashtags.isEmpty()) {
 				query += " AND (";
 				for (int i = 0; i < hashtags.size(); i++) {
 					query += " hashtag_name LIKE '%" + hashtags.get(i) + "%' ";
 					if (i < hashtags.size() - 1) {
 						query += " OR ";
 					}
 				}
 				query += ")";
 			}

 			psmt = con.prepareStatement(query);
 			rs = psmt.executeQuery();
 			rs.next();
 			totalCount = rs.getInt(1);

 		} catch (Exception e) {
 			System.out.println("selectCount() 오류");
 			e.printStackTrace();
 		}
 		return totalCount;
 	}
 	
 	// try { con.rollback(); } ~  : board insert 성공 → restaurant insert 실패 시 rollback됨
 // ✅ 글쓰기 (board + restaurant) 최종본
 	public int insertWrite(BoardDTO dto, List<RestaurantDTO> restList) {
 	    int result = 0;

 	    try {
 	        con.setAutoCommit(false); // 트랜잭션 시작

 	        // 1) board 테이블 Insert
 	        String boardSql = "INSERT INTO board (board_id, title, content, viewcount, img_ofilename, img_sfilename, "
 	                + "details, latitude, longitude, hashtag_name, location_name, created_at, updated_at) "
 	                + "VALUES (board_seq.NEXTVAL, ?, ?, 0, ?, ?, ?, ?, ?, ?, ?, SYSDATE, SYSDATE)";

 	        psmt = con.prepareStatement(boardSql);
 	        psmt.setString(1, dto.getTitle());
 	        psmt.setString(2, dto.getContent());
 	        psmt.setString(3, dto.getImgOfilename());
 	        psmt.setString(4, dto.getImgSfilename());
 	        psmt.setString(5, dto.getDetails());
 	        psmt.setDouble(6, dto.getLatitude());
 	        psmt.setDouble(7, dto.getLongitude());
 	        psmt.setString(8, dto.getHashtagName());
 	        psmt.setString(9, dto.getLocationName());

 	        result = psmt.executeUpdate();

 	        if (result == 1) {

 	            // 2) 방금 Insert된 board_id 가져오기
 	            stmt = con.createStatement();
 	            rs = stmt.executeQuery("SELECT board_seq.CURRVAL FROM dual");

 	            int boardId = 0;
 	            if (rs.next()) boardId = rs.getInt(1);

 	            // 3) restaurant 테이블 Insert (여러 개)
 	            if (restList != null && !restList.isEmpty()) {

 	                String restSql = "INSERT INTO restaurant (board_id, rest_name, rest_address) VALUES (?, ?, ?)";
 	                psmt = con.prepareStatement(restSql);

 	                for (RestaurantDTO r : restList) {
 	                    if (r.getRestName() == null || r.getRestName().trim().isEmpty()) continue;

 	                    psmt.setInt(1, boardId);
 	                    psmt.setString(2, r.getRestName().trim());
 	                    psmt.setString(3, r.getRestAddress().trim());
 	                    psmt.addBatch();
 	                }

 	                psmt.executeBatch(); // ✅ executeBatch 사용으로 성능 향상
 	            }

 	            // 4) 모든 INSERT 성공 시 commit
 	            con.commit();
 	        }

 	    } catch (Exception e) {
 	        System.out.println("[ERROR] insertWrite() → rollback()");
 	        e.printStackTrace();
 	        try { con.rollback(); } catch (Exception ex) { ex.printStackTrace(); }

 	    } finally {
 	        try { con.setAutoCommit(true); } catch (Exception ex) {}
 	    }

 	    return result;
 	}
	
	//조회수 1증가
    public void updateVisitCount(int boardId) {
    	String sql = "UPDATE board SET "
				   + " viewcount = viewcount + 1 "
				   + " WHERE board_id = ?";
    	try {
    		psmt = con.prepareStatement(sql);
    		psmt.setInt(1, boardId);
    		psmt.executeUpdate();
    	}catch (Exception e) {
    		System.out.println("조회수 증가 중 예외 발생");
    		e.printStackTrace();
    	}
    }
    
    // ✅ 게시글 + 맛집 삭제 (트랜잭션 적용)
    public int deleteWrite(int boardId) {
        int result = 0;

        try {
            con.setAutoCommit(false);

            // 1) restaurant 삭제
            String deleteRestSql = "DELETE FROM restaurant WHERE board_id=?";
            psmt = con.prepareStatement(deleteRestSql);
            psmt.setInt(1, boardId);
            psmt.executeUpdate();

            // 2) board 삭제
            String deleteBoardSql = "DELETE FROM board WHERE board_id=?";
            psmt = con.prepareStatement(deleteBoardSql);
            psmt.setInt(1, boardId);
            result = psmt.executeUpdate();

            con.commit();
        } catch (Exception e) {
            System.out.println("[ERROR] deleteWrite() → rollback()");
            e.printStackTrace();
            try { con.rollback(); } catch (Exception ex) {}
        } finally {
            try { con.setAutoCommit(true); } catch (Exception ex) {}
        }

        return result;
    }
    
    // ✅ 해당 게시글의 맛집 목록 조회
    public List<RestaurantDTO> selectRestaurantList(int boardId) {
        List<RestaurantDTO> list = new ArrayList<>();

        String sql = "SELECT * FROM restaurant WHERE board_id = ?";

        try {
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, boardId);
            rs = psmt.executeQuery();

            while (rs.next()) {
                RestaurantDTO r = new RestaurantDTO();
                r.setBoardId(boardId);
                r.setRestName(rs.getString("rest_name"));
                r.setRestAddress(rs.getString("rest_address"));
                list.add(r);
            }
        } catch (Exception e) {
            System.out.println("selectRestaurantList() 오류");
            e.printStackTrace();
        }
        return list;
    }

    
    // ✅ 게시글 수정 + 맛집 수정 (트랜잭션)
    public int updateWrite(BoardDTO dto, List<RestaurantDTO> restList) {
        int result = 0;

        try {
            con.setAutoCommit(false);

            // 1) 게시글 수정
            String updateBoardSql = "UPDATE board SET title=?, content=?, details=?, hashtag_name=?, location_name=?, img_ofilename=?, img_sfilename=?, updated_at=? WHERE board_id=?";
            psmt = con.prepareStatement(updateBoardSql);
            psmt.setString(1, dto.getTitle());
            psmt.setString(2, dto.getContent());
            psmt.setString(3, dto.getDetails());
            psmt.setString(4, dto.getHashtagName());
            psmt.setString(5, dto.getLocationName());
            psmt.setString(6, dto.getImgOfilename());
            psmt.setString(7, dto.getImgSfilename());
            psmt.setDate(8, dto.getUpdatedAt());
            psmt.setInt(9, dto.getBoardId());
            psmt.executeUpdate();

            // 2) 기존 맛집 전체 삭제
            psmt = con.prepareStatement("DELETE FROM restaurant WHERE board_id=?");
            psmt.setInt(1, dto.getBoardId());
            psmt.executeUpdate();

            // 3) 새 맛집 리스트 삽입
            String insertRestSql = "INSERT INTO restaurant (board_id, rest_name, rest_address) VALUES (?, ?, ?)";
            psmt = con.prepareStatement(insertRestSql);
            for (RestaurantDTO r : restList) {
                psmt.setInt(1, r.getBoardId());
                psmt.setString(2, r.getRestName());
                psmt.setString(3, r.getRestAddress());
                psmt.addBatch();
            }
            psmt.executeBatch();

            con.commit();
            result = 1;

        } catch (Exception e) {
            System.out.println("[ERROR] updateWrite() rollback()");
            e.printStackTrace();
            try { con.rollback(); } catch (Exception ex) {}
        } finally {
            try { con.setAutoCommit(true); } catch (Exception ex) {}
        }

        return result;
    }


    // ✅ 게시글 상세 조회
    public BoardDTO selectView(int boardId) {
        BoardDTO dto = null;
        
        String sql = "SELECT * FROM board WHERE board_id = ?";
        
        try {
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, boardId);
            rs = psmt.executeQuery();
            
            if (rs.next()) {
                dto = new BoardDTO();
                dto.setBoardId(rs.getInt("board_id"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setViewCount(rs.getInt("viewcount"));
                dto.setImgOfilename(rs.getString("img_ofilename"));
                dto.setImgSfilename(rs.getString("img_sfilename"));
                dto.setDetails(rs.getString("details"));
                dto.setLatitude(rs.getDouble("latitude"));
                dto.setLongitude(rs.getDouble("longitude"));
                dto.setHashtagName(rs.getString("hashtag_name"));
                dto.setLocationName(rs.getString("location_name"));
                dto.setCreatedAt(rs.getDate("created_at"));
                dto.setUpdatedAt(rs.getDate("updated_at"));
            }
        } catch (Exception e) {
            System.out.println("selectView() 오류");
            e.printStackTrace();
        }
        return dto;
    }

    
}
