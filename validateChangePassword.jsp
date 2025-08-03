<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ include file="DBConnection.jsp" %>
<%
	String email=request.getParameter("email");
	String pass=request.getParameter("password");
	boolean isValid=false;
	String userType="";
	try{
		PreparedStatement ps=conn.prepareStatement("select * from users where email_id=?");
		ps.setString(1,email);
		ResultSet rs=ps.executeQuery();
		if(rs.next()){
			PreparedStatement ps1=conn.prepareStatement("Update users set password=? where email_id=?");
			ps1.setString(1,pass);
			ps1.setString(2,email);
			int i=ps1.executeUpdate();
			if(i>0){
				response.sendRedirect("login.jsp?msg1=passwordchanged");
			}else{
				response.sendRedirect("forgotPassword.jsp?error1=someerror");
			}
		}else{
			response.sendRedirect("forgotPassword.jsp?error=noemail");
		}
	}catch(Exception e){
		out.println("Login Error: "+e);
	}finally{
		conn.close();
	}
%>

