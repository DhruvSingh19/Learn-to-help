package com.example.spring_security.Controller;
import com.example.spring_security.Model.User_Skill;
import com.example.spring_security.Service.UserSkillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@CrossOrigin
@RestController
public class UsersSkillController {

    @Autowired
    private UserSkillService userSkillService;

    @GetMapping("/getUserSkillExceptId/{id}")
    public List<User_Skill> getUserSkill(@PathVariable int id){
        return userSkillService.getUserSkillExceptId(id);
    }

    @GetMapping("/getUserSkill/{id}")
    public List<User_Skill> getUserSkillById(@PathVariable int id){
        return userSkillService.getUserSkillById(id);
    }

    @PostMapping("/addUserSkill")
    public User_Skill addUserSkill(@RequestBody User_Skill userSkill){
        return userSkillService.addUserSkill(userSkill);
    }

}
