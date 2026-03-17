package maxwaraxe.app.connections;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.sql.Connection;
import java.sql.DriverManager;


@PropertySource("classpath:config.properties")
public class PostgresConnection {

    private Connection connection;

    public PostgresConnection(@Value("${postgres.dbname}") String dbname,
                              @Value("${postgres.user}")String user,
                              @Value("${postgres.password}")String password,
                              @Value("${postgres.host}")String host,
                              @Value("${postgres.port}") String port){
        try{
            connection = DriverManager.getConnection("jdbc:postgresql://"+host+":" + port + "/" + dbname, user, password);
            if(connection != null){
                System.out.println("CONNECTED TO POSTGRES");
            }
            else {
                System.out.println("CONNECTION TO POSTGRES FAILED");
            }
        }
        catch (Exception e){
            System.out.println(e);
        }
    }

    public Connection getConnection() {
        return connection;
    }
}
