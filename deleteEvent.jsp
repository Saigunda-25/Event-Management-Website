<%@ page import="java.sql.*" %>
<%@ include file="DBConnection.jsp" %>
<%
  HttpSession sess = request.getSession(false);
  if (sess == null || sess.getAttribute("user_id") == null ) {
      response.sendRedirect("login.jsp");
      return;
  }
  Integer adminId = (Integer) session.getAttribute("user_id");
  int eventId = 0;
  try {
    eventId = Integer.parseInt(request.getParameter("event_id"));
  } catch(Exception e) {
    response.sendRedirect("adminDashboard.jsp");
    return;
  }

  // Delete only if owned
  PreparedStatement ps = conn.prepareStatement(
      "DELETE FROM events WHERE event_id=? AND created_by=?");
  ps.setInt(1, eventId);
  ps.setInt(2, adminId);
  int deleted = ps.executeUpdate();
  if (deleted > 0) {
      response.sendRedirect("adminDashboard.jsp?msg=deleted");
  } else {
      out.println("<p style='color:red;'>Cannot delete or not authorized.</p>");
  }
%>
