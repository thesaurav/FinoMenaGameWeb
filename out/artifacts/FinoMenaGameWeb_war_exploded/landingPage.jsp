<%@ page import="java.io.DataInputStream" %>
<%@ page import="java.io.DataOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.net.Socket" %>
<%@ page import="java.net.UnknownHostException" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="jdk.nashorn.internal.codegen.CompilerConstants" %>
<%@ page import="java.util.concurrent.*" %><%--
  Created by IntelliJ IDEA.
  User: kumar
  Date: 29-10-2016
  Time: 22:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="css/style.css" />
    <script src="js/fGame.js"></script>
</head>
<body>

<%

    String playerId = request.getAttribute("playerId").toString();
    String playerName = request.getAttribute("playerName").toString();
    String []color = request.getAttribute("color").toString().split("_");

    String [] preSet = (String[]) request.getAttribute("preSet");

    String color1 = null;
    String color2 = null;
    String color3 = null;
    color1 = color[0];
    color2 = color[1];
    color3 = color[2];

    String fColor = "\"rgb(" + color1 + "," + color2 + "," + color3 + ")\"";

    Thread thread = new Thread(new Runnable()
    {
        @Override
        public void run()
        {
            Random r =new Random();
            int port = r.nextInt(1000);
            System.out.println("port" + port);
            Socket smtpSocket = null;
            DataInputStream is = null;
            try {
                smtpSocket = new Socket("localhost", 9999);
                //os = new DataOutputStream(smtpSocket.getOutputStream());
                is = new DataInputStream(smtpSocket.getInputStream());
            } catch (UnknownHostException e) {
                System.err.println("Don't know about host: hostname");
            } catch (IOException e) {
                System.err.println("Couldn't get I/O for the connection to: hostname");
            }

            if (smtpSocket != null  && is != null) {
                try {
                    //os.writeBytes("HELO\n");
                    String responseLine;
                    while ((responseLine = is.readLine()) != null) {
                        System.out.println("Server: " + responseLine);
                        String id = "\"" + responseLine.split("&")[0] + "\"";
                        String color = "\"" + responseLine.split("&")[1] + "\"";
                        if (responseLine.indexOf("Ok") != -1) {
                            break;
                        }
                    }
                    //os.close();
                    is.close();
                    //smtpSocket.close();
                } catch (UnknownHostException e) {
                    System.err.println("Trying to connect to unknown host: " + e);
                } catch (IOException e) {
                    System.err.println("IOException:  " + e);
                }
            }
        }
    });
    thread.start();
%>

<div class="container-fluid">
    <table id="jobTable">
        <% for (int heightIndex = 0; heightIndex < 21; heightIndex++)
        {%>
        <tr>
            <% for (int widthIndex = 0; widthIndex < 25; widthIndex++)
            {
                String id = heightIndex+ "tdId" + widthIndex;
            %>
            <td class="unit" id="<%=id%>" onmouseover="onMouseover(this)" onmouseout="onMouseOut(this)" onclick="updateScore(this)">10</td>
            <% }%>
        </tr>
        <% }
            for (int index = 2; index < preSet.length; index++)
            { %>
        <script>
            var col = <%="\""+preSet[index].split("&")[1]+"\""%>;
            var id = <%="\""+preSet[index].split("&")[0]+"\""%>;
            cars.push(id);
            document.getElementById(id).style.background = col;
            console.log(col + " "+ id+" "+index);
        </script>
        <%
            }
        %>
    </table>
</div>
<script>
    function onMouseover(event)
    {
        for(var index = 0; index < cars.length; index++)
        {
            if(cars[index] == event.id)
            {
                return ;
            }
        }
        var r = <%=color1%>;
        var g = <%=color2%>;
        var b = <%=color3%>;
        var col = "rgb(" + r + "," + g + "," + b + ")";
        document.getElementById(event.id).style.background = col;
    }

    function onMouseOut(event)
    {
        for(var index = 0; index < cars.length; index++)
        {
            if(cars[index] == event.id)
            {
                return ;
            }
        }
        var col = "rgb(100, 218, 237)"; //100, 218, 237
        document.getElementById(event.id).style.background = col;
    }

    function updateScore(event)
    {
        for(var index = 0; index < cars.length; index++)
        {
            if(cars[index] == event.id)
            {
                return ;
            }
        }
        var url = "http://192.168.0.101:9090/api/FGame/updateScore/";
        var client = new XMLHttpRequest();
        client.open('POST', url, true);
        var myData= "-" + event.id + "&" + <%=fColor%>;
        client.send(myData);
        client.onreadystatechange = function() {
            if(client.status == 200 && client.response == "Success")
            {
                var r = <%=color1%>;
                var g = <%=color2%>;
                var b = <%=color3%>;
                var col = "rgb(" + r + "," + g + "," + b + ")";
                document.getElementById(event.id).style.background = col;
                var temp = 0;
                for(var index = 0; index < cars.length; index++)
                {
                    if(cars[index] == event.id)
                    {
                        temp = 1;
                    }
                }

                if(temp == 0)
                {
                    cars.push(event.id);
                }
            }
            else if(client.status == 200)
            {
                return;
            }
        };
    }
</SCRIPT>
</body>
</html>
