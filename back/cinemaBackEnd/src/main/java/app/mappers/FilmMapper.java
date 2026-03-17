package maxwaraxe.app.mappers;

import maxwaraxe.app.models.Actor;
import maxwaraxe.app.models.Director;
import maxwaraxe.app.models.Film;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Arrays;
import java.util.List;

@PropertySource("classpath:config.properties")
public class FilmMapper implements RowMapper<Film> {

    @Value("ip")
    private String ip;
    @Value("port")
    private String port;

    @Override
    public Film mapRow(ResultSet rs, int rowNum) throws SQLException {
        Film film = new Film();

        film.setId(rs.getInt("film_id"));
        film.setName(rs.getString("film_name"));
        film.setAgeRating(rs.getInt("film_age_rating"));
        film.setDuration(rs.getInt("film_duration"));
        film.setWorldPremiereDate(rs.getDate("film_world_premiere_date"));
        film.setImagePath(rs.getString("film_image_path"));
        film.setDescription(rs.getString("film_description"));
        film.setGenres(Arrays.asList((String[])rs.getArray("genre_list").getArray()));
        film.setCountries(Arrays.asList((String[])rs.getArray("country_list").getArray()));

        List<Integer> directorsIds = Arrays.asList((Integer[])rs.getArray("director_list_id").getArray());
        List<String> directorsNames = Arrays.asList((String[])rs.getArray("director_list_name").getArray());
        List<Director> directors = new ArrayList<>();
        for(int i = 0; i < directorsIds.size();i++){
            Director director = new Director();
            if(directorsIds.get(i) != null)
                director.setId(directorsIds.get(i));
            if(directorsNames.get(i) != null)
                director.setNameAndSurname(directorsNames.get(i));
            directors.add(director);
        }
        film.setDirectors(directors);

        List<Integer> actorsIds = Arrays.asList((Integer[])rs.getArray("actor_list_id").getArray());
        List<String> actorsNames = Arrays.asList((String[])rs.getArray("actor_list_name").getArray());
        List<Actor> actors = new ArrayList<>();
        for(int i = 0; i < actorsIds.size();i++){
            Actor actor = new Actor();
            Integer id = actorsIds.get(i);
            if(id != null) {
                actor.setId(id);
            }
            String name = actorsNames.get(i);
            if(name != null) {
                actor.setNameAndSurname(actorsNames.get(i));
            }
            actors.add(actor);
        }
        film.setActors(actors);


        return film;
    }
}
