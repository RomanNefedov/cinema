package maxwaraxe.app.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.websocket.server.PathParam;
import maxwaraxe.app.dao.FilmDAO;
import maxwaraxe.app.models.Film;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;


@RestController
@Component
@RequestMapping(value = "/films", produces = "application/json;charset=UTF-8")
public class FilmController {

    private FilmDAO filmDAO;
    private ObjectMapper objectMapper;

    @Autowired
    public void setFilmDAO(FilmDAO filmDAO){
        this.filmDAO = filmDAO;
    }
    @Autowired
    public void setObjectMapper(ObjectMapper objectMapper){
        this.objectMapper = objectMapper;
    }

    @GetMapping()
    public String getAllFilms() throws JsonProcessingException {
        List<Film> listOfFilms = filmDAO.getAllFilms();
        return objectMapper.writeValueAsString(listOfFilms);
    }

    @PostMapping("/new")
    public String createNewFilm(@RequestBody Film newFilm){
        System.out.println(newFilm.toString());
        filmDAO.createNewFilm(newFilm);
        return "1";
    }

    @PostMapping("/update")
    public String updateFilm(@RequestBody Film nfilm){
        filmDAO.updateFilm(nfilm);
        return "1";
    }

    @PostMapping("delete")
    public String deleteFilm(@RequestParam("id") int id){
        filmDAO.deleteFilm(id);
        return "1";
    }

    @GetMapping("{id}")
    public String getFilmById(@PathVariable("id") Long id) throws JsonProcessingException {
        Film film = filmDAO.getFilmById(id);
        return objectMapper.writeValueAsString(film);
    }

    @GetMapping(value = "/image",produces = MediaType.IMAGE_JPEG_VALUE)
    public ResponseEntity<byte[]> getImageByPath(@RequestParam(name = "path") String path) throws IOException {
        return ResponseEntity.ok(filmDAO.getImageAbsolute(path).readAllBytes());
    }

    @PostMapping(value= "/image/new")
    public String addImage(@RequestPart(value = "image") MultipartFile multipartFile) throws IOException {
        filmDAO.addImage(multipartFile);
        return "ok";
    }
}
