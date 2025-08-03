<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ include file="DBConnection.jsp" %>

<%! 
// Helper to escape a CSV field (quotes, commas, newlines)
public String escapeCsv(String s) {
    if (s == null) return "";
    String escaped = s.replace("\"", "\"\""); // double quotes
    if (escaped.contains(",") || escaped.contains("\"") || escaped.contains("\n") || escaped.contains("\r")) {
        escaped = "\"" + escaped + "\"";
    }
    return escaped;
}
%>

<%
    // Session & role check
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int adminId = (Integer) session.getAttribute("user_id");

    // Validate event_id param
    String evtParam = request.getParameter("event_id");
    if (evtParam == null) {
        out.println("Missing event_id");
        return;
    }

    int eventId;
    try {
        eventId = Integer.parseInt(evtParam);
    } catch (NumberFormatException e) {
        out.println("Invalid event_id");
        return;
    }

    // Verify ownership
    PreparedStatement psCheck = conn.prepareStatement(
        "SELECT created_by, title FROM events WHERE event_id = ?");
    psCheck.setInt(1, eventId);
    ResultSet rsCheck = psCheck.executeQuery();
    if (!rsCheck.next()) {
        out.println("Event not found.");
        return;
    }
    int createdBy = rsCheck.getInt("created_by");
    String title = rsCheck.getString("title");
    if (createdBy != adminId) {
        out.println("Unauthorized access.");
        return;
    }

    // Prepare CSV response
    String fileName = "registrations_event_" + eventId + ".csv";
    response.reset(); // clear buffer and headers
    response.setContentType("text/csv; charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

    // Optional: BOM for Excel to interpret UTF-8
    // OutputStreamWriter osw = new OutputStreamWriter(response.getOutputStream(), "UTF-8");
    // osw.write('\uFEFF');
    // PrintWriter writer = new PrintWriter(osw, true);

    PrintWriter writer = response.getWriter();

    // CSV Header
    writer.println("Username,User Type,Registered At");

    // Fetch registrations
    PreparedStatement ps = conn.prepareStatement(
        "SELECT u.username, u.user_type, r.registered_at " +
        "FROM registrations r " +
        "JOIN users u ON r.user_id = u.id " +
        "WHERE r.event_id = ? " +
        "ORDER BY r.registered_at DESC");
    ps.setInt(1, eventId);
    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
        String uname = rs.getString("username");
        String utype = rs.getString("user_type");
        Timestamp regTime = rs.getTimestamp("registered_at");

        String line = escapeCsv(uname) + "," +
                      escapeCsv(utype) + "," +
                      escapeCsv(regTime != null ? regTime.toString() : "");
        writer.println(line);
    }

    writer.flush();
    // Do not close writer or conn too early; JSP will handle closing at end
    conn.close();
%>

