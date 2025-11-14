package com.placeeat.board.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.placeeat.util.DBConnPool;

public class RestaurantDAO extends DBConnPool {

    public int insertRestaurant(RestaurantDTO dto) {
        int result = 0;
        String sql = "INSERT INTO restaurant_table "
                   + "(rest_id, rest_name, rest_adress, created_at, board_id) "
                   + "VALUES (restaurant_seq.NEXTVAL, ?, ?, SYSDATE, ?)";

        try {
            psmt = con.prepareStatement(sql);
            psmt.setString(1, dto.getRestName());
            psmt.setString(2, dto.getRestAddress());
            psmt.setInt(3, dto.getBoardId());
            result = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<RestaurantDTO> selectRestaurants(int boardId) {
        List<RestaurantDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM restaurant_table WHERE board_id = ? ORDER BY created_at DESC";

        try {
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, boardId);
            rs = psmt.executeQuery();
            while (rs.next()) {
                RestaurantDTO dto = new RestaurantDTO();
                dto.setRestId(rs.getString("rest_id"));
                dto.setRestName(rs.getString("rest_name"));
                dto.setRestAddress(rs.getString("rest_adress"));
                dto.setCreatedAt(rs.getDate("created_at"));
                dto.setBoardId(rs.getInt("board_id"));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * 게시글 수정 시 기존 맛집 삭제 후 새로 등록
     */
    public void updateRestaurants(int boardId, List<RestaurantDTO> newList) {
        try {
            // 기존 맛집 삭제
            String deleteSql = "DELETE FROM restaurant_table WHERE board_id = ?";
            psmt = con.prepareStatement(deleteSql);
            psmt.setInt(1, boardId);
            psmt.executeUpdate();
            psmt.close();

            // 새 맛집 등록
            String insertSql = "INSERT INTO restaurant_table "
                             + "(rest_id, rest_name, rest_adress, created_at, board_id) "
                             + "VALUES (restaurant_seq.NEXTVAL, ?, ?, SYSDATE, ?)";
            psmt = con.prepareStatement(insertSql);

            for (RestaurantDTO dto : newList) {
                psmt.setString(1, dto.getRestName());
                psmt.setString(2, dto.getRestAddress());
                psmt.setInt(3, boardId);
                psmt.addBatch();
            }

            psmt.executeBatch();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
