package com.example.spring_security.Repository;

import com.example.spring_security.Model.Users;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;


public interface UserRepo extends JpaRepository<Users, Integer> {
    @Transactional
    Users findByUsername(String username);
}
