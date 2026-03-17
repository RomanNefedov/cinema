package maxwaraxe.app.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Setter;
import maxwaraxe.app.dao.HallDAO;
import maxwaraxe.app.models.Hall;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

@Component
@RestController
@Setter
@RequestMapping(value = "/halls",produces  = "application/json;charset=UTF-8")
public class HallController {

    @Autowired
    HallDAO hallDAO;

    @Autowired
    ObjectMapper objectMapper;

    @GetMapping()
    public String getAllHalls() throws JsonProcessingException {
        return objectMapper.writeValueAsString(hallDAO.getAllHalls());
    }

    @PostMapping("update")
    public String updateHall(@RequestBody Hall hall) throws JsonProcessingException {
        return objectMapper.writeValueAsString(hallDAO.updateHall(hall));
    }

    @PostMapping("delete")
    public String deleteHall(@RequestBody Hall hall) throws JsonProcessingException {
        return objectMapper.writeValueAsString(hallDAO.deleteHall(hall));
    }

    @PostMapping("create")
    public String createHall(@RequestBody Hall hall) throws JsonProcessingException {
        return objectMapper.writeValueAsString(hallDAO.createHall(hall));
    }
}
