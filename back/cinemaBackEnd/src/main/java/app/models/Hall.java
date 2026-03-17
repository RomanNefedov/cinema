package maxwaraxe.app.models;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Hall {
    private int hallNumber;
    private String hallType;
    private double hallCoefficient;
}
