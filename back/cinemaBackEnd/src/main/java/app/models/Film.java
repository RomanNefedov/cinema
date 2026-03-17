package maxwaraxe.app.models;

import lombok.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Film {
    private Integer id;
    private String name;
    private Date worldPremiereDate;
    private Integer duration;
    private Integer ageRating;
    private String imagePath;
    private String description;
    private List<String> genres = new ArrayList<String>();
    private List<Director> directors = new ArrayList<Director>();
    private List<Actor> actors = new ArrayList<Actor>();
    private List<String> countries = new ArrayList<String>();
}
