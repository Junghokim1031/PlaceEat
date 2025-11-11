package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class MemberDAO {

    public int insertMember(MemberDTO dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            // DB 연결
            conn = DBConnection.getConnection();

            // SQL 문
            String sql = "INSERT INTO member(userid, name, email, password, phone) VALUES (?, ?, ?, ?, ?)";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getUserid());
            pstmt.setString(2, dto.getName());
            pstmt.setString(3, dto.getEmail());
            pstmt.setString(4, dto.getPassword());
            pstmt.setString(5, dto.getPhone());

            // 실행
            result = pstmt.executeUpdate();
            System.out.println("✅ 회원정보 저장 성공!");

        } catch (SQLException e) {
            System.out.println("❌ 회원정보 저장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // 자원 해제
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return result;
    }
}
