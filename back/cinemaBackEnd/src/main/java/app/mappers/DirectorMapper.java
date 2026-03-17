package maxwaraxe.app.mappers;

import maxwaraxe.app.models.Director;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class DirectorMapper implements RowMapper<Director> {
    @Override
    public Director mapRow(ResultSet rs, int rowNum) throws SQLException {
        Director director = new Director();
        director.setId(rs.getInt("director_id"));
        director.setNameAndSurname(rs.getString("director_name_and_surname"));
        return director;
    }
}
