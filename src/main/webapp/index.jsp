<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Benvenuto</title>
<<<<<<< HEAD
<link rel="stylesheet" href="style.css">
=======
<link href="css/style.css" rel="stylesheet" type="text/css">
>>>>>>> 91fe4620df243abf89531b0087f4c6c7fbdec702
</head>
<body class="sfondo-pagina">
<%
String messaggio= (String)request.getAttribute("messaggio");
%>
<% 
if(messaggio!=null){%>
<p align="center">
<a style="font-family:helvetica; color:yellow;font-size:20px">
<%out.print(messaggio);%></a> <%-- si poteva fare anche con l'espressione <%=messaggio%> --%>
</p>
<%} %>


<div class="login-container">
<form action="login" method="post">
<h3>inserisci nome utente</h3>
<input type="text" name="username"><p>
<h3>inserisci password</h3>
<input type="password" name="password"><p>
<input type="submit" value="Accedi"><p>
</form>
</div>
</body>
</html>