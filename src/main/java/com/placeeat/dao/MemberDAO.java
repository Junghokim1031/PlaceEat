package com.placeeat.dao;

import java.sql.*;
import com.placeeat.util.DBUtil;

public class MemberDAO {
    private static MemberDAO instance = new MemberDAO();
    public static MemberDAO getInstance() { return instance; }
    private MemberDAO() {}

    private Connection getConnection() throws Exception { return DBUtil.getConnection(); }

    // insert (회원가입) - 반환 int : 1 성공
    public int insertMember(MemberVO mVo) {
        int result = 0;
        String sql = "insert into member(userid, password, name, birth, gender, email, grade, reset_token) values(?, ?, ?, ?, ?, ?, ?, null)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, mVo.getUserid());
            pstmt.setString(2, mVo.getPassword());
            pstmt.setString(3, mVo.getName());
            pstmt.setString(4, mVo.getBirth());
            pstmt.setString(5, mVo.getGender());
            pstmt.setString(6, mVo.getEmail());
            pstmt.setString(7, mVo.getGrade());
            result = pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    // 아이디 중복 확인 (기존 메서드명 유지)
    public boolean isUserIdDuplicate(String userid) {
        String sql = "select userid from member where userid=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userid);
            try (ResultSet rs = pstmt.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); return true; }
    }

    // 이메일 중복
    public boolean isEmailDuplicate(String email) {
        String sql = "select email from member where email=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); return true; }
    }

    // 로그인 체크 (문자열 비교은 bcrypt를 적용했으면 변경 필요)
    public int userCheck(String userid, String pwdPlain) {
        String sql = "select password from member where userid=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userid);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                String hashed = rs.getString("password");
                // bcrypt 비교
                if (org.mindrot.jbcrypt.BCrypt.checkpw(pwdPlain, hashed)) return 1;
                else return 0;
            } else { return -1; }
        } catch (Exception e) { e.printStackTrace(); return -2; }
    }

    // getMember
    public MemberVO getMember(String userid) {
        MemberVO m = null;
        String sql = "select * from member where userid=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userid);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                m = new MemberVO();
                m.setUserid(rs.getString("userid"));
                m.setPassword(rs.getString("password"));
                m.setName(rs.getString("name"));
                m.setBirth(rs.getString("birth"));
                m.setGender(rs.getString("gender"));
                m.setEmail(rs.getString("email"));
                m.setGrade(rs.getString("grade"));
                m.setResetToken(rs.getString("reset_token"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return m;
    }

    // findId by name + birth
    public String findIdByNameBirth(String name, String birth) {
        String userId = null;
        String sql = "select userid from member where name=? and birth=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            pstmt.setString(2, birth);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) userId = rs.getString("userid");
        } catch (Exception e) { e.printStackTrace(); }
        return userId;
    }

    // find user by userid+name+email : 기존 시그니처 유지 (문자열 반환)
    public String findUserByIdNameEmail(String userid, String name, String email) {
        String resultId = null;
        String sql = "select userid from member where userid=? and name=? and email=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userid);
            pstmt.setString(2, name);
            pstmt.setString(3, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) resultId = rs.getString("userid");
        } catch (Exception e) { e.printStackTrace(); }
        return resultId;
    }

    // MemberVO 반환형도 제공 (호환용)
    public MemberVO findMemberByIdNameEmail(String userid, String name, String email) {
        MemberVO member = null;
        String sql = "select * from member where userid=? and name=? and email=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userid);
            pstmt.setString(2, name);
            pstmt.setString(3, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                member = new MemberVO();
                member.setUserid(rs.getString("userid"));
                member.setName(rs.getString("name"));
                member.setEmail(rs.getString("email"));
                member.setBirth(rs.getString("birth"));
                member.setResetToken(rs.getString("reset_token"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return member;
    }

    // save token
    public void saveResetToken(String userid, String token) {
        String sql = "update member set reset_token=? where userid=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, token);
            pstmt.setString(2, userid);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // find userid by token (string)
    public String findUserByToken(String token) {
        String userid = null;
        String sql = "select userid from member where reset_token=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, token);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) userid = rs.getString("userid");
        } catch (Exception e) { e.printStackTrace(); }
        return userid;
    }

    // find member by token (VO)
    public MemberVO findMemberByToken(String token) {
        MemberVO member = null;
        String sql = "select * from member where reset_token=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, token);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                member = new MemberVO();
                member.setUserid(rs.getString("userid"));
                member.setName(rs.getString("name"));
                member.setEmail(rs.getString("email"));
                member.setBirth(rs.getString("birth"));
                member.setResetToken(rs.getString("reset_token"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return member;
    }

    // update password (store hashed expected)
    public void updatePassword(String userid, String newPwHashed) {
        String sql = "update member set password=? where userid=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newPwHashed);
            pstmt.setString(2, userid);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // clear token
    public void clearResetToken(String userid) {
        String sql = "update member set reset_token=null where userid=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userid);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // get email
    public String getEmailByUserid(String userid) {
        String email = null;
        String sql = "select email from member where userid=?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userid);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) email = rs.getString("email");
        } catch (Exception e) { e.printStackTrace(); }
        return email;
    }
}
