package maxwaraxe.app.models;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OccupancyReport {
    private int hallNumber;
    private String hallType;
    private float occupancy;
}
