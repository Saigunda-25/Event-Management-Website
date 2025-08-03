<%@ page import="java.sql.*" %>
<%@ include file="DBConnection.jsp" %>
<%@ page import="java.time.*" %>
<%
  HttpSession sess = request.getSession(false);
  if (sess== null || sess.getAttribute("user_id") == null) {
      response.sendRedirect("login.jsp");
      return;
  }
  int userId = (Integer) session.getAttribute("user_id");
  String eventIdParam = request.getParameter("event_id");
  if (eventIdParam == null) {
    response.sendRedirect("userDashboard.jsp");
    return;
  }
  int eventId = Integer.parseInt(eventIdParam);

  // Check if already registered
  PreparedStatement psCheck = conn.prepareStatement(
      "SELECT registration_id FROM registration WHERE user_id=? AND event_id=?");
  psCheck.setInt(1, userId);
  psCheck.setInt(2, eventId);
  ResultSet rsCheck = psCheck.executeQuery();
  if (rsCheck.next()) {
      // already registered
      response.sendRedirect("userDashboard.jsp");
      return;
  }

  // Register
  Timestamp curTime=Timestamp.from(Instant.now());
  PreparedStatement ps = conn.prepareStatement(
    "INSERT INTO registration (user_id, event_id,registered_at) VALUES (?, ?,?)");
  ps.setInt(1, userId);
  ps.setInt(2, eventId);
  ps.setTimestamp(3,curTime);
  int inserted = ps.executeUpdate();
  if (inserted > 0) {
      response.sendRedirect("userDashboard.jsp?msg=registered");
  } else {
      out.println("<p style='color:red;'>Failed to register. <a href='userDashboard.jsp'>Back</a></p>");
  }
%>
