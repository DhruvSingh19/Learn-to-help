package com.example.spring_security.Model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.util.Set;

@Entity
public class Skill {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String name;

    private String category;

    @OneToMany(mappedBy = "skill")
    @JsonIgnore
    private Set<User_Skill> userSkills;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Set<User_Skill> getUserSkills() {
        return userSkills;
    }

    public void setUserSkills(Set<User_Skill> userSkills) {
        this.userSkills = userSkills;
    }

    // Constructors, getters, setters...
}