<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Event Management System</title>
  <link rel="stylesheet" href="index.css">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
</head>
<body>
<header class="site-header">
    <div class="logo">
      <h1>EventHub</h1>
      <p>Organize. Participate. Excel.</p>
    </div>
    <nav class="nav">
      <a class="btn-outline" href="userDashboard.jsp">Upcoming Events</a>
      <a class="btn-primary" href="registeredEvents.jsp">Registered Events</a>
      <a class="btn-outline" href="logout.jsp">Logout</a>
    </nav>
  </header>
  <main class="hero">
    <div class="hero-content">
      <h2>Your One-Stop Event Management Portal</h2>
      <p>Host events, create exams, register as participant, track attendance, and export reports—all from a clean web interface. Whether you're an admin creating and managing events, or a user registering and participating, EventHub makes it easy.</p>
      <p class="admin-note">
        <strong>Want to become an Admin?</strong> Contact the current administrator at 
        <a href="mailto:iasgunda6@gmail.com">iasgunda6@gmail.com</a> to request an admin account.
      </p>
    </div>
    <div class="hero-illustration">
      <!-- could be an SVG or placeholder -->
      <div class="illustration-box">
        <p>📅 🎓 ✍️ 📊</p>
      </div>
    </div>
  </main>

  <section class="features">
    <div class="feature">
      <div class="icon">🛠️</div>
      <h3>Event Creation</h3>
      <p>Admins can create unlimited events, set details like date, time, location, and descriptions.</p>
    </div>
    <div class="feature">
      <div class="icon">👥</div>
      <h3>User Registration</h3>
      <p>Users can sign up and register for events they are interested in. See your registered events at a glance.</p>
    </div>
    <div class="feature">
      <div class="icon">📤</div>
      <h3>Export & Reports</h3>
      <p>Export registration data to CSV. Get insights into participation and engagement.</p>
    </div>
    <div class="feature">
      <div class="icon">🔐</div>
      <h3>Role-Based Access</h3>
      <p>Separate admin and user views; admins control events, users participate safely.</p>
    </div>
  </section>

  <footer class="site-footer">
    <div class="footer-content">
      <div>
        <h4>EventHub</h4>
        <p>Bringing organizers and participants together in one place.</p>
      </div>
      <div>
        <h4>Contact</h4>
        <p>Admin Requests: <a href="mailto:iasgunda6@gmail.com">iasgunda6@gmail.com</a></p>
      </div>
    </div>
    <div class="footer-bottom">
      © <%= java.time.Year.now() %> EventHub. All rights reserved.
    </div>
  </footer>
</body>
</html>
