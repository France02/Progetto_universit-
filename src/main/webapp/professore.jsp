<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import= "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<% String nome= (String)session.getAttribute("nome");
String cognome= (String)session.getAttribute("cognome");
String materia=(String)session.getAttribute("materia");
ResultSet appelli=(ResultSet)request.getAttribute("appelli");
ResultSet elenco=(ResultSet)request.getAttribute("elenco_studenti");
String nomeMateria= (String)request.getAttribute("Materia");
String Data= (String)request.getAttribute("Data");


%>
<% if(nome==null && cognome==null){
	
	response.sendRedirect("index.jsp");
}
%>
<p>Bentornato <%=nome%><%=cognome%></p>
<a href="logout.jsp">logout</a>
<% if(appelli!=null){	

%>
<p> Per la sua materia: <%=materia %> sono disponibili i seguenti appelli </p>
<table border=1>
<tr>
<th>ID Appello</th>
<th>Data</th>
</tr>
<%
while(appelli.next()){	
%>
<tr>
<th><%=appelli.getInt(1)%></th>
<th><%=appelli.getDate("Data") %></th>
</tr>
</table>
<% }%>
<form action="StampaStudenti" method="post">
<p><input type="number" name="ID_appello"></p>
<p><input type="submit" value="Vai"></p>
</form>
<%
}%>
<% if(elenco!=null){%>	

<p>Per l'esame<%=nomeMateria %> in data<%=Data %>si sono prenotati i seguenti studenti: </p>
<table border=1>
<tr>
<th>Nome</th>
<th>Cognome</th>
<th>Matricola</th>
</tr>
<%
while(elenco.next()){	
%>
<tr>
<th><%=elenco.getString("nome")%></th>
<th><%=elenco.getString("cognome")%></th>
<th><%=elenco.getString("Matricola") %></th>
<% }%>
<%} %>
</tr>
</table>
</body>
</html>