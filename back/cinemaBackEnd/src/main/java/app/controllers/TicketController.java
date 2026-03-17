package maxwaraxe.app.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import maxwaraxe.app.dao.TicketDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

@Component
@RestController
@RequestMapping(value = "/tickets",produces = "application/json;charset=UTF-8")
public class TicketController {

    @Autowired
    private TicketDAO ticketDAO;
    @Autowired
    private ObjectMapper objectMapper;

    @GetMapping()
    public String getAllTickets() throws JsonProcessingException {
        return objectMapper.writeValueAsString(ticketDAO.getAllTickets());
    }

    @GetMapping(value = "{id}")
    public String getTicketsByShowId(@PathVariable(value = "id") int id) throws JsonProcessingException {
        return objectMapper.writeValueAsString(ticketDAO.getTicketsByShowId(id));
    }
    @PostMapping(value = "/add")
    public String addNewTicketBySeatIdAndShowId(@RequestParam("showId") int showId, @RequestParam("seatId") int seatId){
        return String.valueOf(ticketDAO.addTicketByShowIdAndSeatId(seatId,showId));
    }
}
