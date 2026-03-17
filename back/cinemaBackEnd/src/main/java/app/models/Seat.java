package maxwaraxe.app.models;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class Seat {
    private int id;
    private int hallNumber;
    private float coefficient;
    private int seatNumber;
    private int rowNumber;
}
