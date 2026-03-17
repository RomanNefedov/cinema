package maxwaraxe.app.models;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Account {
    private int id;
    private String login;
    private String password;
    private int role;
}
