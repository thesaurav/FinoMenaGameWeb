import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by kumar on 30-10-2016.
 */
@WebServlet(name = "RegisterUserServlet")
public class RegisterUserServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        try {
            URL url = new URL("http://localhost:9090/api/FGame/add");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");

            String playerName = request.getParameter("PName");
            String input = "{\n" +
                    "\"playerId\" : \"\",\n" +
                    "\"playerName\" : \"" + playerName + "\",\n" +
                    "\"score\" : 0,\n" +
                    "\"ip\":\"1.1.1.1\"\n" +
                    "}";

            OutputStream os = conn.getOutputStream();
            os.write(input.getBytes());
            os.flush();

            if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
                throw new RuntimeException("Failed : HTTP error code : "
                        + conn.getResponseCode());
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(
                    (conn.getInputStream())));

            String output = br.readLine();

            if(output == null)
            {
                request.getRequestDispatcher("index.jsp").forward(request,response);
            }
            String []restAttr = output.split("-");
            conn.disconnect();

            request.setAttribute("playerId", restAttr[0]);
            request.setAttribute("playerName", playerName);
            request.setAttribute("color", restAttr[1]);
            request.setAttribute("preSet", restAttr);
            //HttpServletResponse.sendRedirect("landingPage.jsp");
            request.getRequestDispatcher("landingPage.jsp").forward(request,response);
        }
        catch (MalformedURLException e)
        {
            e.printStackTrace();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
    }
}
