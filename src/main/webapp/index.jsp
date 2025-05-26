<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Accedi al Sistema</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

<div class="login-container">
    <h3>Accedi al Sistema</h3>
    
    <% 
        // Recupera e mostra eventuali messaggi di errore dal Servlet
        String errorMessage = (String) request.getAttribute("messaggioErrore");
        if (errorMessage != null && !errorMessage.isEmpty()) {
            out.println("<p class='error-message'>" + errorMessage + "</p>");
        }
    %>
    <form action="login" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        
        <div class="radio-group">
            <input type="radio" id="professore" name="userType" value="professore" checked>
            <label for="professore">Professore</label>
            
            <input type="radio" id="studente" name="userType" value="studente">
            <label for="studente">Studente</label>
        </div>
        
        <input type="submit" value="Accedi">
    </form>
</div>

</body>
</html>