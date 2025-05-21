<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Area Studenti</title>
</head>
<body>

<%String matricola=(String)session.getAttribute("matricola");
ResultSet res=(ResultSet) request.getAttribute("tabella_corso");
ResultSet res1=(ResultSet) request.getAttribute("elenco_appelli");
String materia=(String) request.getAttribute("materia");
String messaggio = (String) request.getAttribute("successo");
String data = (String) request.getAttribute("data");
String materia2 = (String) request.getAttribute("materia2");
%>
<% if(matricola==null){
	
	response.sendRedirect("index.jsp");
}
%>
<p>Benvenuto studente:<%=matricola %></p> 
<a href="logout.jsp">logout</a>
<% if(res!=null) {%>
<table border=1>
<tr>
<th>ID corso</th>
<th>materia</th>
<th>nome docente</th>
<th>cognome docente</th>
</tr>
<%
while(res.next()){	
%>
<tr>
<th><%=res.getInt("idcorso") %></th>
<th><%=res.getString("materia") %></th>
<th><%=res.getString("nome") %></th>
<th><%=res.getString("cognome") %></th>
<%} %>
</tr>
</table>


<form action="Prenotazione" method="post">
Inserisci la prenotazione che vuoi effettuare
<input type="number" name="materia">
<input type="submit" value="Prenota">
<%} %>
</form>

<% if(res1!=null) {%>
<p>Per l'esame di <%=materia%> sono disponibili i seguenti appelli:</p>
<table border=1>
<tr>
<th>ID Appello</th>
<th>Data</th>
</tr>
<%
while(res1.next()){	
%>
<tr>
<th><%=res1.getInt(1)%></th>
<th><%=res1.getDate("Data") %></th>
<%} %>
</tr>
</table>
<form action="Prenota" method="post">
Inserisci la prenotazione che vuoi effettuare
<input type="number" name="appello">
<input type="submit" value="Prenota"></form>
<%} %>
<%if(messaggio!=null) %>
<%=messaggio %>

<%if(materia2!=null && data!=null){ %>
<p> Prenotazione effettuata con successo in data <%=data %> per il corso <%=materia2 %></p>
<%} %>
</body>
</html>