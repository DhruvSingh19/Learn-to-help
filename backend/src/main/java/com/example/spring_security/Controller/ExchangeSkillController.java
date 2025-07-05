package com.example.spring_security.Controller;

import com.example.spring_security.Model.Exchange;
import com.example.spring_security.Service.ExchangeSkillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin
public class ExchangeSkillController {

    @Autowired
    private ExchangeSkillService exchangeSkillService;

    @PostMapping("/exchangerequest")
    public Exchange createExchangeRequest(@RequestBody Exchange exchangerequest){
        return exchangeSkillService.exchnageSkillRequest(exchangerequest);
    }

    @GetMapping("/sentrequest/{userId}")
    public List<Exchange> getSentRequests(@PathVariable Long userId) {
        return exchangeSkillService.findBySenderUserId(userId);
    }

    @GetMapping("/receivedrequest/{userId}")
    public List<Exchange> getReceivedRequests(@PathVariable Long userId) {
        return exchangeSkillService.findByReceiverUserId(userId);
    }

    @PutMapping("/updatestatus/{id}")
    public ResponseEntity<String> updateStatus(@PathVariable Long id, @RequestParam String status) {
        return exchangeSkillService.updateStstus(id, status);
    }

}
