package maxwaraxe.app.dao;

import lombok.Setter;
import maxwaraxe.app.mappers.SeatMapper;
import maxwaraxe.app.models.Seat;
import maxwaraxe.app.models.Seat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;


@Setter
@Component
public class SeatDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Seat> getSeatsByHallNumber(int hallNumber){
        return jdbcTemplate.query("SELECT st.seat_id,h.hall_number,st.seat_coefficient,st.seat_number,st.seat_row_number\n" +
                "FROM hall h LEFT JOIN seat st ON h.hall_number = st.hall_number\n" +
                "WHERE h.hall_number = ?",new Object[]{hallNumber},new SeatMapper());
    }

    public List<Seat> getAllSeats(){
        return jdbcTemplate.query("SELECT * FROM seat",new SeatMapper());
    }
    
    public String createSeat(Seat seat){
        return String.valueOf(jdbcTemplate.update("INSERT INTO seat (hall_number,seat_coefficient,seat_number,seat_row_number) VALUES (?,?,?,?)",new Object[]{seat.getHallNumber(),seat.getCoefficient(),seat.getSeatNumber(),seat.getRowNumber()}));
    }

    public String updateSeat(Seat seat){
        return String.valueOf(jdbcTemplate.update("UPDATE seat SET hall_number = ?,seat_coefficient = ?, seat_number = ?, seat_row_number = ? WHERE seat_id = ?",new Object[]{seat.getHallNumber(),seat.getCoefficient(),seat.getSeatNumber(),seat.getRowNumber(),seat.getId()}));
    }

    public String deleteSeat(Seat seat){
        return String.valueOf(jdbcTemplate.update("DELETE FROM seat WHERE seat_id=?",new Object[]{seat.getId()}));
    }
}
