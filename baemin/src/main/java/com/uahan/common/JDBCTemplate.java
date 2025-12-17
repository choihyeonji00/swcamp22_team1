package com.uahan.common;

import java.io.IOException;
import java.sql.*;
import java.util.Properties;

/* 반복되는 JDBC 관련 코드를 미리 작성해서 Util용으로 사용할
 JDBCTemplate 클래스를 만들 수 있다.*/
public class JDBCTemplate {

  public static Connection getConnection() {
    Properties prop = new Properties();
    Connection con = null;
    try {
      prop.load(JDBCTemplate.class.getClassLoader().getResourceAsStream("jdbc-config.properties"));
      String url = prop.getProperty("url");
      String user = prop.getProperty("user");
      String password = prop.getProperty("password");

      Class.forName("com.mysql.cj.jdbc.Driver");
      con = DriverManager.getConnection(url, user, password);

      con.setAutoCommit(false);

    } catch (SQLException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
    return con;
  }

  /**
   * Connection을 닫는 메서드
   * - 메모리 누수 방지
   * - DBMS 연결 커넥션 제거
   * 
   * @param con
   */
  public static void close(Connection con) {
    try {
      if (con != null && !con.isClosed()) {
        con.close();
      }

    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }

  public static void close(Statement stmt) {
    try {
      if (stmt != null && !stmt.isClosed()) {
        stmt.close();
      }

    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }

  public static void close(ResultSet rset) {
    try {
      if (rset != null && !rset.isClosed()) {
        rset.close();
      }

    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }

  public static void commit(Connection con) {
    try {
      if (con != null && !con.isClosed()) {
        con.commit();
      }

    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }

  public static void rollback(Connection con) {
    try {
      if (con != null && !con.isClosed()) {
        con.rollback();
      }

    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }

}
