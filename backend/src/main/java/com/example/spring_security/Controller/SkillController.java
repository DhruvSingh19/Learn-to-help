package com.example.spring_security.Controller;

import com.example.spring_security.Model.Skill;
import com.example.spring_security.Service.SkillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@CrossOrigin
@RestController
public class SkillController {

    @Autowired
    private SkillService skillService;

    @GetMapping("/getSkills")
    public List<Skill> getListOfSkills(){
        return skillService.getSkills();
    }

    @PostMapping("/addSkill")
    public Skill addSkill(@RequestBody Skill skill){
        System.out.println(skill.getName());
        return skillService.addSkill(skill);
    }

}
