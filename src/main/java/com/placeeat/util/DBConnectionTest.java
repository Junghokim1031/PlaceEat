package com.placeeat.util;

import java.sql.Connection;

public class DBConnectionTest {
    public static void main(String[] args) {
        try (Connection conn = DBUtil.getConnection()) {
            if (conn != null) {
                System.out.println("✅ DB 연결 성공!");
            } else {
                System.out.println("❌ DB 연결 실패...");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
