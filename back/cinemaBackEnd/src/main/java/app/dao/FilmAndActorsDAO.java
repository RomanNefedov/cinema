package maxwaraxe.app.dao;

import maxwaraxe.app.models.Actor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class FilmAndActorsDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;

    public String removeAllActorsFromFilm(int filmId){
        jdbcTemplate.update("DELETE FROM acting WHERE film_id=?",new Object[]{filmId});
        return "ok";
    }

    public String insertAllActorsToFilm(List<Actor> actors, int filmId){
        removeAllActorsFromFilm(filmId);
        for(Actor actor : actors ){
            jdbcTemplate.update("INSERT INTO acting (film_id,actor_id) VALUES (?,?)",new Object[]{filmId,actor.getId()});
        }
        return "ok";
    }
}
