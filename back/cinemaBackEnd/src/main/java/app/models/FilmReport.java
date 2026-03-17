package maxwaraxe.app.models;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
public class FilmReport {
    private int filmId;
    private String filmName;
    private Date filmWorldPrimiereDate;
    private int filmDuration;
    private float sumOfMoney;
    private int amountOfTickets;
}
