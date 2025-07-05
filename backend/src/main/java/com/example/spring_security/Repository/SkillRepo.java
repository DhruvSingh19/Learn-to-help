package com.example.spring_security.Repository;

import com.example.spring_security.Model.Skill;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SkillRepo extends JpaRepository<Skill, Integer> {
    @Transactional
    Skill findByName(String name);
}
