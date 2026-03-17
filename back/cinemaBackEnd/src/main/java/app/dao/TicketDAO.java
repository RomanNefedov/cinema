package maxwaraxe.app.dao;

import lombok.Setter;
import maxwaraxe.app.mappers.SeatMapper;
import maxwaraxe.app.mappers.TicketMapper;
import maxwaraxe.app.models.Ticket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Setter
@Component
public class TicketDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Ticket> getAllTickets(){
        return jdbcTemplate.query("SELECT * FROM ticket",new TicketMapper());
    }

    public List<Ticket> getTicketsByShowId(int showId){
        return jdbcTemplate.query("SELECT * \n" +
                "FROM ticket t\n" +
                "WHERE t.show_id = ?\n",new Object[]{showId},new TicketMapper());

    }
    public int addTicketByShowIdAndSeatId(int seatId,int showId){
        return jdbcTemplate.update("call public.add_new_ticket (?, ?)", seatId, showId);
    }
}
