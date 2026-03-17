package maxwaraxe.app.models;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.sql.Timestamp;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ShowShort {
    private int showId;
    private int hallNumber;
    private int filmId;
    private int showBasePrice;
    private int showDuration;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm")
    private Timestamp show_datetime;
}