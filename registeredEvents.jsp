<%@ page import="java.sql.*" %>
<%@ include file="DBConnection.jsp" %>
<%
  HttpSession sess = request.getSession(false);
  if (sess == null || sess.getAttribute("user_id") == null) {
      response.sendRedirect("login.jsp");
      return;
  }
  Integer userId = (Integer) session.getAttribute("user_id");
  String username = (String) session.getAttribute("email_id");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Registered Events</title>
  <link rel="stylesheet" href="adminstyle.css"> <!-- reuse existing styles -->
  <style>
    .badge-user { background: #6c63ff; }
    .registered { background: #d4edda; padding:6px 12px; border-radius:6px; color:#2f6f3f; font-weight:600; }
    .register-btn { background: #0f9d58; color: white; padding:8px 14px; border:none; border-radius:6px; cursor:pointer; text-decoration:none; }
    .section { margin-bottom:40px; }
  </style>
</head>
<body>
  <header>
    <div><h1>Welcome, <%= username %></h1></div>
    <div style="display:flex; gap:12px; flex-wrap:wrap; align-items:center;">
      <a class="button" href="mainHomeUserAdmin.jsp">Home</a>
      <a class="button secondary" href="userDashboard.jsp">Upcoming Events</a>
      <a class="button" href="logout.jsp">Logout</a>
    </div>
  </header>
    <!-- Participated / Registered Events -->
    <div class="section">
      <div class="section-title">
        <h2>Your Registered Events</h2>
      </div>
      <div class="card-grid">
        <%
          PreparedStatement psReg = conn.prepareStatement(
            "SELECT e.event_id, e.title, e.description, e.date, e.time, e.location, r.registered_at " +
            "FROM registration r JOIN events e ON r.event_id=e.event_id " +
            "WHERE r.user_id=? ORDER BY r.registered_at DESC");
          psReg.setInt(1, userId);
          ResultSet rsReg = psReg.executeQuery();
          boolean any=false;
          while (rsReg.next()) {
            any=true;
            int eid = rsReg.getInt("event_id");
            String title = rsReg.getString("title");
            String desc = rsReg.getString("description");
            Date date = rsReg.getDate("date");
            Time time = rsReg.getTime("time");
            String location = rsReg.getString("location");
            Timestamp regAt = rsReg.getTimestamp("registered_at");
        %>
        <div class="event-card">
          <h3><%= title %></h3>
          <div class="event-meta">
            <% if (date != null) { %><span class="badge"><%= date %></span><% } %>
            <% if (time != null) { %><span class="badge"><%= time.toString() %></span><% } %>
            <% if (location != null) { %><span class="badge"><%= location %></span><% } %>
          </div>
          <div class="event-description">
            <%= (desc == null || desc.trim().isEmpty()) ? "No description." : (desc.length() > 150 ? desc.substring(0,150) + "..." : desc) %>
          </div>
          <div class="event-actions">
            <span class="small">Registered at: <%= regAt %></span>
            <a class="button" href="eventDetailsUser.jsp?event_id=<%= eid %>">Details</a>
          </div>
        </div>
        <% } %>
        <% if (!any) { %>
          <div class="card">
            <p>You have not registered for any events yet.</p>
          </div>
        <% } %>
      </div>
    </div>

  </div>
</body>
</html>

