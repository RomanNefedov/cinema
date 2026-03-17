package maxwaraxe.app.controllers;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import lombok.Setter;
import maxwaraxe.app.dao.DirectorDAO;
import maxwaraxe.app.models.Director;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

@Component
@RestController
@RequestMapping(value = "/directors",produces = "application/json;charset=UTF-8")
@Setter
@Getter
public class DirectorController {
    @Autowired
    DirectorDAO directorDAO;

    @Autowired
    ObjectMapper objectMapper;

    @GetMapping()
    public String getAllDirectors() throws JsonProcessingException {
        return objectMapper.writeValueAsString(directorDAO.getAllDirectors());
    }

    @PostMapping("update")
    public String updateDirector(@RequestBody Director director) throws JsonProcessingException {
        return objectMapper.writeValueAsString(directorDAO.updateDirector(director));
    }

    @PostMapping("delete")
    public String deleteDirector(@RequestBody Director director) throws JsonProcessingException {
        return objectMapper.writeValueAsString(directorDAO.deleteDirector(director));
    }

    @PostMapping("create")
    public String createDirector(@RequestBody Director director) throws JsonProcessingException {
        return objectMapper.writeValueAsString(directorDAO.createDirector(director));
    }
}
