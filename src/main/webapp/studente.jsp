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

    <div class="page-header">
        <div class="top-right-info">
            <span class="welcome-badge">Benvenuto Stud. <%=nomeStudente != null ? nomeStudente : matricolaStud %></span>
            <a href="modifica_profilo.jsp" class="logout-link">Impostazioni</a> 
            <a href="index.jsp" class="logout-link">logout</a> 
        </div>
        <% if(messaggioStud != null && !messaggioStud.isEmpty()) { %>
            <p class="general-message"><%= messaggioStud %></p>
        <% } %>
    </div>
    <div class="main-content-container">
    <% if(messaggioPrenotazione != null && !messaggioPrenotazione.isEmpty()) { %>
        <p class="general-message" style="color: green;"><%= messaggioPrenotazione %></p>
    <% } %>

    <p class="section-title">Corsi Disponibili:</p>
    <table border="1">
        <thead>
            <tr>
                <th>ID Corso</th>
                <th>Materia</th>
                <th>Docente</th>
                <th>Azione</th>
            </tr>
        </thead>
        <tbody>
        <%
        boolean foundCourses = false;
        if(tabellaCorsi != null) {
            while(tabellaCorsi.next()){
                foundCourses = true;
                int idCorso = tabellaCorsi.getInt("idCorso"); 
                String materia = tabellaCorsi.getString("Materia"); 
                String nomeDocente = tabellaCorsi.getString("nome_docente");
                String cognomeDocente = tabellaCorsi.getString("cognome_docente");
        %>
        <tr>
            <td data-label="ID Corso"><%=idCorso%></td>
            <td data-label="Materia"><%=materia%></td>
            <td data-label="Docente"><%=nomeDocente%> <%=cognomeDocente%></td>
            <td data-label="Azione">
                <form action="Prenotazione" method="post" class="inline-form">
                    <input type="hidden" name="idCorso" value="<%=idCorso%>">
                    <input type="submit" value="Mostra Appelli" class="button-iscriviti-corso">
                </form>
            </td>
        </tr>
        <% }
        try { if (tabellaCorsi != null) tabellaCorsi.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (!foundCourses) { %>
            <tr><td colspan="4" style="text-align: center;">Nessun corso disponibile.</td></tr>
        <% } %>
        </tbody>
    </table>

    <% if (elencoAppelli != null) { %>
    <p class="section-title">Appelli disponibili per <%=materiaCorsoSelezionato != null ? materiaCorsoSelezionato : "il corso selezionato"%>:</p>
    <table border="1">
        <thead>
            <tr>
                <th>ID Appello</th>
                <th>Data</th>
                <th>Materia</th>
                <th>Azione</th>
            </tr>
        </thead>
        <tbody>
        <%
        boolean foundAppelli = false;
        while(elencoAppelli.next()){
            foundAppelli = true;
        %>
        <tr>
            <td data-label="ID Appello"><%=elencoAppelli.getInt("idAppello")%></td>
            <td data-label="Data"><%=elencoAppelli.getDate("Data") %></td>
            <td data-label="Materia"><%=elencoAppelli.getString("NomeMateriaAssoc") %></td>
            <td data-label="Azione">
                <form action="Prenota" method="post" class="inline-form">
                    <input type="hidden" name="idAppello" value="<%=elencoAppelli.getInt("idAppello")%>">
                    <input type="submit" value="Prenota Appello" class="button-prenota-appello">
                </form>
            </td>
        </tr>
        <% }
        try { if (elencoAppelli != null) elencoAppelli.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (!foundAppelli) { %>
            <tr><td colspan="4" style="text-align: center;">Nessun appello disponibile per questo corso.</td></tr>
        <% } %>
        </tbody>
    </table>
    <% } %>

</div>

</body>
</html>