<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Registration</title>
<link rel="stylesheet" href="registerstyle.css">
</head>
<body>
	<div class="container">
		<h2>Registration</h2>
		<form action="registeringUser.jsp"  method="post">
			Name<input type="text" name="name" id="name" required>
			Email id<input type="email" id="email" name="email" required>
			Password<input type="password" id="password" name="password" required placeholder="Password">
			<button type="submit">Register</button>
		</form>
		<p><a href="login.jsp">Already have an account?Login Here</a></p>
		<%
			if(request.getParameter("error")!=null){
				out.println("<p style='color:red'>Email Already Exists</p>");
			}
		%>
	</div>
</body>
</html>