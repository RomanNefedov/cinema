package maxwaraxe.app.mappers;

import maxwaraxe.app.models.Seat;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class SeatMapper implements RowMapper<Seat> {

    @Override
    public Seat mapRow(ResultSet rs, int rowNum) throws SQLException {
        Seat seat = new Seat();
        seat.setId(rs.getInt("seat_id"));
        seat.setHallNumber(rs.getInt("hall_number"));
        seat.setSeatNumber(rs.getInt("seat_number"));
        seat.setCoefficient(rs.getFloat("seat_coefficient"));
        seat.setRowNumber(rs.getInt("seat_row_number"));
        return seat;
    }
}
