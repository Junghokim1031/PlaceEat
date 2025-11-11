package com.placeeat.board.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.placeeat.utils.DBConnPool;

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
}
