package com.example.spring_security.Repository;
import com.example.spring_security.Model.Exchange;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ExchangeSkillRepo extends JpaRepository<Exchange, Integer> {

    List<Exchange> findByUser1_id(Long userid);

    List<Exchange> findByUser2_IdAndStatusIn(Long userId, List<String> statuses);

    @Query("SELECT r FROM Exchange r WHERE (r.user1.id = :userId OR r.user2.id = :userId) AND r.status = 'ACCEPTED'")
    List<Exchange> findAcceptedExchangesByUser(@Param("userId") Long userId);

}
