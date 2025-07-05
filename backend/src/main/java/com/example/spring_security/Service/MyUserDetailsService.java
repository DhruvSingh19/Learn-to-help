package com.example.spring_security.Service;

import com.example.spring_security.Model.UserPrincipal;
import com.example.spring_security.Model.Users;
import com.example.spring_security.Repository.UserRepo;
import org.apache.catalina.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;


@Service
public class MyUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepo userRepo;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Users user = userRepo.findByUsername(username);
        if(user == null){
            System.out.println("username not found!!");
            throw new UsernameNotFoundException("Username not found!!");
        }

        return new UserPrincipal(user);
    }
}
