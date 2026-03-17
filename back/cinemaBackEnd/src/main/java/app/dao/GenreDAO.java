package maxwaraxe.app.dao;

import lombok.Setter;
import maxwaraxe.app.models.Genre;
import maxwaraxe.app.models.Genre;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Setter
public class GenreDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Genre> getAllGenres(){
        return jdbcTemplate.query("SELECT* FROM genre",new BeanPropertyRowMapper<>(Genre.class));
    }

    public String createGenre(Genre genre){
        return String.valueOf(jdbcTemplate.update("INSERT INTO genre (genre_name) VALUES (?)",new Object[]{genre.getGenreName()}));
    }

    public String updateGenre(Genre genre){
        return String.valueOf(jdbcTemplate.update("UPDATE genre SET genre_name = ? WHERE genre_name = ?",new Object[]{genre.getGenreName(),genre.getGenreName()}));
    }

    public String deleteGenre(Genre genre){
        return String.valueOf(jdbcTemplate.update("DELETE FROM genre WHERE genre_name=?",new Object[]{genre.getGenreName()}));
    }
}
