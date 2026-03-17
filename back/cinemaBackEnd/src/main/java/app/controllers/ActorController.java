package maxwaraxe.app.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import lombok.Setter;
import maxwaraxe.app.dao.ActorDAO;
import maxwaraxe.app.models.Actor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

@Component
@RequestMapping(value = "/actors",produces = "application/json;charset=UTF-8")
@RestController
@Setter
@Getter
public class ActorController {
    @Autowired
    ActorDAO actorDAO;

    @Autowired
    ObjectMapper objectMapper;

    @GetMapping()
    public String getAllActors() throws JsonProcessingException {
        return objectMapper.writeValueAsString(actorDAO.getAllActors());
    }

    @PostMapping("update")
    public String updateActor(@RequestBody Actor actor) throws JsonProcessingException {
        return objectMapper.writeValueAsString(actorDAO.updateActor(actor));
    }

    @PostMapping("delete")
    public String deleteActor(@RequestBody Actor actor) throws JsonProcessingException {
        return objectMapper.writeValueAsString(actorDAO.deleteActor(actor));
    }

    @PostMapping("create")
    public String createActor(@RequestBody Actor actor) throws JsonProcessingException {
        return objectMapper.writeValueAsString(actorDAO.createActor(actor));
    }
}
