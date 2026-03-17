package maxwaraxe.app.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import maxwaraxe.app.dao.ShowDAO;
import maxwaraxe.app.models.Show;
import maxwaraxe.app.models.ShowShort;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

@RestController
@Component
@RequestMapping(value = "/shows", produces = "application/json;charset=UTF-8")
public class ShowController {

    private ShowDAO showDAO;
    private ObjectMapper objectMapper;

    @GetMapping(value = "{date}")
    public String getShowByDate(@PathVariable("date")@DateTimeFormat(pattern="yyyy-MM-dd") Date date) throws JsonProcessingException {
        List<Show> showList = showDAO.getShowsByDate(date);
        return objectMapper.writeValueAsString(showList);
    }

    @GetMapping(value="/id/{id}")
    public String getShowById(@PathVariable("id")int id) throws JsonProcessingException{
        Show show = showDAO.getShowsById(id);
        return objectMapper.writeValueAsString(show);
    }

    @GetMapping()
    public String getShows() throws JsonProcessingException {
        return objectMapper.writeValueAsString(showDAO.getAllShows());
    }

    @PostMapping("update")
    public String updateShow(@RequestBody ShowShort show){
        return showDAO.updateShow(show);
    }

    @PostMapping("create")
    public String createShow(@RequestBody ShowShort show){
        return showDAO.createShow(show);
    }
    @PostMapping("delete")
    public String deleteShow(@RequestBody ShowShort show){
        return showDAO.deleteShow(show);
    }

    @Autowired
    public void setObjectMapper(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @Autowired
    public void setShowDAO(ShowDAO showDAO) {
        this.showDAO = showDAO;
    }
}
