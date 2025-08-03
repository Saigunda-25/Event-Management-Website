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
		PreparedStatement ps=conn.prepareStatement("select * from users where email_id=? and password=?");
		ps.setString(1,email);
		ps.setString(2,pass);
		ResultSet rs=ps.executeQuery();
		if(rs.next()){
			userType=rs.getString("role");
			HttpSession sess=request.getSession(true);
			sess.setAttribute("email_id",email);
			sess.setAttribute("userType",userType);
			sess.setAttribute("user_id", rs.getInt("user_id"));
			sess.setMaxInactiveInterval(30*60);
			isValid=true;
		}
		if(isValid){
			if("admin".equalsIgnoreCase(userType)){
				response.sendRedirect("adminDashboard.jsp");
			}else{
				response.sendRedirect("mainHomeUserAdmin.jsp");
			}
		}else{
			response.sendRedirect("login.jsp?error=userType");
		}
	}catch(Exception e){
		out.println("Login Error: "+e);
	}finally{
		conn.close();
	}
%>

