<%@ page import="java.sql.*" %>
<%@ include file="DBConnection.jsp" %>
<%@ page import="java.time.*" %>
<%@ page import ="javax.mail.*, javax.mail.internet.*, java.util.*" %>
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
      PreparedStatement ps2=conn.prepareStatement("Select email_id from users where user_id=?");
	  ps2.setInt(1,userId);
	  ResultSet rs=ps2.executeQuery();
	  String email=null;
	  if(rs.next()){
		  email=rs.getString("email_id");
	  }
	  PreparedStatement ps3=conn.prepareStatement("Select * from events where event_id=?");
	  ps2.setInt(1,eventId);
	  ResultSet rs1=ps2.executeQuery();
	  String title=null;
	  if(rs1.next()){
		  title=rs1.getString("title");
	  }
	  String host = "smtp.gmail.com";
	    String username = "iasgunda6@gmail.com";
	    String pass = "cjjn yhbi bkac nnnt";
	    String port = "587";//You can use the port 465 also

	    Properties props = new Properties();
	    props.put("mail.smtp.auth", "true");
	    props.put("mail.smtp.starttls.enable", "true");
	    props.put("mail.smtp.host", host);
	    props.put("mail.smtp.port", port);

	    // create a mail session with the given properties and getting the authentication from Google SMTP Server
	    
	    Session sesion = Session.getInstance(props, new Authenticator() {
	        protected PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(username, pass);
	        }
	    });
	    String from = "iasgunga6@gmail.com";
	    String to =email;
	    out.println(email);
	    String subject = "Registeration Mail";
	    String body = "You are Sucessfully Registered to the Event "+title+" for Further Information Check your Mail Frequently.";

	    // create a new message
	    
	    Message message = new MimeMessage(sesion);
	    message.setFrom(new InternetAddress(from));
	    message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
	    message.setSubject(subject);
	    message.setText(body);
		  Transport.send(message);
      response.sendRedirect("userDashboard.jsp?msg=registered");
  } else {
      out.println("<p style='color:red;'>Failed to register. <a href='userDashboard.jsp'>Back</a></p>");
  }
%>

