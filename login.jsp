<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login Page</title>
<link rel="stylesheet" href="loginstyle.css">
</head>
<body>
<div class="login-container">
		<%
			String msg=request.getParameter("msg");
			if("registered".equals(msg)){
		%>
		<div style="background:#d4edda;color:#155724;padding:10px;bottom:1px solid#c3e6cb;border-radius:4px;margin-bottom:10px;">
			Registration Successful. Please Login.
		</div>
			<%}%>
		<%
			String msg1=request.getParameter("msg1");
			if("passwordchanged".equals(msg1)){
		%>
		<div style="background:#d4edda;color:#155724;padding:10px;bottom:1px solid#c3e6cb;border-radius:4px;margin-bottom:10px;">
			Password Changed Successfully. Please Login.
		</div>
			<%}%>
		<h2>Login to Event Management</h2>
		<form action="validateLogin.jsp"  method="post">
			Email id<input type="email" id="email" name="email" required>
			Password<input type="password" id="password" name="password" required placeholder="Password">
			<button type="submit">Login</button>
		</form>
		<p><a href="forgotPassword.jsp">Forgot Password</a></p>
		<p><a href="register.jsp">Don't Have an account Create Now</a></p>
		<%
			if(request.getParameter("error")!=null){
				out.println("<p style='color:red'>Invalid Credentials</p>");
			}
		%>
</div>
</body>
</html>