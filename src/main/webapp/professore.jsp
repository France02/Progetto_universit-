<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<%@ page import= "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Area Professore</title> <%-- Ho modificato il titolo per chiarezza --%>
<link rel="stylesheet" href="style.css">
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
<div class="top-right-info">
    <span class="welcome-badge">Bentornato Professore: <%=nome%> <%=cognome%></span> <%-- Ho modificato il testo per chiarezza --%>
    <a href="logout.jsp" class="logout-link">logout</a>
</div>

<%-- Questo è per il messaggio generico (se presente) che potresti voler stilizzare come 'general-message' --%>
<%-- String messaggioGenerico = (String) request.getAttribute("messaggioGenerico");
if(messaggioGenerico != null) { %>
    <p class="general-message"><%= messaggioGenerico %></p>
<% } --%>


<div class="main-content-container">

    <% if(appelli!=null){%>
    <p class="section-title">Per la sua materia: "<%=materia %>" sono disponibili i seguenti appelli:</p>
    <table border="1">
        <tr>
            <th>ID Appello</th>
            <th>Data</th>
        </tr>
        <%
        while(appelli.next()){
        %>
        <tr>
            <td><%=appelli.getInt(1)%></td>
            <td><%=appelli.getDate("Data") %></td>
        </tr>
        <% }%> <%-- Chiusura corretta del while --%>
    </table>
    <form action="StampaStudenti" method="post" class="form-section">
        <p>Inserisci l'ID Appello per visualizzare gli studenti prenotati:</p>
        <input type="number" name="ID_appello" placeholder="ID Appello" required>
        <input type="submit" value="Visualizza Studenti">
    </form>
    <% }%> <%-- Chiusura corretta dell'if(appelli!=null) --%>

    <% if(elenco!=null){%>
    <p class="section-title">Per l'esame di "<%=nomeMateria %>" in data <%=Data %> si sono prenotati i seguenti studenti:</p>
    <table border="1">
        <tr>
            <th>Nome</th>
            <th>Cognome</th>
            <th>Matricola</th>
        </tr>
        <%
        while(elenco.next()){
        %>
        <tr>
            <td><%=elenco.getString("nome")%></td>
            <td><%=elenco.getString("cognome")%></td>
            <td><%=elenco.getString("Matricola") %></td>
        </tr>
        <% }%> <%-- Chiusura corretta del while --%>
    </table>
    <% }%> <%-- Chiusura corretta dell'if(elenco!=null) --%>

</div> <%-- Chiusura di main-content-container --%>
</body>
</html>