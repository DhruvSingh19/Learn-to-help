package com.example.spring_security.Controller;
import com.example.spring_security.Model.Users;
import com.example.spring_security.Repository.UserRepo;
import com.example.spring_security.Service.JWTService;
import com.example.spring_security.Service.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin
@RestController
public class UsersController {

    @Autowired
    private UsersService usersService;

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private JWTService jwtService;

    @PostMapping("/register")
    public String[] register(@RequestBody Users user){
        try {
            Users savedUser = usersService.registerUsers(user);
            if(savedUser != null) {
                return new String[]{jwtService.generateToken(savedUser.getUsername()), String.valueOf(userRepo.findByUsername(user.getUsername()).getId())};
            }
            return new String[]{"Cannot Save User"};
        }catch (Exception e){
            return new String[]{e.toString()};
        }
    }

    @PostMapping("/login")
    public String[] login(@RequestBody Users user){
        return new String[]{usersService.verify(user), String.valueOf(userRepo.findByUsername(user.getUsername()).getId())};
    }

    @GetMapping("/getUserProfile/{id}")
    public Users getUserById(@PathVariable int id) {
        return userRepo.findById(id).orElse(null);
    }

    @PutMapping("/updateUserProfile/{id}")
    public ResponseEntity<?> updateUser(@PathVariable int id, @RequestBody Users userDetails) {
        return usersService.updateUser(userDetails, id);
    }
}
