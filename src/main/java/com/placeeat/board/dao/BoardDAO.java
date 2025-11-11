package com.placeeat.board.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.placeeat.util.DBConnPool;

public class BoardDAO extends DBConnPool {
	
	// 기본 생성자
	public BoardDAO() {
		super(); 
		// DBConnPool의 기본 생성자 호출. DBCP 연결.
	}
	
	//글쓰기
    // 게시글 데이터를 받아 DB에 추가합니다(파일 업로드 지원).
	// ✅ 글쓰기 (board + restaurant) 최종본
	//글쓰기
    // 게시글 데이터를 받아 DB에 추가합니다(파일 업로드 지원).
   // ✅ 글쓰기 (board + restaurant) 최종본
   public int insertWrite(BoardDTO dto) {
        int boardId = 0;  // 11월 11일 수정
        try {
            // 임시: USER_ID가 null이면 테스트용 ID 1 사용
            if(dto.getUserId() == null || dto.getUserId().isEmpty()) {
                
            }
            
            
            // 11-11일 추가 //
            
            String seqSql = "SELECT board_seq.NEXTVAL FROM dual";
            psmt = con.prepareStatement(seqSql);
            rs = psmt.executeQuery();
            if (rs.next()) {
                boardId = rs.getInt(1); // 생성될 boardId
            }
            rs.close();
            psmt.close();
            
            // 1) board 테이블 Insert -11월 11일 수정
            String boardSql = "INSERT INTO board_table "
                    + "VALUES (?, SYSDATE, SYSDATE, ?, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            psmt = con.prepareStatement(boardSql);
            psmt.setInt(1, boardId);
            psmt.setString(2, dto.getTitle());
            psmt.setString(3, dto.getContent());
            psmt.setString(4, dto.getImgOfilename());
            psmt.setString(5, dto.getImgSfilename());
            psmt.setString(6, dto.getDetails());
            psmt.setDouble(7, dto.getLatitude());
            psmt.setDouble(8, dto.getLongitude());
            psmt.setString(9, dto.getUserId());
            psmt.setString(10, dto.getHashtagName());
            psmt.setString(11, dto.getLocationName());

            psmt.executeUpdate();
            psmt.close();
            
        }
        catch (Exception e) {
            System.out.println("게시물 입력 중 예외 발생");
            e.printStackTrace();
            boardId = 0; // 오류 시 0 반환
        }
        return boardId; 
      }

	
		//글 수정
		//글 삭제
	
/* ==============================================================게시물 상세보기=======================================================*/
	
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
	    	        
	    	    }finally {
	  	          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }
	    	    return dto;  // 결과 반환
	    	}
        
	
	
	/* ==============================================================게시물 조휘(게시판 리스트 페이지)=======================================================*/
	
	//전체 게시글 수
    public int selectCount(Map<String, Object> map) {
        int totalCount = 0;
        String query = "SELECT COUNT(*) FROM board_table WHERE 1=1 ";

        // Add location filter
        if (map.get("locationName") != null) {
            query += " AND location_name = ? ";
        }
        
        // Add hashtag filter (ANY of the selected hashtags)
        String[] hashtagNames = (String[]) map.get("hashtagNames");
        if (hashtagNames != null && hashtagNames.length > 0) {
            query += " AND hashtag_name IN (";
            for (int i = 0; i < hashtagNames.length; i++) {
                query += "?";
                if (i < hashtagNames.length - 1) query += ",";
            }
            query += ") ";
        }
        
        // Add text search filter
        if (map.get("searchWord") != null && map.get("searchField") != null) {
            String field = (String) map.get("searchField");
            if (!field.equals("title") && !field.equals("content")) {
                field = "title";
            }
            query += " AND " + field + " LIKE ? ";
        }

        try {
            psmt = con.prepareStatement(query);
            int paramIndex = 1;
            
            // Bind location
            if (map.get("locationName") != null) {
                psmt.setString(paramIndex++, (String) map.get("locationName"));
            }
            
            // Bind hashtags
            if (hashtagNames != null && hashtagNames.length > 0) {
                for (String hashtag : hashtagNames) {
                    psmt.setString(paramIndex++, hashtag);
                }
            }
            
            
            // Bind search word
            if (map.get("searchWord") != null) {
                psmt.setString(paramIndex++, "%" + map.get("searchWord") + "%");
            	}
            
            rs = psmt.executeQuery();
            if (rs.next()) {
                totalCount = rs.getInt(1);
            	}
	        } catch (Exception e) {
	            System.out.println("게시물 수 조회 중 예외 발생");
	            e.printStackTrace();
	        } finally {
	            try {
	                if (rs != null) rs.close();
	                if (psmt != null) psmt.close();
	            } catch (SQLException e) {}
	        }
	        
	        return totalCount;
	    }
		
			
		//페이징된 게시글 목록 조회
			// 검색 조건에 맞는 게시물 목록을 반환합니다(페이징 기능 지원).
	  	public List<BoardDTO> selectListPage(Map<String, Object> map) {
	      List<BoardDTO> boardList = new ArrayList<>();
	      
	      String query = "SELECT * FROM ( "
	                   + "    SELECT Tb.*, ROWNUM rNum FROM ( "
	                   + "        SELECT * FROM board_table WHERE 1=1 ";
	
	      // Add location filter
	      if (map.get("locationName") != null) {
	          query += " AND location_name = ? ";
	      }
	      
	      // Add hashtag filter
	      String[] hashtagNames = (String[]) map.get("hashtagNames");
	      if (hashtagNames != null && hashtagNames.length > 0) {
	          query += " AND hashtag_name IN (";
	          for (int i = 0; i < hashtagNames.length; i++) {
	              query += "?";
	              if (i < hashtagNames.length - 1) query += ",";
	          }
	          query += ") ";
	      }
	      
	      // Add text search filter
	      if (map.get("searchWord") != null && map.get("searchField") != null) {
	          String field = (String) map.get("searchField");
	          if (!field.equals("title") && !field.equals("content")) {
	              field = "title";
	          }
	          query += " AND " + field + " LIKE ? ";
	      }
	
	      query += "        ORDER BY board_id DESC "
	             + "    ) Tb "
	             + " ) "
	             + " WHERE rNum BETWEEN ? AND ?";
	
	      try {
	          psmt = con.prepareStatement(query);
	          int paramIndex = 1;
	          
	          // Bind location
	          if (map.get("locationName") != null) {
	              psmt.setString(paramIndex++, (String) map.get("locationName"));
	          }
	          
	          // Bind hashtags
	          if (hashtagNames != null && hashtagNames.length > 0) {
	              for (String hashtag : hashtagNames) {
	                  psmt.setString(paramIndex++, hashtag);
	              }
	          }
	          
	          // Bind search word
	          if (map.get("searchWord") != null) {
	              psmt.setString(paramIndex++, "%" + map.get("searchWord") + "%");
	          }
	          
	          // Bind pagination
	          psmt.setInt(paramIndex++, Integer.parseInt(map.get("start").toString()));
	          psmt.setInt(paramIndex, Integer.parseInt(map.get("end").toString()));
	          
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
	              String details = rs.getString("details");
	              dto.setDetails(details != null ? details : "");
	              dto.setLatitude(rs.getDouble("latitude"));
	              dto.setLongitude(rs.getDouble("longitude"));
	              dto.setUserId(rs.getString("user_id"));
	              dto.setHashtagName(rs.getString("hashtag_name"));
	              dto.setLocationName(rs.getString("location_name"));
	
	              boardList.add(dto);
	          }
	      } catch (Exception e) {
	          System.out.println("게시물 조회 중 예외 발생");
	          e.printStackTrace();
	      } finally {
	          try {
	              if (rs != null) rs.close();
	              if (psmt != null) psmt.close();
	          } catch (SQLException e) {}
	      }
	      
	      return boardList;
	  }
 	
		
		// 지역 목록 조회 (location_table)
	    public List<Map<String, Object>> selectLocations() {
	        List<Map<String, Object>> list = new ArrayList<>();
	        String query = "SELECT location_name FROM location_table ORDER BY location_name ASC";
	
	        try {
	            psmt = con.prepareStatement(query);
	            rs = psmt.executeQuery();
	
	            while (rs.next()) {
	                Map<String, Object> map = new HashMap<>();
	                map.put("locationName", rs.getString("location_name"));
	                list.add(map);
	            }
	        } catch (Exception e) {
	            System.out.println("지역 목록 조회 중 예외 발생");
	            e.printStackTrace();
	        } finally {
		          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }
	
	        return list;
	    }

	    // 해시태그 목록 조회 (hashtag_table)
	    public List<Map<String, Object>> selectHashtags() {
	        List<Map<String, Object>> list = new ArrayList<>();
	        String query = "SELECT hashtag_name FROM hashtag_table ORDER BY hashtag_name ASC";
	
	        try {
	            psmt = con.prepareStatement(query);
	            rs = psmt.executeQuery();
	
	            while (rs.next()) {
	                Map<String, Object> map = new HashMap<>();
	                map.put("hashtagName", rs.getString("hashtag_name"));
	                list.add(map);
	            }
	        } catch (Exception e) {
	            System.out.println("해시태그 목록 조회 중 예외 발생");
	            e.printStackTrace();
	        } finally {
		          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }
	
	        return list;
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
	        }finally {
		          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
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
	        }finally {
		          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }
	        return hashtags;
	    }
	    
	    
	    /* ==============================================================게시물 조회 끝=======================================================*/
	    
	    
	    
