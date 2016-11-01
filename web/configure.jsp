<%--
  Created by IntelliJ IDEA.
  User: kumar
  Date: 02-11-2016
  Time: 12:24 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Configure</title>
    <head>
        <title>$Title$</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/style.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </head>
</head>
<body>
<div class="container">
    <form action="ConfigureServlet" id="form" method="post">
        Column: <input type="text" name="x"></br>
        Row: <input type="text" name="y"></br>
        Min Player Number: <input type="text" name="min"></br>
        Max Player Number: <input type="text" name="max"></br>
        <input type="submit" value="Submit">
    </form>

</body>
</html>
