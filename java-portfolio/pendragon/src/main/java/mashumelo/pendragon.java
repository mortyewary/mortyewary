package mashumelo;

//imports
import java.io.FileReader;
import javax.security.auth.login.LoginException;
import net.dv8tion.jda.api.OnlineStatus;
import net.dv8tion.jda.api.entities.Activity;
import net.dv8tion.jda.api.sharding.DefaultShardManagerBuilder;
import net.dv8tion.jda.api.sharding.ShardManager;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;


public class pendragon
{

    private final ShardManager shardManager;

    public pendragon(String apiToken) throws LoginException
    {
        DefaultShardManagerBuilder builder = DefaultShardManagerBuilder.createDefault(apiToken);
        builder.setStatus(OnlineStatus.ONLINE);
        builder.setActivity(Activity.watching("Anime"));
        shardManager = builder.build();

        //Register Event Listener
        shardManager.addEventListener(new EventListener());
        shardManager.addEventListener(new CommandManager());
    
    }

    public ShardManager getShardManager() {
        return shardManager;
    }

    public static void main(String[] args) {
        String apiToken = null; // Declare and initialize apiToken outside of the try block
    
        try {
            JSONParser parser = new JSONParser();
            Object obj = parser.parse(new FileReader("java-portfolio/pendragon/src/main/java/mashumelo/config.json"));
            JSONObject config = (JSONObject) obj;
            apiToken = (String) config.get("token"); // Initialize apiToken inside the try block
        } catch (Exception e) {
            System.out.println("ERROR: Bot Token provided is invalid!");
        }
    
        try {
            System.out.println(apiToken);
            pendragon bot = new pendragon(apiToken); // Pass apiToken as a parameter to the constructor
        } catch (LoginException e) {
            System.out.println("ERROR: Bot Token provided is invalid!");
        }
    }
}
