package com.example.spring_security.Repository;
import com.example.spring_security.Model.User_Skill;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UsersSkillRepo extends JpaRepository<User_Skill, Integer> {
    List<User_Skill> findByUserId(Long userId);

    List<User_Skill> findByUserIdNot(Long userId);
}
