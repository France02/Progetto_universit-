<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>logout</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<% session.invalidate(); 
	response.sendRedirect("index.jsp");
	%>

</body>
</html>