//===================================================================메인 검색용=============================================================//	    
	    
	 // 메인에서 필요: 조회수 많은 게시물 상위 n개 조회 (Oracle 12c+) ok
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
	        }finally {
		          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }

	        return boardList;
	    }

	    	    
	    
	  // 메인에서 필요 좋아요 많은 상위 게시물 조회 ok
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
	        }finally {
		          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }

	        return boardList;
	    }
	    
	    
	 // 최신 게시물 조회 (메인에서 필요)
	
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
	        }finally {
		          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }

	        return boardList;
	    }

	    
	  //===================================================================메인 검색용 끝=============================================================//	    
	    
	  
	  //===================================================================마이 페이지=============================================================//	      
	    
	  
	    // 마이페이지
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
		    }finally {
		          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
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
		    }finally {
		          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }
		    
		    return boardList;
		    
		}


//===================================================================마이 페이지 끝=============================================================//	
 

	    
   /* ==============================================================좋아요 부분======================================================*/
		
	    /**
	     * 특정 사용자가 특정 게시글에 좋아요를 눌렀는지 확인합니다.
	     * @return 좋아요를 눌렀으면 true, 아니면 false
	     */
	    public boolean hasUserLiked(int boardId, String userId) {
	        boolean result = false;
	        // ORA-00904 방지를 위해 컬럼명은 DB에 저장된 실제 이름(대문자)으로 가정하고 사용합니다.
	        String sql = "SELECT 1 FROM boardlike_table WHERE BOARD_ID = ? AND USER_ID = ?";

	        try {
	            psmt = con.prepareStatement(sql);
	            psmt.setInt(1, boardId);
	            psmt.setString(2, userId);
	            rs = psmt.executeQuery();

	            if (rs.next()) {
	                result = true; // 레코드가 존재하면 좋아요 누른 상태
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
		          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }
	        return result;
	    }
	    
	    // 좋아요 추가 (사용자가 좋아요 버튼 클릭 시)
	    /**
	     * 좋아요 기록을 추가합니다. (이미 좋아요를 눌렀는지 확인 후 호출되어야 함)
	     * @return 성공 시 1, 실패 시 0
	     */
	    public int addLike(int boardId, String userId) {
	        int result = 0;
	        
	        // boardlike_seq.NEXTVAL을 사용하여 ORA-00001 (PK 중복) 오류 방지
	        String insertSql = "INSERT INTO boardlike_table (LIKE_NUMBER, BOARD_ID, USER_ID) VALUES (boardlike_seq.NEXTVAL, ?, ?)";
	               
	        try {
	            psmt = con.prepareStatement(insertSql);
	            psmt.setInt(1, boardId);
	            psmt.setString(2, userId);
	            result = psmt.executeUpdate(); // 1이 반환되면 성공

	        } catch (SQLException e) {
	            e.printStackTrace();
	            
	        } finally {
		          try {
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }

	        return result;
	    }
	    
	 // 좋아요 취소
	    /**
	     * 좋아요 기록을 삭제합니다.
	     * @return 성공 시 1, 실패 시 0
	     */
	    public int removeLike(int boardId, String userId) {
	        int result = 0;
	        // ORA-00904 방지를 위해 컬럼명은 DB에 저장된 실제 이름(대문자)으로 가정하고 사용합니다.
	        String deleteSql = "DELETE FROM boardlike_table WHERE BOARD_ID = ? AND USER_ID = ?";
	        
	        try {
	            psmt = con.prepareStatement(deleteSql);
	            psmt.setInt(1, boardId);
	            psmt.setString(2, userId);
	            result = psmt.executeUpdate();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
		          try {
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }
	        return result;
	    }
	    
	 // 특정 게시글 좋아요 수 조회
	    /**
	     * 특정 게시글의 좋아요 수를 boardlike_table에서 직접 계산하여 조회합니다.
	     * @return 좋아요 수
	     */
	    public int getLikeCount(int boardId) {
	        int count = 0;
	        // ORA-00904 방지를 위해 컬럼명은 DB에 저장된 실제 이름(대문자)으로 가정하고 사용합니다.
	        String sql = "SELECT COUNT(*) AS cnt FROM boardlike_table WHERE BOARD_ID = ?";
	        
	        try {
	            psmt = con.prepareStatement(sql);
	            psmt.setInt(1, boardId);
	            rs = psmt.executeQuery();
	            if (rs.next()) {
	                count = rs.getInt("cnt"); // 별칭(Alias) cnt 사용
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
		          try {
		              if (rs != null) rs.close();
		              if (psmt != null) psmt.close();
		          } catch (SQLException e) {}
		      }
	        return count;
	    }    
	 	    
}
