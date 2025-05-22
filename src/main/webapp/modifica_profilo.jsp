<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
String nomeStudente = (String)session.getAttribute("nomeStudente"); 
String passStudente = (String)session.getAttribute("nomeStudente"); 
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Modifica Utente</title>
	<link rel="stylesheet" href="style.css">
</head>
<body>
<span class="welcome-badge">Bensvenuto Stud. <%=passStudente %></span>
	    <form action="login" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        
        <input type="submit" value="Modifica">
        </form>
</body>
</html>