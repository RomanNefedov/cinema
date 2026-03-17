package maxwaraxe.app.dao;

import lombok.Getter;
import lombok.Setter;
import maxwaraxe.app.models.Hall;
import maxwaraxe.app.models.Hall;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Setter
@Getter
public class HallDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;

    public List<Hall> getAllHalls(){
        return jdbcTemplate.query("SELECT * FROM hall",new BeanPropertyRowMapper<>(Hall.class));
    }

    public String createHall(Hall hall){
        return String.valueOf(jdbcTemplate.update("INSERT INTO hall (hall_type,hall_coefficient) VALUES (?,?)",new Object[]{hall.getHallType(),hall.getHallCoefficient()}));
    }

    public String updateHall(Hall hall){
        return String.valueOf(jdbcTemplate.update("UPDATE hall SET hall_type = ?,hall_coefficient = ? WHERE hall_number = ?",new Object[]{hall.getHallType(),hall.getHallCoefficient(),hall.getHallNumber()}));
    }

    public String deleteHall(Hall hall){
        return String.valueOf(jdbcTemplate.update("DELETE FROM hall WHERE hall_number=?",new Object[]{hall.getHallNumber()}));
    }
}
