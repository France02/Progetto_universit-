<%@ page language="java" contentType="text/html; charset=ISO-8859-1"pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">

<title>Accedi al Sistema</title>
<link rel="stylesheet" href="css/style.css">

</head>
<body>

    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>

    <div class="login-form">
        <h2>Accedi al Sistema</h2>
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <p style="color: red;"><%= errorMessage %></p>
        <% } %>
        <form action="LoginServlet" method="post">
            Username: <input type="text" name="username" required><br>
            Password: <input type="password" name="password" required><br><br>
            <input type="radio" name="tipoUtente" value="professore" checked> Professore
            <input type="radio" name="tipoUtente" value="studente"> Studente<br><br>
            <input type="submit" value="Accedi" class="button-login">
        </form>
    </div>

</body>
</html>