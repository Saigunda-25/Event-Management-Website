<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%
	Connection conn=null;
	String url=System.getenv("DB_URL");
	String user=System.getenv("DB_USER");
	String password=System.getenv("DB_PASS");
	if(url==null){
		out.println("Database URL Not set");
		return;
	}
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn=DriverManager.getConnection(url,user,password);
	}catch(Exception e){
		out.println("DB Connection error"+e.getMessage());
	}
%>