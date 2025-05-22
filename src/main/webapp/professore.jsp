<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Area Professore</title>
</head>
<body>

<% 
String nome = (String) session.getAttribute("nome");
String cognome = (String) session.getAttribute("cognome");
String materia = (String) session.getAttribute("materia");
ResultSet appelli = (ResultSet) request.getAttribute("appelli");
ResultSet elenco = (ResultSet) request.getAttribute("elenco_studenti");
String nomeMateria = (String) request.getAttribute("Materia");
String Data = (String) request.getAttribute("Data");
%>

<% if(nome == null && cognome == null) {
    response.sendRedirect("index.jsp");
} %>

<h2>Bentornato <%= nome %> <%= cognome %></h2>
<a href="logout.jsp">Logout</a>

<%-- Mostra appelli --%>
<% if(appelli != null) { %>
    <h3>I tuoi appelli:</h3>
    <form action="StampaStudenti" method="post">
        <input type="number" name="ID_appello" placeholder="Inserisci ID Appello">
        <input type="submit" value="Visualizza Studenti">
    </form>
    
    <table border="1">
        <tr><th>ID Appello</th><th>Data</th></tr>
        <% while(appelli.next()) { %>
            <tr>
                <td><%= appelli.getInt(1) %></td>
                <td><%= appelli.getDate("Data") %></td>
            </tr>
        <% } %>
    </table>
<% } %>

<%-- Mostra studenti iscritti --%>
<% if(elenco != null && elenco.isBeforeFirst()) { %>
    <h3>Appello: <%= nomeMateria %>, Data: <%= Data %></h3>
    <p>Seleziona un voto per ogni studente:</p>

    <form action="InserisciVoti" method="post">
        <input type="hidden" name="idAppello" value="${param.ID_appello}">
        
        <table border="1">
            <tr>
                <th>Matricola</th>
                <th>Nome</th>
                <th>Cognome</th>
                <th>Voto</th>
            </tr>
            <% while(elenco.next()) { 
                String matricola = elenco.getString("Matricola");
                String nomeStud = elenco.getString("nome");
                String cognomeStud = elenco.getString("cognome");
            %>
                <tr>
                    <td><%= matricola %></td>
                    <td><%= nomeStud %></td>
                    <td><%= cognomeStud %></td>
                    <td><input type="number" name="voto" min="18" max="30" step="0.5"></td>
                    <input type="hidden" name="matricola" value="<%= matricola %>">
                </tr>
            <% } %>
        </table>
        <input type="submit" value="Salva Voti">
    </form>
<% } else if (elenco != null && !elenco.isBeforeFirst()) { %>
    <p>Nessuno studente iscritto a questo appello.</p>
<% } else { %>
    <p>Inserisci un ID appello per visualizzare gli studenti.</p>
<% } %>

<%-- Messaggio di successo o errore --%>
<% String success = (String) request.getAttribute("success"); %>
<% String error = (String) request.getAttribute("error"); %>

<% if (success != null) { %>
    <p style="color:green;"><%= success %></p>
<% } else if (error != null) { %>
    <p style="color:red;"><%= error %></p>
<% } %>

</body>
</html>