package maxwaraxe.app.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import lombok.Setter;
import maxwaraxe.app.dao.GenreDAO;
import maxwaraxe.app.models.Genre;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Getter
@Setter
@Component
@RestController
@RequestMapping(value = "/genres",produces = "application/json;charset=UTF-8")
public class GenreController {
    @Autowired
    private GenreDAO genreDAO;

    @Autowired
    private ObjectMapper objectMapper;

    @GetMapping()
    public String getAllGenres() throws JsonProcessingException {
       return objectMapper.writeValueAsString(genreDAO.getAllGenres());
    }

    @PostMapping("update")
    public String updateGenre(@RequestBody Genre genre) throws JsonProcessingException {
        return objectMapper.writeValueAsString(genreDAO.updateGenre(genre));
    }

    @PostMapping("delete")
    public String deleteGenre(@RequestBody Genre genre) throws JsonProcessingException {
        return objectMapper.writeValueAsString(genreDAO.deleteGenre(genre));
    }

    @PostMapping("create")
    public String createGenre(@RequestBody Genre genre) throws JsonProcessingException {
        return objectMapper.writeValueAsString(genreDAO.createGenre(genre));
    }
}
