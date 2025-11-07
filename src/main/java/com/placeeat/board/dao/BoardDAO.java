package com.placeeat.board.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.placeeat.util.DBConnPool;

public class BoardDAO extends DBConnPool {
	
	// 기본 생성자
	public BoardDAO() {
		super(); 
		// DBConnPool의 기본 생성자 호출. DBCP 연결.
	}
	
	
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
	
	
	
	//전체 게시글 수
	public int selectCount(Map<String,Object> map) {
		int totalCount = 0;
		String query = "SELECT COUNT(*) FROM board_table ";

		// 검색 조건이 있을 경우 WHERE절 추가. dynamic query.
		if (map.get("searchWord") != null && map.get("searchField") != null)
		{
			// searchField는 동적으로 넣고, searchWord는 바인딩 변수로 처리
			query += " WHERE " + map.get("searchField") + " LIKE ?";
		}

		try {
			psmt = con.prepareStatement(query);
			
			// 🚨 검색어가 있을 경우만 바인딩
			if (map.get("searchWord") != null) {
				psmt.setString(1, "%" + map.get("searchWord") + "%");
			}
			
			rs = psmt.executeQuery();

			if (rs.next()) {
				totalCount = rs.getInt(1); 
			}
		}
		catch (Exception e) {
			System.out.println("게시물 수 조회 중 예외 발생");
			e.printStackTrace();
        }
		
		return totalCount;
	}
	
	
	//페이징된 게시글 목록 조회
		// 검색 조건에 맞는 게시물 목록을 반환합니다(페이징 기능 지원).
	    public List<BoardDTO> selectListPage(Map<String,Object> map) {
	        List<BoardDTO> boardList = new ArrayList<BoardDTO>(); // 변수명 수정
	        String query = " "
	                     + "SELECT * FROM ( "
	                     + "    SELECT Tb.*, ROWNUM rNum FROM ( "
	                     + "        SELECT * FROM board_table "; // 테이블명 수정

	        // 🚨 검색 조건이 있을 경우 WHERE절 추가 (SQL Injection 방지)
	        if (map.get("searchWord") != null && map.get("searchField") != null)
	        {
	            query += " WHERE " + map.get("searchField") + " LIKE ?";
	        }

	        query += "        ORDER BY board_id DESC "
	               + "    ) Tb "
	               + " ) "
	               + " WHERE rNum BETWEEN ? AND ?";

	        try {
	            psmt = con.prepareStatement(query);
	            int paramIndex = 1;
	            
	            // 🚨 1단계: 검색어 바인딩
	            if (map.get("searchWord") != null) {
	                psmt.setString(paramIndex++, "%" + map.get("searchWord") + "%");
	            }

	            // 🚨 2단계: 페이징 시작/끝 값 바인딩
	            psmt.setInt(paramIndex++, Integer.parseInt(map.get("start").toString()));
	            psmt.setInt(paramIndex, Integer.parseInt(map.get("end").toString()));
	            
	            rs = psmt.executeQuery();

	            while (rs.next()) {
	            	BoardDTO dto = new BoardDTO();

	                // 🚨 DTO 메서드를 스네이크 표기법으로 사용하도록 수정
	                dto.setBoardId(rs.getInt("board_id"));
	                dto.setCreatedAt(rs.getDate("created_at"));
	                dto.setUpdatedAt(rs.getDate("updated_at"));
	                dto.setTitle(rs.getString("title"));
	                dto.setViewCount(rs.getInt("viewcount"));
	                dto.setContent(rs.getString("content"));
	                dto.setImgOfilename(rs.getString("img_ofilename"));
	                dto.setImgSfilename(rs.getString("img_sfilename"));
	                dto.setDetails(rs.getString("details"));
	                dto.setLatitude(rs.getDouble("latitude"));
	                dto.setLongitude(rs.getDouble("longitude"));
	                dto.setUserId(rs.getString("user_id"));
	                dto.setHashtagName(rs.getString("hashtag_name"));
	                dto.setLocationName(rs.getString("location_name"));

	                boardList.add(dto); 
	            }
	        }
	        catch (Exception e) {
	            System.out.println("게시물 조회 중 예외 발생");
	            e.printStackTrace();
	        }
	        return boardList;
	    }
	    
	    
	 // 추가 기능: 지역 목록 전체 조회
	    public List<String> selectAllLocations() {
	        List<String> locations = new ArrayList<>();
	        String sql = "SELECT location_name FROM location_table ORDER BY location_name ASC";

	        try {
	            psmt = con.prepareStatement(sql);
	            rs = psmt.executeQuery();
	            while (rs.next()) {
	                locations.add(rs.getString("location_name"));
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return locations;
	    }

	    // 추가 기능: 해시태그 목록 전체 조회
	    public List<String> selectAllHashtags() {
	        List<String> hashtags = new ArrayList<>();
	        String sql = "SELECT hashtag_name FROM hashtag_table ORDER BY hashtag_name ASC";

	        try {
	            psmt = con.prepareStatement(sql);
	            rs = psmt.executeQuery();
	            while (rs.next()) {
	                hashtags.add(rs.getString("hashtag_name"));
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return hashtags;
	    }
	    
	    
	 // ✅ 조회수 많은 게시물 상위 n개 조회 (Oracle 12c+)
	    public List<BoardDTO> selectTopViewedBoards(int limit) {
	        List<BoardDTO> boardList = new ArrayList<>();
	        String query = "SELECT * " +
	                       "FROM board_table " +
	                       "ORDER BY viewcount DESC " +
	                       "FETCH FIRST ? ROWS ONLY";  // ✅ 최신 오라클 문법

	        try {
	            psmt = con.prepareStatement(query);
	            psmt.setInt(1, limit);
	            rs = psmt.executeQuery();

	            while (rs.next()) {
	                BoardDTO dto = new BoardDTO();
	                dto.setBoardId(rs.getInt("board_id"));
	                dto.setCreatedAt(rs.getDate("created_at"));
	                dto.setUpdatedAt(rs.getDate("updated_at"));
	                dto.setTitle(rs.getString("title"));
	                dto.setViewCount(rs.getInt("viewcount"));
	                dto.setContent(rs.getString("content"));
	                dto.setImgOfilename(rs.getString("img_ofilename"));
	                dto.setImgSfilename(rs.getString("img_sfilename"));
	                dto.setDetails(rs.getString("details"));
	                dto.setLatitude(rs.getDouble("latitude"));
	                dto.setLongitude(rs.getDouble("longitude"));
	                dto.setUserId(rs.getString("user_id"));
	                dto.setHashtagName(rs.getString("hashtag_name"));
	                dto.setLocationName(rs.getString("location_name"));
	                boardList.add(dto);
	            }
	        } catch (Exception e) {
	            System.out.println("조회수 상위 게시글 조회 중 예외 발생");
	            e.printStackTrace();
	        }

	        return boardList;
	    }

	    
	    
	    
	  //좋아요 많은 상위 게시물 조회
	    public List<BoardDTO> selectTopLikedBoards(int limit) {
	        List<BoardDTO> boardList = new ArrayList<>();
	        String query = "SELECT b.*, COUNT(l.board_id) AS like_count " +
	                       "FROM board_table b LEFT JOIN boardlike_table l " +
	                       "ON b.board_id = l.board_id " +
	                       "GROUP BY b.board_id, b.created_at, b.updated_at, b.title, b.viewcount, " +
	                       "b.content, b.img_ofilename, b.img_sfilename, b.details, b.latitude, b.longitude, " +
	                       "b.user_id, b.hashtag_name, b.location_name " +
	                       "ORDER BY like_count DESC, b.board_id DESC " +
	                       "FETCH FIRST ? ROWS ONLY";

	        try {
	            psmt = con.prepareStatement(query);
	            psmt.setInt(1, limit);
	            rs = psmt.executeQuery();
	            
	            while (rs.next()) {
	                BoardDTO dto = new BoardDTO();
	                dto.setBoardId(rs.getInt("board_id"));
	                dto.setCreatedAt(rs.getDate("created_at"));
	                dto.setUpdatedAt(rs.getDate("updated_at"));
	                dto.setTitle(rs.getString("title"));
	                dto.setViewCount(rs.getInt("viewcount"));
	                dto.setContent(rs.getString("content"));
	                dto.setImgOfilename(rs.getString("img_ofilename"));
	                dto.setImgSfilename(rs.getString("img_sfilename"));
	                dto.setDetails(rs.getString("details"));
	                dto.setLatitude(rs.getDouble("latitude"));
	                dto.setLongitude(rs.getDouble("longitude"));
	                dto.setUserId(rs.getString("user_id"));
	                dto.setHashtagName(rs.getString("hashtag_name"));
	                dto.setLocationName(rs.getString("location_name"));
	                dto.setLikeCount(rs.getInt("like_count")); // DTO에 LikeCount 추가 필요
	                
	                boardList.add(dto);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return boardList;
	    }
	    
	    
	 // 최신 게시물 조회
	
	    public List<BoardDTO> selectLatestBoards(int limit) {
	        List<BoardDTO> boardList = new ArrayList<>();
	        String query = "SELECT * FROM board_table ORDER BY created_at DESC FETCH FIRST ? ROWS ONLY";

	        try {
	            psmt = con.prepareStatement(query);
	            psmt.setInt(1, limit);
	            rs = psmt.executeQuery();

	            while (rs.next()) {
	                BoardDTO dto = new BoardDTO();
	                dto.setBoardId(rs.getInt("board_id"));
	                dto.setCreatedAt(rs.getDate("created_at"));
	                dto.setUpdatedAt(rs.getDate("updated_at"));
	                dto.setTitle(rs.getString("title"));
	                dto.setViewCount(rs.getInt("viewcount"));
	                dto.setContent(rs.getString("content"));
	                dto.setImgOfilename(rs.getString("img_ofilename"));
	                dto.setImgSfilename(rs.getString("img_sfilename"));
	                dto.setDetails(rs.getString("details"));
	                dto.setLatitude(rs.getDouble("latitude"));
	                dto.setLongitude(rs.getDouble("longitude"));
	                dto.setUserId(rs.getString("user_id"));
	                dto.setHashtagName(rs.getString("hashtag_name"));
	                dto.setLocationName(rs.getString("location_name"));
	                boardList.add(dto);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return boardList;
	    }

	    
	    //메인 게시물
	    // 특정 사용자가 쓴 글의 총 개수를 반환합니다.
		public int selectCountByUser(String userId) {
		    int count = 0;
		    String sql = "SELECT COUNT(*) FROM board_table WHERE user_id = ?";
		    
		    try {
		    	psmt = con.prepareStatement(sql);
		    	psmt.setString(1, userId);
		        rs = psmt.executeQuery();
		        if (rs.next()) {
		            count = rs.getInt(1);
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    
		    return count;
		}
		
		 // 특정 사용자가 쓴 글의 총 개수를 반환합니다.
		public List<BoardDTO> selectListPageByUser(String userId, int start, int end) {
		    List<BoardDTO> boardList = new ArrayList<>();
		    String sql = "SELECT * FROM ( " +
		                 "  SELECT ROWNUM AS rnum, a.* FROM ( " +
		                 "    SELECT * FROM board_table WHERE user_id = ? ORDER BY created_at DESC " +
		                 "  ) a " +
		                 ") WHERE rnum BETWEEN ? AND ?";
		    
		    try {
		    	psmt = con.prepareStatement(sql);
		    	psmt.setString(1, userId);
		    	psmt.setInt(2, start);
		    	psmt.setInt(3, end);
		        rs = psmt.executeQuery();
		        
		        while (rs.next()) {
		            BoardDTO dto = new BoardDTO();
		            dto.setBoardId(rs.getInt("board_id"));
		            dto.setUserId(rs.getString("user_id"));
		            dto.setTitle(rs.getString("title"));
		            dto.setContent(rs.getString("content"));
		            dto.setImgSfilename(rs.getString("img_sfilename"));
		            dto.setImgOfilename(rs.getString("img_ofilename"));
		            dto.setCreatedAt(rs.getDate("created_at"));
		            boardList.add(dto);
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    
		    return boardList;
		    
		}

		
 /* ==============================================================게시물 상세보기=======================================================*/
		
		//게시물 상세보기
		
		//게시물 상세보기
	    public BoardDTO selectView(int boardId) {
	        BoardDTO dto = new BoardDTO();  // DTO 객체 생성
	        String query = "SELECT * FROM board_table WHERE board_id=?";  // 쿼리문 템플릿 준비
	        
	        try {
	            psmt = con.prepareStatement(query);  // 쿼리문 준비
	            psmt.setInt(1, boardId);  // 인파라미터 설정
	            rs = psmt.executeQuery();  // 쿼리문 실행

	            if (rs.next()) {  // 결과를 DTO 객체에 저장
	                 dto.setBoardId(rs.getInt("board_id"));
	                 dto.setCreatedAt(rs.getDate("created_at"));
	                 dto.setUpdatedAt(rs.getDate("updated_at"));
	                 dto.setTitle(rs.getString("title"));
	                 dto.setViewCount(rs.getInt("viewcount"));
	                 dto.setContent(rs.getString("content"));
	                 dto.setImgOfilename(rs.getString("img_ofilename"));
	                 dto.setImgSfilename(rs.getString("img_sfilename"));
	                 dto.setDetails(rs.getString("details"));
	                 dto.setLatitude(rs.getDouble("latitude"));
	                 dto.setLongitude(rs.getDouble("longitude"));
	                 dto.setUserId(rs.getString("user_id"));
	                 dto.setHashtagName(rs.getString("hashtag_name"));
	                 dto.setLocationName(rs.getString("location_name"));
	                 
	            	}
	    	    }
	    	    catch (Exception e) {
	    	        e.printStackTrace();
	    	        
	            } finally {
	                close();
	    	    }
	    	    return dto;  // 결과 반환
	    	}
	    
	    // 좋아요 수 조회
	    public int getLikeCount(int boardId) {
	    	int count = 0;
	        String query = "SELECT COUNT(*) AS cnt FROM boardlike_table WHERE board_id = ?";
	        try {
	        	psmt = con.prepareStatement(query);
	        	psmt.setInt(1, boardId);
	            rs = psmt.executeQuery();
	            if (rs.next()) {
	                return rs.getInt("cnt");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            
	        } finally {
	            close();
	        }
	        
	        return count;
	    }

	    // 좋아요 등록 (중복 체크 후)
	    public boolean insertLike(int boardId, String userId) {
	        if (checkLike(boardId, userId)) {
	            // 이미 좋아요 한 상태면 false 반환
	            return false;
	        }
	        String query = "INSERT INTO boardlike_table(board_id, user_id, regdate) VALUES (?, ?, SYSDATE())";
	        try {
	        	psmt = con.prepareStatement(query);
	        	psmt.setInt(1, boardId);
	        	psmt.setString(2, userId);
	            int affected = psmt.executeUpdate();
	            return affected > 0;
	        } catch (Exception e) {
	            e.printStackTrace();
	            return false;
	            
	        } finally {
	            close();
	        }
	    }

	    // 좋아요 중복 체크
	    public boolean checkLike(int boardId, String userId) {
	        String query = "SELECT 1 FROM boardlike_table WHERE board_id = ? AND user_id = ?";
	        try {
	        	psmt = con.prepareStatement(query);
	        	psmt.setInt(1, boardId);
	        	psmt.setString(2, userId);
	            rs = psmt.executeQuery();
	            return rs.next();
	        } catch (Exception e) {
	            e.printStackTrace();
	            return false;
	            
	        } finally {
	            close();
	        }
	    }
	    
	    // 좋아요 취소 
	    public boolean deleteLike(int boardId, String userId) {
	    	String query = "DELETE FROM boardlike_table WHERE board_id = ? AND user_id = ?";
	        try {
	        	psmt = con.prepareStatement(query);
	        	psmt.setInt(1, boardId);
	        	psmt.setString(2, userId);
	            int affected = psmt.executeUpdate();
	            return affected > 0;
	        } catch (Exception e) {
	            e.printStackTrace();
	            return false;
	            
	        } finally {
	            close();
	        }
	    }
		
}         

    /*    
     * =============================참고===================================================================================
     * 
     
      // 2. 댓글 목록 조회
    public List<CommentDTO> selectComments(int boardId) {
        List<CommentDTO> comments = new ArrayList<>();
        String sql = "SELECT commentId, boardId, userId, content, regdate FROM comments WHERE boardId = ? ORDER BY regdate DESC";
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, boardId);
            rs = ps.executeQuery();
            while (rs.next()) {
                CommentDTO comment = new CommentDTO();
                comment.setCommentId(rs.getInt("commentId"));
                comment.setBoardId(rs.getInt("boardId"));
                comment.setUserId(rs.getString("userId"));
                comment.setContent(rs.getString("content"));
                comment.setRegdate(rs.getTimestamp("regdate"));
                comments.add(comment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return comments;
    }

    // 3. 댓글 등록
    public boolean insertComment(int boardId, String userId, String content) {
        String sql = "INSERT INTO comments(boardId, userId, content, regdate) VALUES (?, ?, ?, NOW())";
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, boardId);
            ps.setString(2, userId);
            ps.setString(3, content);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

   

    // 5. 추천맛집 해시태그 조회 (예시 테이블명: hashtags)
    public List<String> selectHashtags(int boardId) {
        List<String> tags = new ArrayList<>();
        String sql = "SELECT tag FROM hashtags WHERE boardId = ?";
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, boardId);
            rs = ps.executeQuery();
            while (rs.next()) {
                tags.add(rs.getString("tag"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tags;
    }

    // 자원 반환
    public void close() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
      
      
      
     
    //글쓰기
    // 게시글 데이터를 받아 DB에 추가합니다(파일 업로드 지원).
    public int insertWrite(BoardDTO dto) {
        int result = 0;
        try {
            String query = "INSERT INTO mvcboard ( "
                         + " idx, name, title, content, ofile, sfile, pass) "
                         + " VALUES ( "
                         + " seq_board_num.NEXTVAL,?,?,?,?,?,?)";
            psmt = con.prepareStatement(query);
            psmt.setString(1, dto.getName());
            psmt.setString(2, dto.getTitle());
            psmt.setString(3, dto.getContent());
            psmt.setString(4, dto.getOfile());
            psmt.setString(5, dto.getSfile());
            psmt.setString(6, dto.getPass());
            result = psmt.executeUpdate();
        }
        catch (Exception e) {
            System.out.println("게시물 입력 중 예외 발생");
            e.printStackTrace();
        }
        return result;
    }
    
    
    // 다운로드 횟수를 1 증가시킵니다.
    public void downCountPlus(String idx) {
        String sql = "UPDATE mvcboard SET "
                + " downcount=downcount+1 "
                + " WHERE idx=? "; 
        try {
            psmt = con.prepareStatement(sql);
            psmt.setString(1, idx);
            psmt.executeUpdate();
        }
        catch (Exception e) {}
    }
    
    
       
    
    // 주어진 일련번호에 해당하는 게시물의 조회수를 1 증가시킵니다.
    public void updateVisitCount(String idx) {
        String query = "UPDATE mvcboard SET "
                     + " visitcount=visitcount+1 "
                     + " WHERE idx=?"; 
        try {
            psmt = con.prepareStatement(query);
            psmt.setString(1, idx);
            psmt.executeQuery();
        }
        catch (Exception e) {
            System.out.println("게시물 조회수 증가 중 예외 발생");
            e.printStackTrace();
        }
    }
    
    
    // 입력한 비밀번호가 지정한 일련번호의 게시물의 비밀번호와 일치하는지 확인합니다.
    public boolean confirmPassword(String pass, String idx) {
        boolean isCorr = true;
        try {
            String sql = "SELECT COUNT(*) FROM mvcboard WHERE pass=? AND idx=?";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, pass);
            psmt.setString(2, idx);
            rs = psmt.executeQuery();
            rs.next();
            if (rs.getInt(1) == 0) {
                isCorr = false;
            }
        }
        catch (Exception e) {
            isCorr = false;
            e.printStackTrace();
        }
        return isCorr;
    }
    
    
    // 지정한 일련번호의 게시물을 삭제합니다.
    public int deletePost(String idx) {
        int result = 0;
        try {
            String query = "DELETE FROM mvcboard WHERE idx=?";
            psmt = con.prepareStatement(query);
            psmt.setString(1, idx);
            result = psmt.executeUpdate();
        }
        catch (Exception e) {
            System.out.println("게시물 삭제 중 예외 발생");
            e.printStackTrace();
        }
        return result;
    }
    
    
    // 게시글 데이터를 받아 DB에 저장되어 있던 내용을 갱신합니다(파일 업로드 지원).
    public int updatePost(MVCBoardDTO dto) {
        int result = 0;
        try {
            // 쿼리문 템플릿 준비
            String query = "UPDATE mvcboard"
                         + " SET title=?, name=?, content=?, ofile=?, sfile=? "
                         + " WHERE idx=? and pass=?";

            // 쿼리문 준비
            psmt = con.prepareStatement(query);
            psmt.setString(1, dto.getTitle());
            psmt.setString(2, dto.getName());
            psmt.setString(3, dto.getContent());
            psmt.setString(4, dto.getOfile());
            psmt.setString(5, dto.getSfile());
            psmt.setString(6, dto.getIdx());
            psmt.setString(7, dto.getPass());

            // 쿼리문 실행
            result = psmt.executeUpdate();
        }
        catch (Exception e) {
            System.out.println("게시물 수정 중 예외 발생");
            e.printStackTrace();
        }
        return result;
    }
    
}*/