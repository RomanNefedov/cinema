package maxwaraxe.app.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class FilmAndGenresDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;


    public String removeAllGenresFromFilm(int filmId){
        jdbcTemplate.update("DELETE FROM contained WHERE film_id=?",new Object[]{filmId});
        return "ok";
    }

    public String insertAllGenresToFilm(List<String> genres,int filmId){
        removeAllGenresFromFilm(filmId);
        for(String genre : genres ){
            jdbcTemplate.update("INSERT INTO contained (film_id,genre_name) VALUES (?,?)",new Object[]{filmId,genre});
        }
        return "ok";
    }
}
