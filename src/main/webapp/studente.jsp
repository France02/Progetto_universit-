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
String messaggio = (String) request.getAttribute("successo"); // Questo è il messaggio di successo generico
String data = (String) request.getAttribute("data");
String materia2 = (String) request.getAttribute("materia2");
String idcorso = null; // Inizializzato a null per evitare potenziali errori se non assegnato

// Questo controllo deve essere fatto prima di usare 'matricola' per i dati utente
if(matricola == null){
    response.sendRedirect("index.jsp");
    return; // Interrompi l'esecuzione per evitare errori se la sessione non esiste
}
%>

    <div class="page-header">
        <div class="top-right-info">
            <span class="welcome-badge">Benvenuto studente: <%=matricola %></span>
            <a href="logout.jsp" class="logout-link">logout</a>
        </div>

        <%-- Messaggio generico (se presente), ora correttamente posizionato nel page-header --%>
        <% if(messaggio != null && !messaggio.isEmpty()){%>
            <p class="general-message">
                <%=messaggio %>
            </p>
        <%} %>
    </div>
    <div class="main-content-container">

    <% if(res != null) {%>
    <p class="section-title">Corsi disponibili:</p>
    <table border="1">
        <thead>
            <tr>
                <th>ID corso</th>
                <th>Materia</th>
                <th>Nome Docente</th>
                <th>Cognome Docente</th>
            </tr>
        </thead>
        <tbody>
        <%
        String lastIdcorsoTable1 = null; // Variabile per tenere traccia dell'ultimo idcorso
        while(res.next()){
        %>
        <tr>
            <td><%=res.getInt("idcorso") %></td>
            <td><%=res.getString("materia") %></td>
            <td><%=res.getString("nome") %></td>
            <td><%=res.getString("cognome") %></td>
        </tr>
        <% lastIdcorsoTable1 = String.valueOf(res.getInt("idcorso")); // Aggiorna l'ID corso per il max nel form
        } %>
        </tbody>
    </table>
    <form action="Prenotazione" method="post" class="form-section">
        <p>Inserisci l'ID del corso a cui vuoi iscriverti:</p>
        <%-- Usa lastIdcorsoTable1 come valore massimo dinamico, se presente --%>
        <input type="number" name="materia" placeholder="ID Corso" required min="1" <% if(lastIdcorsoTable1 != null) { %>max="<%=lastIdcorsoTable1%>"<% } %>>
        <input type="submit" value="Iscriviti al Corso">
    </form>
    <%} %>

    <% if(res1 != null) {%>
    <p class="section-title">Appelli disponibili per <%=materia%>:</p>
    <table border="1">
        <thead>
            <tr>
                <th>ID Appello</th>
                <th>Data</th>
            </tr>
        </thead>
        <tbody>
        <%
        String lastIdAppelloTable2 = null; // Variabile per tenere traccia dell'ultimo id appello
        while(res1.next()){
        %>
        <tr>
            <td><%=res1.getInt(1)%></td>
            <td><%=res1.getDate("Data") %></td>
        </tr>
        <% lastIdAppelloTable2 = String.valueOf(res1.getInt(1)); // Aggiorna l'ID appello per il max nel form
        } %>
        </tbody>
    </table>
    <form action="Prenota" method="post" class="form-section">
        <p>Inserisci l'ID dell'appello a cui vuoi prenotarti:</p>
        <%-- Usa lastIdAppelloTable2 come valore massimo dinamico, se presente --%>
        <input type="number" name="appello" placeholder="ID Appello" required min="1" <% if(lastIdAppelloTable2 != null) { %>max="<%=lastIdAppelloTable2%>"<% } %>>
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