package maxwaraxe.app.mappers;


import maxwaraxe.app.models.Show;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ShowMapper implements RowMapper<Show> {

    @Override
    public Show mapRow(ResultSet rs, int rowNum) throws SQLException {
        Show show = new Show();
        show.setId(rs.getInt("show_id"));
        show.setHallNumber(rs.getInt("hall_number"));
        show.setFilmId(rs.getInt("film_id"));
        show.setBasePrice(Float.parseFloat(rs.getString("show_base_price")));
        show.setDuration(rs.getInt("show_duration"));
        show.setDate(rs.getTimestamp("show_datetime"));
        show.setHallType(rs.getString("hall_type"));
        return show;
    }
}
