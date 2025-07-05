package com.example.spring_security.Service;
import com.example.spring_security.Model.Exchange;
import com.example.spring_security.Repository.ExchangeSkillRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class ExchangeSkillService {

    @Autowired
    private ExchangeSkillRepo exchangeSkillRepo;

    public Exchange exchnageSkillRequest(Exchange exchangerequest) {
        return exchangeSkillRepo.save(exchangerequest);
    }

    public List<Exchange> findBySenderUserId(Long userId) {
        return exchangeSkillRepo.findByUser1_id(userId);
    }

    public List<Exchange> findByReceiverUserId(Long userId) {
        return exchangeSkillRepo.findByUser2_IdAndStatusIn(userId, Arrays.asList("ACCEPTED", "PENDING"));
    }

    public ResponseEntity<String> updateStstus(Long id, String status) {
        Exchange req = exchangeSkillRepo.findById(Math.toIntExact(id)).orElseThrow();
        req.setStatus(Exchange.ExchangeStatus.valueOf(status.toUpperCase()));
        exchangeSkillRepo.save(req);
        return ResponseEntity.ok("Status updated");
    }
}
