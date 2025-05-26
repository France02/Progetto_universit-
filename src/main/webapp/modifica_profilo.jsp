<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%
String nomeStudente = (String)session.getAttribute("nomeStudente"); 
String matricolaStud = (String)session.getAttribute("matricolaStudente"); 
ResultSet tabellaCorsi = (ResultSet) request.getAttribute("tabella_corso"); 
String messaggioStud = (String) request.getAttribute("messaggioStudente"); 

ResultSet elencoAppelli = (ResultSet) request.getAttribute("elenco_appelli");
String materiaCorsoSelezionato = (String) request.getAttribute("materia"); 

String messaggioPrenotazione = (String) request.getAttribute("messaggioPrenotazione"); 

if(matricolaStud == null){ 
    response.sendRedirect("index.jsp"); 
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Modifica Utente</title>
	<link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="page-header">
        <div class="top-right-info">
            <span class="welcome-badge">Benvenuto Stud. <%=nomeStudente != null ? nomeStudente : matricolaStud %></span>
            <a href="studente.jsp" class="logout-link">Torna Indietro</a> 
            <a href="index.jsp" class="logout-link">Logout</a> 
        </div>
        <% if(messaggioStud != null && !messaggioStud.isEmpty()) { %>
            <p class="general-message"><%= messaggioStud %></p>
        <% } %>
    </div>
	    <form action="Modifica" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        
        <input type="submit" value="Modifica">
        </form>
</body>
</html>