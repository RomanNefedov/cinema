package maxwaraxe.app.mappers;


import maxwaraxe.app.models.FilmReport;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class FilmReportMapper implements RowMapper<FilmReport> {

    @Override
    public FilmReport mapRow(ResultSet rs, int rowNum) throws SQLException {
        FilmReport filmReport = new FilmReport();

        filmReport.setFilmId(rs.getInt("film_id"));
        filmReport.setFilmName(rs.getString("film_name"));
        filmReport.setFilmWorldPrimiereDate(rs.getDate("film_world_premiere_date"));
        filmReport.setFilmDuration(rs.getInt("film_duration"));
        filmReport.setSumOfMoney(rs.getFloat("sum_of_money"));
        filmReport.setAmountOfTickets(rs.getInt("amount_of_tickets"));
        return filmReport;
    }
}
