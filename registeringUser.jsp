<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ include file="DBConnection.jsp" %>
<%
	String name=request.getParameter("name");
	String email=request.getParameter("email");
	String pass=request.getParameter("password");
	String userType="user";
		try{
			PreparedStatement ps=conn.prepareStatement("Select * from users where email_id=?");
			ps.setString(1,email);
			ResultSet rs=ps.executeQuery();
			if(rs.next()){
				String errormsg="Account Already Exists";
				response.sendRedirect("register.jsp?error=errormsg");
			}else{
				PreparedStatement ps1=conn.prepareStatement("Insert into users(name,email_id,password,role) values (?,?,?,?)");
				ps1.setString(1,name);
				ps1.setString(2,email);
				ps1.setString(3, pass);
				ps1.setString(4,userType);
				int i=ps1.executeUpdate();
				if(i>0){
					response.sendRedirect("login.jsp?msg=registered");
				}else{
					out.println("<p style='color:red;'>Registration Failed Try again Later</p>");
				}
			}
			
		}catch(Exception e){
			out.println("Registration Error: "+e);
		}finally{
			conn.close();
		}
%>