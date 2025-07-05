package com.example.spring_security.Service;
import com.example.spring_security.Model.User_Skill;
import com.example.spring_security.Repository.UsersSkillRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class UserSkillService {

    @Autowired
    private UsersSkillRepo usersSkillRepo;

    public List<User_Skill> getUserSkillExceptId(int id){
        return usersSkillRepo.findByUserIdNot((long) id);
    }

    public List<User_Skill> getUserSkillById(int id){
        return usersSkillRepo.findByUserId((long) id);
    }

    public User_Skill addUserSkill(User_Skill userSkill){
        return usersSkillRepo.save(userSkill);
    }


}
