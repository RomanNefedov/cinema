package maxwaraxe.app.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Setter;
import maxwaraxe.app.dao.ReportDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@RestController
@Setter
@Component
@RequestMapping(value = "/reports",produces = "application/json;charset=UTF-8")
public class ReportController {

    @Autowired
    ObjectMapper objectMapper;

    @Autowired
    ReportDAO reportDAO;

    @GetMapping(value = "/occupancy")
    public String getOccupancyReport(@RequestParam(value = "dateStart")@DateTimeFormat(pattern="yyyy-MM-dd") Date dateStart,
                                     @RequestParam(value = "dateEnd")@DateTimeFormat(pattern="yyyy-MM-dd") Date dateEnd) throws JsonProcessingException {
        return objectMapper.writeValueAsString(reportDAO.getOccupancyReport(dateStart,dateEnd));
    }

    @GetMapping(value = "/film")
    public String getFilmReport(@RequestParam(value = "dateStart")@DateTimeFormat(pattern="yyyy-MM-dd") Date dateStart,
                                     @RequestParam(value = "dateEnd")@DateTimeFormat(pattern="yyyy-MM-dd") Date dateEnd) throws JsonProcessingException {
        return objectMapper.writeValueAsString(reportDAO.getFilmReport(dateStart,dateEnd));
    }

    @GetMapping(value = "/show")
    public String getFilmReport(@RequestParam(value = "dateStart")@DateTimeFormat(pattern="yyyy-MM-dd") Date dateStart,
                                @RequestParam(value = "dateEnd")@DateTimeFormat(pattern="yyyy-MM-dd") Date dateEnd,
                                @RequestParam(value = "filmId")int filmId) throws JsonProcessingException {
        return objectMapper.writeValueAsString(reportDAO.getShowReport(dateStart,dateEnd,filmId));
    }
}
