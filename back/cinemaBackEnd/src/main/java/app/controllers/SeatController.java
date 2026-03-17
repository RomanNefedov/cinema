package maxwaraxe.app.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import lombok.Setter;
import maxwaraxe.app.dao.SeatDAO;
import maxwaraxe.app.models.Seat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

@Setter
@RestController
@Component
@RequestMapping(value="/seats",produces = "application/json;charset=UTF-8")
public class SeatController {

    @Autowired
    SeatDAO seatDAO;
    @Autowired
    private ObjectMapper objectMapper;

    @GetMapping(value = "{id}")
    public String getSeatsByHallNumber(@PathVariable(value = "id") int hallNumber) throws JsonProcessingException {
        return objectMapper.writeValueAsString(seatDAO.getSeatsByHallNumber(hallNumber));
    }
    @GetMapping()
    public String getSeatsByHallNumber() throws JsonProcessingException {
        return objectMapper.writeValueAsString(seatDAO.getAllSeats());
    }

    @PostMapping("update")
    public String updateSeat(@RequestBody Seat seat){
        return seatDAO.updateSeat(seat);
    }

    @PostMapping("create")
    public String createSeat(@RequestBody Seat seat){
        return seatDAO.createSeat(seat);
    }
    @PostMapping("delete")
    public String deleteSeat(@RequestBody Seat seat){
        return seatDAO.deleteSeat(seat);
    }
}
