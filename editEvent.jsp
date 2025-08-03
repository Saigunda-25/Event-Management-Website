<%@ page import="java.sql.*" %>
<%@ include file="DBConnection.jsp" %>
<%
  HttpSession sess = request.getSession(false);
  if (sess== null || sess.getAttribute("user_id") == null) {
      response.sendRedirect("login.jsp");
      return;
  }
  Integer adminId = (Integer) session.getAttribute("user_id");

  int eventId = 0;
  try {
    eventId = Integer.parseInt(request.getParameter("event_id"));
  } catch(Exception e) {
    out.println("<p>Invalid event id.</p>");
    return;
  }

  // Fetch and validate ownership
  PreparedStatement psFetch = conn.prepareStatement(
    "SELECT title, description, date, time, location FROM events WHERE event_id=? AND created_by=?");
  psFetch.setInt(1, eventId);
  psFetch.setInt(2, adminId);
  ResultSet rs = psFetch.executeQuery();
  if (!rs.next()) {
      out.println("<p>Event not found or you don't have permission.</p>");
      return;
  }
  String title = rs.getString("title");
  String desc = rs.getString("description");
  Date date = rs.getDate("date");
  Time time = rs.getTime("time");
  String location = rs.getString("location");

  // Handle update
  if ("POST".equalsIgnoreCase(request.getMethod())) {
      String newTitle = request.getParameter("title");
      String newDesc = request.getParameter("description");
      String newDate = request.getParameter("event_date");
      String newTime = request.getParameter("event_time");
      String newLocation = request.getParameter("location");

      PreparedStatement psUpdate = conn.prepareStatement(
        "UPDATE events SET title=?, description=?, date=?,time=?, location=? WHERE event_id=? AND created_by=?");
      psUpdate.setString(1, newTitle);
      psUpdate.setString(2, newDesc);
      psUpdate.setString(3, newDate);
      psUpdate.setString(4, newTime);
      psUpdate.setString(5, newLocation);
      psUpdate.setInt(6, eventId);
      psUpdate.setInt(7, adminId);
      int updated = psUpdate.executeUpdate();
      if (updated > 0) {
          out.println("<center><p style='color:green;'>Event updated successfully.</p></center>");
          title = newTitle; desc = newDesc; date = Date.valueOf(newDate); time = Time.valueOf(newTime + ":00"); location = newLocation;
      } else {
          out.println("<p style='color:red;'>Update failed.</p>");
      }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Edit Event</title>
  <link rel="stylesheet" href="adminstyle.css">
  <style>
    .form-box { background: white; padding: 22px; border-radius: 10px; box-shadow: 0 12px 24px rgba(0,0,0,0.08); max-width: 700px; margin: 30px auto; }
    .form-box label { display:block; font-weight:600; margin-top:10px; }
    .form-box input, .form-box textarea { width:100%; padding:10px; margin-top:6px; border:1px solid #ccc; border-radius:6px; box-sizing:border-box; }
    .form-box textarea { resize: vertical; min-height:100px; }
  </style>
</head>
<body>
  <header>
    <div><h1>Edit Event</h1></div>
    <div>
      <a class="button secondary" href="adminDashboard.jsp">Back to Dashboard</a>
    </div>
  </header>
  <div class="container">
    <div class="form-box">
      <form method="post">
        <label>Title</label>
        <input type="text" name="title" value="<%= title %>" required>

        <label>Description</label>
        <textarea name="description" required><%= desc %></textarea>

        <label>Date</label>
        <input type="date" name="event_date" value="<%= date %>" required>

        <label>Time</label>
        <input type="time" name="event_time" value="<%= (time!=null)? time.toString().substring(0,5): "" %>">

        <label>Location</label>
        <input type="text" name="location" value="<%= location %>">

        <input class="button" type="submit" value="Update Event">
      </form>
    </div>
  </div>
</body>
</html>
