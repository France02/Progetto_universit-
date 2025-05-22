<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Area Professori</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

<%
String nomeProfessore = (String)session.getAttribute("nomeProfessore"); 
String matricolaProf = (String)session.getAttribute("matricolaProfessore"); 
String messaggioProf = (String) request.getAttribute("messaggioProfessore"); 

ResultSet elencoAppelliProf = (ResultSet) request.getAttribute("elenco_appelli_prof"); 
ResultSet elencoStudenti = (ResultSet) request.getAttribute("elenco_studenti");

if(matricolaProf == null){ 
    response.sendRedirect("index.jsp"); 
    return;
}
%>

    <div class="page-header">
        <div class="top-right-info">
            <span class="welcome-badge">Benvenuto Prof. <%=nomeProfessore != null ? nomeProfessore : matricolaProf %></span>
            <a href="index.jsp" class="logout-link">logout</a> 
        </div>
        <% if(messaggioProf != null && !messaggioProf.isEmpty()) { %>
            <p class="general-message"><%= messaggioProf %></p>
        <% } %>
    </div>
    <div class="main-content-container">
    <p class="section-title">Appelli che Insegni:</p>
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
        boolean foundProfAppelli = false;
        if(elencoAppelliProf != null) {
            while(elencoAppelliProf.next()){
                foundProfAppelli = true;
        %>
        <tr>
            <td data-label="ID Appello"><%=elencoAppelliProf.getInt("idAppello")%></td>
            <td data-label="Data"><%=elencoAppelliProf.getDate("Data") %></td>
            <td data-label="Materia"><%=elencoAppelliProf.getString("NomeMateriaCorso") %></td> 
            <td data-label="Azione">
                <form action="GestisciAppelloServlet" method="post" class="inline-form"> 
                    <input type="hidden" name="idAppello" value="<%=elencoAppelliProf.getInt("idAppello")%>">
                    <input type="submit" value="Gestisci" class="button-manage-appello">
                </form>
            </td>
        </tr>
        <% }
        try { if (elencoAppelliProf != null) elencoAppelliProf.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (!foundProfAppelli) { %>
            <tr><td colspan="4" style="text-align: center;">Nessun appello associato a te.</td></tr>
        <% } %>
        </tbody>
    </table>

    <p class="section-title">Elenco Studenti:</p>
    <table border="1">
        <thead>
            <tr>
                <th>Matricola</th>
                <th>Nome</th>
                <th>Cognome</th>
            </tr>
        </thead>
        <tbody>
        <%
        boolean foundStudents = false;
        if(elencoStudenti != null) {
            while(elencoStudenti.next()){
                foundStudents = true;
        %>
        <tr>
            <td data-label="Matricola"><%=elencoStudenti.getString("matricola")%></td>
            <td data-label="Nome"><%=elencoStudenti.getString("nome")%></td>
            <td data-label="Cognome"><%=elencoStudenti.getString("cognome")%></td>
        </tr>
        <% }
        try { if (elencoStudenti != null) elencoStudenti.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (!foundStudents) { %>
            <tr><td colspan="3" style="text-align: center;">Nessuno studente nel sistema.</td></tr>
        <% } %>
        </tbody>
    </table>
    
</div>

</body>
</html>