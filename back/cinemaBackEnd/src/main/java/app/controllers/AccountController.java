package maxwaraxe.app.controllers;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import lombok.Setter;
import maxwaraxe.app.dao.AccountDAO;
import maxwaraxe.app.models.Account;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

@Component
@RestController
@RequestMapping(value = "/accounts",produces = "application/json;charset=UTF-8")
@Setter
@Getter
public class AccountController {
    @Autowired
    AccountDAO accountDAO;

    @Autowired
    ObjectMapper objectMapper;

    @GetMapping()
    public String getAllAccounts() throws JsonProcessingException {
        return objectMapper.writeValueAsString(accountDAO.getAllAccounts());
    }
    @PostMapping("auth")
    public Account auth(@RequestBody Account account){
        System.out.println(account);
        return accountDAO.auth(account);
    }
    @PostMapping("update")
    public String updateAccount(@RequestBody Account account) throws JsonProcessingException {
        return objectMapper.writeValueAsString(accountDAO.updateAccount(account));
    }

    @PostMapping("delete")
    public String deleteAccount(@RequestBody Account account) throws JsonProcessingException {
        return objectMapper.writeValueAsString(accountDAO.deleteAccount(account));
    }

    @PostMapping("create")
    public String createAccount(@RequestBody Account account) throws JsonProcessingException {
        return objectMapper.writeValueAsString(accountDAO.createAccount(account));
    }
}
