package maxwaraxe.app.models;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.sql.Timestamp;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Show {
    private int id;
    private int hallNumber;
    private String hallType;
    private int filmId;
    private float basePrice;
    private int duration;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm")
    private Timestamp date;
}
