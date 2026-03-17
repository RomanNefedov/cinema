package maxwaraxe.app.dao;

import maxwaraxe.app.mappers.DirectorMapper;
import maxwaraxe.app.models.Director;
import maxwaraxe.app.models.Actor;
import maxwaraxe.app.models.Director;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class DirectorDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Director> getAllDirectors(){
        return jdbcTemplate.query("SELECT *\n" +
                "FROM director",new DirectorMapper());
    }

    public String createDirector(Director director){
        return String.valueOf(jdbcTemplate.update("INSERT INTO director (director_name_and_surname) VALUES (?)",new Object[]{director.getNameAndSurname()}));
    }

    public String updateDirector(Director director){
        return String.valueOf(jdbcTemplate.update("UPDATE director SET director_name_and_surname = ? WHERE director_id = ?",new Object[]{director.getNameAndSurname(),director.getId()}));
    }

    public String deleteDirector(Director director){
        return String.valueOf(jdbcTemplate.update("DELETE FROM director WHERE director_id=?",new Object[]{director.getId()}));
    }
}
