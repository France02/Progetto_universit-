<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<%@ page import= "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Area Professore</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
   <%
// Recupero gli attributi dalla sessione e dalla request
String nome = (String)session.getAttribute("nome");
String cognome = (String)session.getAttribute("cognome");
String materia = (String)session.getAttribute("materia"); // Presumo sia la materia insegnata dal professore

ResultSet appelli = (ResultSet)request.getAttribute("appelli");
ResultSet elenco = (ResultSet)request.getAttribute("elenco_studenti");
String nomeMateria = (String)request.getAttribute("Materia"); // Materia specifica per l'elenco studenti
String Data = (String)request.getAttribute("Data"); // Data specifica per l'elenco studenti

// Messaggio generico o di errore dal server (es. da un Servlet)
String messaggioGenerico = (String)request.getAttribute("messaggioGenerico");

// Controllo di autenticazione: se nome o cognome non sono in sessione, reindirizza
if(nome == null || cognome == null){
    response.sendRedirect("index.jsp");
    return; // Interrompe l'esecuzione del JSP
}
%>

    <div class="page-header">
        <div class="top-right-info">
            <span class="welcome-badge">Bentornato Professore: <%=nome%> <%=cognome%></span>
            <a href="logout.jsp" class="logout-link">logout</a>
        </div>

        <%-- Mostra il messaggio generico se presente --%>
        <% if(messaggioGenerico != null && !messaggioGenerico.isEmpty()) { %>
            <p class="general-message"><%= messaggioGenerico %></p>
        <% } %>
    </div>
    <div class="main-content-container">

    <%-- Se ci sono appelli da mostrare --%>
    <% if(appelli != null){ %>
    <p class="section-title">Per la sua materia: "<%=materia %>" sono disponibili i seguenti appelli:</p>
    <table border="1">
        <thead>
            <tr>
                <th>ID Appello</th>
                <th>Data</th>
            </tr>
        </thead>
        <tbody>
        <%
        String maxIdAppello = null; // Variabile per tenere traccia dell'ID Appello più alto
        while(appelli.next()){
            // Recupera l'ID Appello come stringa per usarlo nell'attributo max
            maxIdAppello = String.valueOf(appelli.getInt(1));
        %>
        <tr>
            <td><%=appelli.getInt(1)%></td>
            <td><%=appelli.getDate("Data") %></td>
        </tr>
        <% }%>
        </tbody>
    </table>
    <form action="StampaStudenti" method="post" class="form-section">
        <p>Inserisci l'ID Appello per visualizzare gli studenti prenotati:</p>
        <input type="number" name="ID_appello" placeholder="ID Appello" required min="1" <% if(maxIdAppello != null) { %>max="<%=maxIdAppello%>"<% } %>>
        <input type="submit" value="Visualizza Studenti">
    </form>
    <%
    // Importante chiudere il ResultSet dopo l'uso
    try { appelli.close(); } catch (SQLException e) { /* Log the exception if needed */ }
    %>
    <% } %>

    <%-- Se c'è un elenco di studenti da mostrare --%>
    <% if(elenco != null){%>
    <p class="section-title">Per l'esame di "<%=nomeMateria %>" in data <%=Data %> si sono prenotati i seguenti studenti:</p>
    <table border="1">
        <thead>
            <tr>
                <th>Nome</th>
                <th>Cognome</th>
                <th>Matricola</th>
            </tr>
        </thead>
        <tbody>
        <%
        while(elenco.next()){
        %>
        <tr>
            <td><%=elenco.getString("nome")%></td>
            <td><%=elenco.getString("cognome")%></td>
            <td><%=elenco.getString("Matricola") %></td>
        </tr>
        <% }%>
        </tbody>
    </table>
    <%
    // Importante chiudere il ResultSet dopo l'uso
    try { elenco.close(); } catch (SQLException e) { /* Log the exception if needed */ }
    %>
    <% }%>

</div> <%-- Chiusura di main-content-container --%>

</body>
</html>