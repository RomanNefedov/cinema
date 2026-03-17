package maxwaraxe.app.mappers;

import maxwaraxe.app.models.Ticket;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class TicketMapper implements RowMapper<Ticket> {

    @Override
    public Ticket mapRow(ResultSet rs, int rowNum) throws SQLException {
        Ticket ticket = new Ticket();
        ticket.setNumber(rs.getInt("ticket_number"));
        ticket.setSeatId(rs.getInt("seat_id"));
        ticket.setShowId(rs.getInt("show_id"));
        ticket.setResultPrice(rs.getFloat("ticket_result_price"));
        return ticket;
    }
}
