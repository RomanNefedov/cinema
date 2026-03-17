package maxwaraxe.app.controllers;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import lombok.Setter;
import maxwaraxe.app.dao.CountryDAO;
import maxwaraxe.app.models.Country;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

@Component
@RestController
@RequestMapping(value = "/countries",produces = "application/json;charset=UTF-8")
@Setter
@Getter
public class CountryController {
    @Autowired
    CountryDAO countryDAO;

    @Autowired
    ObjectMapper objectMapper;

    @GetMapping()
    public String getAllCountries() throws JsonProcessingException {
        return objectMapper.writeValueAsString(countryDAO.getAllCountries());
    }

    @PostMapping("update")
    public String updateCountry(@RequestBody Country country) throws JsonProcessingException {
        return objectMapper.writeValueAsString(countryDAO.updateCountry(country));
    }

    @PostMapping("delete")
    public String deleteCountry(@RequestBody Country country) throws JsonProcessingException {
        return objectMapper.writeValueAsString(countryDAO.deleteCountry(country));
    }

    @PostMapping("create")
    public String createCountry(@RequestBody Country country) throws JsonProcessingException {
        return objectMapper.writeValueAsString(countryDAO.createCountry(country));
    }
}
