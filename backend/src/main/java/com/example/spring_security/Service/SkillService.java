package com.example.spring_security.Service;
import com.example.spring_security.Model.Skill;
import com.example.spring_security.Repository.SkillRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SkillService {

    @Autowired
    private SkillRepo skillRepo;

    public Skill addSkill(Skill skill){
        return skillRepo.save(skill);
    }

    public List<Skill> getSkills(){
        return skillRepo.findAll();
    }

}
