package maxwaraxe.app.dao;

import lombok.Getter;
import lombok.Setter;
import maxwaraxe.app.models.Account;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Getter
@Setter
public class AccountDAO {
    @Autowired
    JdbcTemplate jdbcTemplate;

    public List<Account> getAllAccounts(){
        return jdbcTemplate.query("SELECT * FROM account",new BeanPropertyRowMapper<>(Account.class));
    }

    public Account auth(Account account){
        return jdbcTemplate.query("SELECT * FROM account WHERE account.login = ? and account.password = ?",new Object[]{account.getLogin(),account.getPassword()},new BeanPropertyRowMapper<>(Account.class)).stream().findAny().orElse(null);
    }

    public String createAccount(Account account){
        return String.valueOf(jdbcTemplate.update("INSERT INTO account (login,password,role) VALUES (?,?,?)",new Object[]{account.getLogin(),account.getPassword(),account.getRole()}));
    }

    public String updateAccount(Account account){
        return String.valueOf(jdbcTemplate.update("UPDATE account SET login=?,password=?,role=? WHERE id = ?",new Object[]{account.getLogin(),account.getPassword(),account.getRole(),account.getId()}));
    }

    public String deleteAccount(Account account){
        return String.valueOf(jdbcTemplate.update("DELETE FROM account WHERE id=?",new Object[]{account.getId()}));
    }
}
