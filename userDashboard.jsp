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
  <title>User Dashboard</title>
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
      <a class="button" href="registeredEvents.jsp">Registered Events</a>
      <a class="button secondary" href="logout.jsp">Logout</a>
    </div>
  </header>

  <div class="container">
    <!-- Available Events -->
    <div class="section">
      <div class="section-title">
        <h2>Available Events</h2>
      </div>
      <div class="card-grid">
        <%
          // All upcoming or existing events
          PreparedStatement psEvents = conn.prepareStatement(
            "SELECT event_id, title, description, date, time, location FROM events ORDER BY date ASC");
          ResultSet rsEvents = psEvents.executeQuery();
          while (rsEvents.next()) {
            int eid = rsEvents.getInt("event_id");
            String title = rsEvents.getString("title");
            String desc = rsEvents.getString("description");
            Date date = rsEvents.getDate("date");
            Time time = rsEvents.getTime("time");
            String location = rsEvents.getString("location");

            // check if user already registered
            PreparedStatement psCheck = conn.prepareStatement(
              "SELECT registration_id FROM registration WHERE user_id=? AND event_id=?");
            psCheck.setInt(1, userId);
            psCheck.setInt(2, eid);
            ResultSet rsCheck = psCheck.executeQuery();
            boolean registered = rsCheck.next();
        %>
        <div class="event-card">
          <h3><%= title %></h3>
          <div class="event-meta">
            <% if (date != null) { %><span class="badge"><%= date %></span><% } %>
            <% if (time != null) { %><span class="badge"><%= time.toString() %></span><% } %>
            <% if (location != null && !location.isEmpty()) { %><span class="badge"><%= location %></span><% } %>
          </div>
          <div class="event-description">
            <%= (desc == null || desc.trim().isEmpty()) ? "No description." : (desc.length() > 150 ? desc.substring(0,150) + "..." : desc) %>
          </div>
          <div class="event-actions">
            <% if (registered) { %>
              <span class="registered">Registered</span>
            <% } else { %>
              <form method="post" action="registerEvent.jsp" style="margin:0;">
                <input type="hidden" name="event_id" value="<%= eid %>">
                <button class="register-btn" type="submit">Register</button>
              </form>
            <% } %>
            <a class="button secondary" href="eventDetailsUser.jsp?event_id=<%= eid %>">Details</a>
          </div>
        </div>
        <% } %>
      </div>
    </div>
  </div>
</body>
</html>

