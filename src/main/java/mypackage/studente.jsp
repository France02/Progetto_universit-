<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Area Studenti</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

<%
String matricola=(String)session.getAttribute("matricola");
ResultSet res=(ResultSet) request.getAttribute("tabella_corso");
ResultSet res1=(ResultSet) request.getAttribute("elenco_appelli");
String materia=(String) request.getAttribute("materia");
String messaggio = (String) request.getAttribute("successo"); // Questo � il messaggio di successo generico
String data = (String) request.getAttribute("data");
String materia2 = (String) request.getAttribute("materia2");
String idcorso = null;
%>

<% if(matricola==null){
    response.sendRedirect("index.jsp");
}
%>

<div class="top-right-info">
    <span class="welcome-badge">Benvenuto studente: <%=matricola %></span>
    <a href="logout.jsp" class="logout-link">logout</a>
</div>

<% if(messaggio!=null){%>
    <p class="general-message">
        <%=messaggio %>
    </p>
<%} %>

<div class="main-content-container">

    <% if(res!=null) {%>
    <p class="section-title">Corsi disponibili:</p>
    <table border="1">
        <tr>
            <th>ID corso</th>
            <th>Materia</th>
            <th>Nome Docente</th>
            <th>Cognome Docente</th>
        </tr>
        <%
        while(res.next()){
        %>
        <tr>
            <td><%=res.getInt("idcorso") %></td>
            <td><%=res.getString("materia") %></td>
            <td><%=res.getString("nome") %></td>
            <td><%=res.getString("cognome") %></td>
        </tr>
        <% idcorso = res.getString("idcorso"); %>
        <%} %>
    </table>
    <form action="Prenotazione" method="post" class="form-section">
        <p>Inserisci l'ID del corso a cui vuoi iscriverti:</p>
        <input type="number" name="materia" placeholder="ID Corso" required min="1" max=<%=idcorso%>>
        <input type="submit" value="Iscriviti al Corso">
    </form>
    <%} %>
    <% if(res1!=null) {%>
    <p class="section-title">Appelli disponibili per <%=materia%>:</p>
    <table border="1">
        <tr>
            <th>ID Appello</th>
            <th>Data</th>
        </tr>
        <%
        while(res1.next()){
        %>
        <tr>
            <td><%=res1.getInt(1)%></td>
            <td><%=res1.getDate("Data") %></td>
        </tr>
        <% idcorso = res1.getString(1); %>
        <%} %>
    </table>
    <form action="Prenota" method="post" class="form-section">
        <p>Inserisci l'ID dell'appello a cui vuoi prenotarti:</p>
        <input type="number" name="appello" placeholder="ID Appello" required min="1" max=<%=idcorso%>>
        <input type="submit" value="Prenota Appello">
    </form>
    <%} %>

    <%-- Messaggio di conferma prenotazione specifica --%>
    <%if(materia2!=null && data!=null){ %>
    <p class="success-message">Prenotazione effettuata con successo in data <%=data%> per il corso "<%=materia2 %>".</p>
    <%} %>

</div> <%-- Chiusura di main-content-container --%>

</body>
</html>