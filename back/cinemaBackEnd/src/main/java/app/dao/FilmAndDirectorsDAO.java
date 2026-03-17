package maxwaraxe.app.dao;

import maxwaraxe.app.models.Director;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class FilmAndDirectorsDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;

    public String removeAllDirectorsFromFilm(int filmId){
        jdbcTemplate.update("DELETE FROM direct WHERE film_id=?",new Object[]{filmId});
        return "ok";
    }

    public String insertAllDirectorsToFilm(List<Director> directors, int filmId){
        removeAllDirectorsFromFilm(filmId);
        for(Director director : directors ){
            jdbcTemplate.update("INSERT INTO direct (film_id,director_id) VALUES (?,?)",new Object[]{filmId,director.getId()});
        }
        return "ok";
    }
}
