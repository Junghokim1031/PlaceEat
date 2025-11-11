package com.placeeat.util;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DBConnPool {
    public Connection con;
    public Statement stmt;
    public PreparedStatement psmt;
    public ResultSet rs;

    // 기본 생성자
    public DBConnPool() {
        try {
            // 커넥션 풀(DataSource) 얻기
            Context initCtx = new InitialContext();
            Context ctx = (Context)initCtx.lookup("java:comp/env");
            DataSource source = (DataSource)ctx.lookup("jdbc/myoracle"); // context.xml에 설정된 name값

            // 커넥션 풀을 통해 연결 얻기
            con = source.getConnection();

            System.out.println("DB 커넥션 풀 연결 성공");
        }
        catch (Exception e) {
            System.out.println("DB 커넥션 풀 연결 실패");
            e.printStackTrace();
        }
    }

    // 연결 해제(자원 반납)
    public void close() {
        try {            
        	if (rs != null) {
                try { 
                	rs.close(); 
                } catch (Exception e) { 
                	System.out.println("rs close error");
                	e.printStackTrace(); 
                }
            }
            if (psmt != null) {
                try { 
                	psmt.close(); 
                } catch (Exception e) {
                	System.out.println("psmt close error");
                	e.printStackTrace(); 
                }
            }
            if (stmt != null) {
                try { 
                	stmt.close(); 
                } catch (Exception e) {
                	System.out.println("stmt close error");
                	e.printStackTrace(); 
                }
            }
            if (con != null) {
                try { 
                	con.close(); 
                } catch (Exception e) {
                	System.out.println("con close error");
                	e.printStackTrace(); 
                }
            }
            System.out.println("DB 커넥션 풀 자원 반납");
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}