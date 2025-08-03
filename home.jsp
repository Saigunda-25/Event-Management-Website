<%@ page import="java.sql.*" %>
<%@ include file="DBConnection.jsp" %>
<%
  HttpSession sess = request.getSession(false);
  if (sess == null || sess.getAttribute("user_id") == null) {
      response.sendRedirect("login.jsp");
      return;
  }
  Integer adminId = (Integer) session.getAttribute("user_id");
  String username = (String) session.getAttribute("email_id");

  // Count events
  PreparedStatement pe = conn.prepareStatement("SELECT COUNT(*) FROM events WHERE created_by=?");
  pe.setInt(1, adminId);
  ResultSet re = pe.executeQuery();
  int eventCount = 0;
  if (re.next()) eventCount = re.getInt(1);

  // Unique registrants
  PreparedStatement pr = conn.prepareStatement(
      "SELECT COUNT(DISTINCT r.user_id) FROM registration r JOIN events e ON r.event_id=e.event_id WHERE e.created_by=?");
  pr.setInt(1, adminId);
  ResultSet rr = pr.executeQuery();
  int userCount = 0;
  if (rr.next()) userCount = rr.getInt(1);
%>
<!DOCTYPE html>
<html>
<head>
  <title>Admin Home</title>
  <link rel="stylesheet" href="adminstyle.css">
</head>
<body>
  <header>
    <div><h1>Admin Home</h1></div>
    <div>
      <span>Hi, <strong><%= username %></strong></span>
      <a class="button" href="adminDashboard.jsp">My Events</a>
      <a class="button secondary" href="createEvent.jsp">Create Event</a>
      <a class="button red" href="logout.jsp">Logout</a>
    </div>
  </header>

  <div class="container">
    <div class="card">
      <h2>Overview</h2>
      <div style="display:flex; gap:24px; flex-wrap:wrap;">
        <div style="flex:1; min-width:200px; background:#eef7ff; padding:16px; border-radius:8px;">
          <h3>Total Events</h3>
          <p style="font-size:2rem; margin:4px 0;"><%= eventCount %></p>
        </div>
        <div style="flex:1; min-width:200px; background:#fff7ed; padding:16px; border-radius:8px;">
          <h3>Unique Registrants</h3>
          <p style="font-size:2rem; margin:4px 0;"><%= userCount %></p>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
