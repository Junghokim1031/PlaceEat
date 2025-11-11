package com.placeeat.board.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.placeeat.utils.DBConnPool;

public class CommentDAO extends DBConnPool {

    // 댓글 목록 조회
    public List<CommentDTO> selectComments(int boardId) {
        List<CommentDTO> list = new ArrayList<>();
        String sql = "SELECT comment_id, content, user_id, created_at "
                   + "FROM comment_table WHERE board_id = ? ORDER BY comment_id DESC";

        try {
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, boardId);
            rs = psmt.executeQuery();

            while (rs.next()) {
                CommentDTO dto = new CommentDTO();
                dto.setCommentId(rs.getInt("comment_id"));
                dto.setContent(rs.getString("content"));
                dto.setUserId(rs.getString("user_id"));
                dto.setCreatedAt(rs.getDate("created_at"));
                dto.setBoardId(boardId);
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 댓글 추가
    public int insertComment(CommentDTO dto) {
        int result = 0;
        String sql = "INSERT INTO comment_table (comment_id, content, created_at, user_id, board_id) "
                   + "VALUES (comment_seq.NEXTVAL, ?, SYSDATE, ?, ?)";

        try {
            psmt = con.prepareStatement(sql);
            psmt.setString(1, dto.getContent());
            psmt.setString(2, dto.getUserId());
            psmt.setInt(3, dto.getBoardId());
            result = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // 댓글 삭제
    public int deleteComment(int commentId, String userId) {
        int result = 0;
        String sql = "DELETE FROM comment_table WHERE comment_id = ? AND user_id = ?";
        try {
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, commentId);
            psmt.setString(2, userId);
            result = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}
