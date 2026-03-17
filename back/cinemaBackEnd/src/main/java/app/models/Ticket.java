package maxwaraxe.app.models;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Ticket {
    private int number;
    private int seatId;
    private int showId;
    private float resultPrice;
}
