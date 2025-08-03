<%
    HttpSession sess = request.getSession(false);
    if (sess != null) sess.invalidate();
    response.sendRedirect("login.jsp");
%>