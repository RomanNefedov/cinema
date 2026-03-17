package maxwaraxe.app.dao;

import lombok.Getter;
import lombok.Setter;
import maxwaraxe.app.mappers.ActorMapper;
import maxwaraxe.app.models.Actor;
import maxwaraxe.app.models.Actor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Setter
@Getter
public class ActorDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Actor> getAllActors(){
        return jdbcTemplate.query("SELECT *\n" +
                "FROM actor",new ActorMapper());
    }
    public String createActor(Actor actor){
        return String.valueOf(jdbcTemplate.update("INSERT INTO actor (actor_name_and_surname) VALUES (?)",new Object[]{actor.getNameAndSurname()}));
    }

    public String updateActor(Actor actor){
        return String.valueOf(jdbcTemplate.update("UPDATE actor SET actor_name_and_surname = ? WHERE actor_id = ?",new Object[]{actor.getNameAndSurname(),actor.getId()}));
    }

    public String deleteActor(Actor actor){
        return String.valueOf(jdbcTemplate.update("DELETE FROM actor WHERE actor_id=?",new Object[]{actor.getId()}));
    }
}
