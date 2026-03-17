package maxwaraxe.app.dao;

import maxwaraxe.app.models.Country;
import maxwaraxe.app.models.Country;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class CountryDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Country> getAllCountries(){
        return jdbcTemplate.query("SELECT* FROM country",new BeanPropertyRowMapper<>(Country.class));
    }

    public String createCountry(Country country){
        return String.valueOf(jdbcTemplate.update("INSERT INTO country (country_name) VALUES (?)",new Object[]{country.getCountryName()}));
    }

    public String updateCountry(Country country){
        return String.valueOf(jdbcTemplate.update("UPDATE country SET country_name = ? WHERE country_name = ?",new Object[]{country.getCountryName(),country.getCountryName()}));
    }

    public String deleteCountry(Country country){
        return String.valueOf(jdbcTemplate.update("DELETE FROM country WHERE country_name=?",new Object[]{country.getCountryName()}));
    }
}
