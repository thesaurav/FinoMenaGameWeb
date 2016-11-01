<%@ page import="java.util.Random" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="jdk.nashorn.internal.codegen.CompilerConstants" %>
<%@ page import="java.util.concurrent.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %><%--
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

<%!
    int x = 21;
    int y = 25;
public String getTableXY()
{
    try {
        URL url = new URL("http://localhost:9090/api/FGame/tableWidth");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");


        OutputStream os = conn.getOutputStream();
        os.write("temp".getBytes());
        os.flush();

        if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
            throw new RuntimeException("Failed : HTTP error code : "
                    + conn.getResponseCode());
        }

        BufferedReader br = new BufferedReader(new InputStreamReader(
                (conn.getInputStream())));

        String output = br.readLine();

        return output;
    }
    catch (MalformedURLException e)
    {
        e.printStackTrace();
    }
    catch (IOException e)
    {
        e.printStackTrace();
    }

    return null;
}
%>
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
    String []dim = getTableXY().split(":");
    if(dim.length > 1)
    {
        x = Integer.parseInt(dim[0]);
        y = Integer.parseInt(dim[1]);
    }
%>

<div class="container-fluid">
    <div class="col-sm-15" style="background-color:lavender;">
        <div id="Name">Name: <%=playerName%>   Score: 0</div>
    </div>
    <table id="jobTable">
        <% for (int heightIndex = 0; heightIndex < x; heightIndex++)
        {%>
        <tr>
            <% for (int widthIndex = 0; widthIndex < y; widthIndex++)
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
        var myData= "-" + event.id + "&" + <%=fColor%> + ":" + <%="\""+playerId+"\""%>;
        client.send(myData);
        client.onreadystatechange = function() {
            if(client.status == 200 && client.response != 0)
            {
                var r = <%=color1%>;
                var g = <%=color2%>;
                var b = <%=color3%>;
                var col = "rgb(" + r + "," + g + "," + b + ")";
                document.getElementById(event.id).style.background = col;
                var show = "Name :" + <%="\""+playerName+"\""%> + "                                           Score:" + client.response;
                document.getElementById("Name").innerHTML = show;
                console.log(event.id + "    click " + col);
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
        };
    }

    this.timer = setInterval('update()', 1000);
    function update(event)
    {
        var url = "http://192.168.0.101:9090/api/FGame/dynamic/";
        var client = new XMLHttpRequest();
        client.open('GET', url, true);
        client.send(null);
        client.onreadystatechange = function() {
            if(client.status == 200 && client.responseText != "")
            {
                var res = client.response.split(":");
                for(var index = 0; index < res.length; index++)
                {
                    var arr = res[index].split("&");
                    if(arr.length > 1)
                    {
                        document.getElementById(arr[0]).style.background = arr[1];

                        var temp = 0;
                        for(var count = 0; count < cars.length; count++)
                        {
                            if(cars[count] == arr[0])
                            {
                                temp = 1;
                            }
                        }
                        if(temp == 0)
                        {
                            cars.push(arr[0]);
                        }

                    }
                }
            }
        };
    }

</SCRIPT>
</body>
</html>
