/**
 * Created by kumar on 01-11-2016.
 */

import javax.websocket.ClientEndpoint;
import java.util.concurrent.*;

@ClientEndpoint
public class WsClient  {
    public static void main(String[] args)
    {
        Callable<String> call = new Callable<String>()
        {
            @Override
            public String call() throws Exception
            {
                while (true)
                {
                    System.out.println("sdhfsdf");
                    if(false)
                        break;
                }
                return "Saura";
            }
        };

        ExecutorService executor = Executors.newFixedThreadPool(10);
        Future<String> future = executor.submit(call);
        try
        {
            System.out.println(future.get());
        } catch (InterruptedException e)
        {


        } catch (ExecutionException e)
        {
            e.printStackTrace();
        }
        System.out.println("END");
    }

}