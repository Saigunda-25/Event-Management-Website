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
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard</title>
  <link rel="stylesheet" href="adminstyle.css">
  <style>
    /* Ensure overlay link doesn’t block buttons */
    .event-card { position: relative; }
    .card-link-overlay {
      position: absolute;
      inset: 0;
      z-index: 1;
      text-indent: -9999px;
    }
    .event-actions a,
    .event-actions button {
      position: relative;
      z-index: 2;
    }
  </style>
  <script>
    function confirmDelete(eid) {
      if (confirm("Are you sure you want to delete this event?")) {
        window.location.href = "deleteEvent.jsp?event_id=" + eid;
      }
    }
    function expandDesc(id) {
      const descEl = document.getElementById('desc-' + id);
      if (!descEl) return;
      descEl.style.display = 'block';
      descEl.style.webkitLineClamp = 'unset';
      descEl.style.maxHeight = 'none';
      descEl.style.overflow = 'visible';
      const rm = document.getElementById('readmore-' + id);
      if (rm) rm.style.display = 'none';
    }
  </script>
</head>
<body>
  <header>
    <div><h1>Admin Dashboard</h1></div>
    <div style="display:flex; gap:12px; flex-wrap:wrap; align-items:center;">
      <span style="margin-right:12px;">Hi, <strong><%= username %></strong></span>
      <a class="button" href="createEvent.jsp">+ New Event</a>
      <a class="button secondary" href="home.jsp">Home</a>
      <a class="button red" href="logout.jsp">Logout</a>
    </div>
  </header>

  <div class="container">
    <div class="section-title">
      <h2>Your Events</h2>
    </div>

    <div class="card-grid">
      <%
        PreparedStatement ps = conn.prepareStatement(
            "SELECT event_id, title, description, date, time, location, created_at FROM events WHERE created_by = ? ORDER BY created_at DESC");
        ps.setInt(1, adminId);
        ResultSet rs = ps.executeQuery();
        boolean any = false;
        while (rs.next()) {
          any = true;
          int eid = rs.getInt("event_id");
          String title = rs.getString("title");
          String desc = rs.getString("description");
          Date date = rs.getDate("date");
          Time time = rs.getTime("time");
          String location = rs.getString("location");
          Timestamp created = rs.getTimestamp("created_at");
      %>
      <div class="event-card">
        <!-- clickable overlay -->
        <a class="card-link-overlay" href="eventDetail.jsp?event_id=<%= eid %>">View details of <%= title %></a>

        <h3><%= title %></h3>
        <div class="event-meta">
          <% if (date != null) { %><span class="badge"><%= date %></span><% } %>
          <% if (time != null) { %><span class="badge"><%= time.toString() %></span><% } %>
          <% if (location != null && !location.isEmpty()) { %><span class="badge"><%= location %></span><% } %>
        </div>

        <div class="event-description" id="desc-<%= eid %>">
          <%= (desc == null || desc.trim().isEmpty()) ? "No description." : desc %>
        </div>
        <% if (desc != null && desc.length() > 300) { %>
          <div>
            <span class="read-more" id="readmore-<%= eid %>" onclick="expandDesc(<%= eid %>)">Read more</span>
          </div>
        <% } %>

        <div class="event-actions">
          <a class="button" href="editEvent.jsp?event_id=<%= eid %>">Edit</a>
          <button class="button red" type="button" onclick="confirmDelete(<%= eid %>)">Delete</button>
          <a class="button secondary" href="viewRegistrations.jsp?event_id=<%= eid %>">View Registrations</a>
          <a class="button" href="exportRegistrations.jsp?event_id=<%= eid %>">Export CSV</a>
        </div>

        <div class="card-footer">
          <div class="event-creator">Created on: <%= created %></div>
          <div>Event ID: <%= eid %></div>
        </div>
      </div>
      <% } %>
      <% if (!any) { %>
        <div style="grid-column:1/-1;">
          <div class="card">
            <p>No events created yet. <a href="createEvent.jsp" class="button">Create your first event</a></p>
          </div>
        </div>
      <% } %>
    </div>
  </div>
</body>
</html>

