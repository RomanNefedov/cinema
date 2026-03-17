package maxwaraxe.app.dao;

import lombok.Setter;
import maxwaraxe.app.mappers.FilmReportMapper;
import maxwaraxe.app.mappers.ShowMapper;
import maxwaraxe.app.models.FilmReport;
import maxwaraxe.app.models.OccupancyReport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import maxwaraxe.app.models.Show;

import java.util.Date;
import java.util.List;

@Component
@Setter
public class ReportDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<OccupancyReport> getOccupancyReport(Date dateStart, Date dateEnd){
        return jdbcTemplate.query("SELECT\n" +
                "tmp.hall_number,tmp.hall_type,avg(tmp.k)/tmpall.all as \"occupancy\" FROM\n" +
                "(SELECT H.hall_number,H.hall_type,H.hall_coefficient,SH.show_id,count(S.seat_id)\n" +
                "as k FROM hall H left join seat S on S.hall_number = H.hall_number inner join\n" +
                "ticket T on T.seat_id = S.seat_id inner join show SH on T.show_id = SH.show_id\n" +
                "WHERE SH.show_datetime >= ? and SH.show_datetime <= ?\n" +
                "GROUP BY H.hall_number,SH.show_id ORDER BY H.hall_number) tmp inner join (SELECT\n" +
                "H.hall_number as k,COUNT(S.*) as \"all\" FROM hall H left join seat S on\n" +
                "S.hall_number = H.hall_number GROUP BY H.hall_number ORDER BY H.hall_number)\n" +
                "tmpall on tmpall.k = tmp.hall_number GROUP BY\n" +
                "tmp.hall_number,tmp.hall_type,tmpall.all",new Object[]{dateStart,dateEnd},new BeanPropertyRowMapper<>(OccupancyReport.class));
    }

    public List<FilmReport> getFilmReport(Date dateStart,Date dateEnd){
        return jdbcTemplate.query("SELECT F.film_id,F.film_name,F.film_world_premiere_date,F.film_duration,sum(T.ticket_result_price) as \"sum_of_money\",count(T.*) as \"amount_of_tickets\" FROM film F\n" +
                "left join show S on S.film_id = F.film_id left join ticket T on T.show_id =\n" +
                "S.show_id WHERE S.show_datetime >= ? and S.show_datetime <= ? GROUP BY F.film_id",new Object[]{dateStart,dateEnd},new FilmReportMapper());
    }

    public List<Show> getShowReport(Date dateStart, Date dateEnd,int filmId){
        return jdbcTemplate.query("SELECT S.*,h.hall_type FROM show S INNER JOIN film F on F.film_id = S.film_id LEFT JOIN hall h on h.hall_number = s.hall_number WHERE F.film_id = ? AND S.show_datetime >= ?\n" +
                "and S.show_datetime <= ? ORDER BY S.show_datetime",new Object[]{filmId,dateStart,dateEnd},new ShowMapper());
    }
}
