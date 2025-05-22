<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Area Professore</title>
<link rel="stylesheet" href="style.css">
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

<% if(nome == null && cognome == null){
    response.sendRedirect("index.jsp");
<<<<<<< HEAD
}
%>
    <div class="page-header">
        <div class="top-right-info">
            <span class="welcome-badge">Bentornato Professore: <%=nome%> <%=cognome%></span>
            <a href="logout.jsp" class="logout-link">logout</a>
        </div>

        <%-- Messaggio generico (se presente), ora correttamente posizionato sotto --%>
        <% String messaggioGenerico = (String) request.getAttribute("messaggioGenerico");
        if(messaggioGenerico != null && !messaggioGenerico.isEmpty()) { %>
            <p class="general-message"><%= messaggioGenerico %></p>
        <% } %>
    </div>
    <div class="main-content-container">

    <% if(appelli!=null){	%>
    <p class="section-title">Per la sua materia: "<%=materia %>" sono disponibili i seguenti appelli:</p>
    <table border="1">
        <thead>
=======
} %>

<div class="top-right-info">
    <span class="welcome-badge">Bentornato Professore: <%= nome %> <%= cognome %></span>
    <a href="logout.jsp" class="logout-link">Logout</a>
</div>

<%-- Messaggi di successo o errore --%>
<% String success = (String) request.getAttribute("success"); %>
<% String error = (String) request.getAttribute("error"); %>

<% if (success != null) { %>
    <p style="color:green;"><%= success %></p>
<% } else if (error != null) { %>
    <p style="color:red;"><%= error %></p>
<% } %>

<div class="main-content-container">

    <% if(appelli != null){ %>
        <p class="section-title">Per la sua materia: "<%= materia %>" sono disponibili i seguenti appelli:</p>
        <table border="1">
>>>>>>> 95206c6f7206d1742034df021e1c0a51f2db75b4
            <tr>
                <th>ID Appello</th>
                <th>Data</th>
            </tr>
<<<<<<< HEAD
        </thead>
        <tbody>
        <%
        while(appelli.next()){
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
        <input type="number" name="ID_appello" placeholder="ID Appello" required>
        <input type="submit" value="Visualizza Studenti">
    </form>
    <% }%>

    <% if(elenco!=null){%>
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
    <% }%>

</div>
=======
            <% while(appelli.next()){ %>
                <tr>
                    <td><%= appelli.getInt(1) %></td>
                    <td><%= appelli.getDate("Data") %></td>
                </tr>
            <% } %>
        </table>

        <form action="StampaStudenti" method="post" class="form-section">
            <p>Inserisci l'ID Appello per visualizzare gli studenti prenotati:</p>
            <input type="number" name="ID_appello" placeholder="ID Appello" required>
            <input type="submit" value="Visualizza Studenti">
        </form>
    <% } %>

    <% if(elenco != null && elenco.isBeforeFirst()) { %>
        <p class="section-title">Per l'esame di "<%= nomeMateria %>" in data <%= Data %> si sono prenotati i seguenti studenti:</p>
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
        <p>Seleziona un appello per visualizzare gli studenti.</p>
    <% } %>

</div>

>>>>>>> 95206c6f7206d1742034df021e1c0a51f2db75b4
</body>
</html>