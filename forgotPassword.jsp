<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Password Change Page</title>
<link rel="stylesheet" href="loginstyle.css">
</head>
<body>
<div class="login-container">
		<h2>Change Password</h2>
		<form action="validateChangePassword.jsp"  method="post">
			Email id<input type="email" id="email" name="email" required>
			NewPassword<input type="password" id="password" name="password" required placeholder="Password">
			<button type="submit">Change Password</button>
		</form>
		<p><a href="register.jsp">Don't Have an account Create Now</a></p>
		<%
			if(request.getParameter("error")!=null){
				out.println("<p style='color:red'>Invalid Email Id</p>");
			}
		%>
		<%
			if(request.getParameter("error1")!=null){
				out.println("<p style='color:red'>Server Error Please Try Again Later</p>");
			}
		%>
</div>
</body>
</html>