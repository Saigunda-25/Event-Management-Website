<%@ page import="java.sql.*" %>
<%@ include file="DBConnection.jsp" %>
<%
  HttpSession sess = request.getSession(false);
  if (sess == null || sess.getAttribute("user_id") == null) {
      response.sendRedirect("login.jsp");
      return;
  }
  Integer adminId = (Integer) session.getAttribute("user_id");
  int eventId = Integer.parseInt(request.getParameter("event_id"));
%>
<!DOCTYPE html>
<html>
<head>
  <title>Registrations</title>
  <link rel="stylesheet" href="adminstyle.css">
</head>
<body>
  <header>
    <div><h1>Registrations</h1></div>
    <div>
      <a class="button secondary" href="adminDashboard.jsp">Back</a>
      <a class="button" href="exportRegistrations.jsp?event_id=<%= eventId %>">Export CSV</a>
    </div>
  </header>
  <div class="container">
    <div class="card">
      <h2>Users registered for Event ID: <%= eventId %></h2>
      <table class="table">
        <thead>
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Registered Time</th>
          </tr>
        </thead>
        <tbody>
          <%
            PreparedStatement ps = conn.prepareStatement(
              "SELECT u.name, u.email_id, r.registered_at FROM registration r " +
              "JOIN users u ON r.user_id=u.user_id " +
              "JOIN events e ON e.event_id=r.event_id " +
              "WHERE r.event_id=? AND e.created_by=? ORDER BY r.registered_at");
            ps.setInt(1, eventId);
            ps.setInt(2, adminId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String uname = rs.getString("name");
                String email = rs.getString("email_id");
                Timestamp time=rs.getTimestamp("registered_at");
          %>
          <tr>
            <td><%= uname %></td>
            <td><%= email %></td>
            <td><%= time %></td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</body>
</html>