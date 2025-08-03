



<%@ page import="java.sql.*" %>
<%@ include file="DBConnection.jsp" %>
<%@ page import="java.time.*" %>
<%
  HttpSession sess = request.getSession(false);
  if (sess == null || sess.getAttribute("user_id") == null) {
      response.sendRedirect("login.jsp");
      return;
  }
  Integer adminId = (Integer) session.getAttribute("user_id");
  String message = null;
  String error = null;

  if ("POST".equalsIgnoreCase(request.getMethod())) {
      String title = request.getParameter("title");
      String description = request.getParameter("description");
      String eventDate = request.getParameter("event_date");
      String eventTime = request.getParameter("event_time");
      String location = request.getParameter("location");

      // Basic server-side validation
      if (title == null || title.trim().isEmpty()) {
          error = "Title is required.";
      } else if (eventDate == null || eventDate.trim().isEmpty()) {
          error = "Date is required.";
      } else {
          try {
        	  Timestamp currentTimeStamp=Timestamp.from(Instant.now());
              PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO events (title, description, date, time, location, created_by,created_at) VALUES (?, ?, ?, ?, ?, ?,?)");
              ps.setString(1, title);
              ps.setString(2, description);
              ps.setString(3, eventDate);
              ps.setString(4, eventTime);
              ps.setString(5, location);
              ps.setInt(6, adminId);
              ps.setTimestamp(7, currentTimeStamp);
              int r = ps.executeUpdate();
              if (r > 0) {
                  message = "Event created successfully.";
              } else {
                  error = "Failed to create event.";
              }
          } catch(Exception ex) {
              error = "Server error: " + ex.getMessage();
          }
      }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Create Event</title>
  <link rel="stylesheet" href="event-create.css">
  <script>
    // Auto-resize textarea
    function autoResize(el) {
      el.style.height = 'auto';
      el.style.height = (el.scrollHeight) + 'px';
    }
    window.addEventListener('DOMContentLoaded', () => {
      const ta = document.getElementById('description');
      if (ta) {
        autoResize(ta);
        ta.addEventListener('input', () => autoResize(ta));
      }
    });

    // Client-side validation before submit
    function validateForm() {
      const title = document.getElementById('title').value.trim();
      const date = document.getElementById('event_date').value;
      if (!title) {
        alert("Title is required.");
        return false;
      }
      if (!date) {
        alert("Event date is required.");
        return false;
      }
      // Optional: ensure date is not in past
      const selected = new Date(date);
      const today = new Date();
      today.setHours(0,0,0,0);
      if (selected < today) {
        alert("Event date cannot be in the past.");
        return false;
      }
      return true;
    }
  </script>
</head>
<body>
  <header>
    <div><h1>Create New Event</h1></div>
    <div class="nav">
      <a href="adminDashboard.jsp">My Events</a>
      <a href="home.jsp">Home</a>
      <a class="button secondary" href="logout.jsp">Logout</a>
    </div>
  </header>

  <div class="container">
    <div class="card">
      <h2>Event Details</h2>

      <% if (error != null) { %>
        <div class="error"><%= error %></div>
      <% } else if (message != null) { %>
        <div class="success"><%= message %></div>
      <% } %>

      <form method="post" onsubmit="return validateForm()">
        <div class="form-row">
          <div>
            <label for="title">Title *</label>
            <input type="text" id="title" name="title" placeholder="Event title" required value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
          </div>

          <div>
            <label for="event_date">Date *</label>
            <input type="date" id="event_date" name="event_date" required value="<%= request.getParameter("event_date") != null ? request.getParameter("event_date") : "" %>">
          </div>

          <div>
            <label for="event_time">Time</label>
            <input type="time" id="event_time" name="event_time" value="<%= request.getParameter("event_time") != null ? request.getParameter("event_time") : "" %>">
          </div>
        </div>

        <div class="form-row">
          <div style="grid-column:1/-1;">
            <label for="description">Description</label>
            <textarea id="description" name="description" placeholder="Describe the event..." oninput="autoResize(this)"><%= request.getParameter("description") != null ? request.getParameter("description") : "" %></textarea>
          </div>
        </div>

        <div class="form-row">
          <div>
            <label for="location">Location</label>
            <input type="text" id="location" name="location" placeholder="Event location" value="<%= request.getParameter("location") != null ? request.getParameter("location") : "" %>">
          </div>
        </div>

        <div class="actions">
          <button class="button-primary" type="submit">Create Event</button>
          <a class="button-secondary" href="adminDashboard.jsp">Cancel</a>
        </div>
      </form>
      <p class="small">* Required fields</p>
    </div>
  </div>
</body>
</html>