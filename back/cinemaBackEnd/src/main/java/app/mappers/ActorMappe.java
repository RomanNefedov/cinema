package maxwaraxe.app.mappers;


import maxwaraxe.app.models.Actor;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ActorMapper implements RowMapper<Actor> {
    @Override
    public Actor mapRow(ResultSet rs, int rowNum) throws SQLException {
        Actor actor = new Actor();
        actor.setId(rs.getInt("actor_id"));
        actor.setNameAndSurname(rs.getString("actor_name_and_surname"));
        return actor;
    }
}
