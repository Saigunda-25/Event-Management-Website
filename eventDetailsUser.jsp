<%@ page import="java.sql.*" %>
<%@ include file="DBConnection.jsp" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Integer userId = (Integer) session.getAttribute("user_id");
    String username = (String) session.getAttribute("username");

    int eventId = 0;
    try {
        eventId = Integer.parseInt(request.getParameter("event_id"));
    } catch (Exception e) {
        out.println("<p>Invalid event ID.</p>");
        return;
    }

    // Fetch event & verify ownership
    PreparedStatement ps = conn.prepareStatement(
        "SELECT title, description, date, time, location, created_by,created_at FROM events WHERE event_id = ?");
    ps.setInt(1, eventId);
    ResultSet rs = ps.executeQuery();
    if (!rs.next()) {
        out.println("<p>Event not found or access denied.</p>");
        return;
    }
    String title = rs.getString("title");
    String description = rs.getString("description");
    Date date = rs.getDate("date");
    Time time = rs.getTime("time");
    String location = rs.getString("location");
    Timestamp created=rs.getTimestamp("created_at");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Event Details - <%= title %></title>
  <link rel="stylesheet" href="adminstyle.css">
</head>
<body>
  <header>
    <div><h1>Event: <%= title %></h1></div>
    <div style="display:flex; gap:10px; flex-wrap:wrap;">
      <a class="button" href="userDashboard.jsp">Upcoming Events</a>
      <a class="button secondary" href="registeredEvents.jsp">View Registrations</a>
      <a class="button" href="mainHomeUserAdmin.jsp?">Home</a>
    </div>
  </header>

  <div class="container">
    <div class="card">
      <h2>Event Details</h2>
      <div style="display:flex; flex-wrap:wrap; gap:30px;">
        <div style="flex:1; min-width:260px;">
          <p><strong>Date:</strong> <%= date %></p>
          <p><strong>Time:</strong> <%= (time != null ? time.toString().substring(0,5) : "—") %></p>
          <p><strong>Location:</strong> <%= location %></p>
          <p class="small">Event ID: <%= eventId %></p>
          <p class="small">Created At: <%= created %></p>
        </div>
        <div style="flex:2; min-width:300px;">
          <p><strong>Description:</strong></p>
          <div class="event-description" style="white-space:pre-wrap; overflow:auto; max-height:250px; padding:10px; border:1px solid #e1e8f0; border-radius:6px;">
            <%= description == null ? "No description provided." : description %>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
</html>

