package com.placeeat.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:xe";
    private static final String USER = "pe_psc";
    private static final String PASSWORD = "psc1234";

    static {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
