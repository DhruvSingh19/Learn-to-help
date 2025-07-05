package com.example.spring_security.Model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class Exchange {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user1_id", nullable = false)
    private Users user1;

    @ManyToOne
    @JoinColumn(name = "user2_id", nullable = false)
    private Users user2;

    @ManyToOne
    @JoinColumn(name = "skill_offered_id", nullable = false)
    private Skill skillOffered;

    @ManyToOne
    @JoinColumn(name = "skill_requested_id", nullable = false)
    private Skill skillRequested;

    @Enumerated(EnumType.STRING)
    private ExchangeStatus status;

    private LocalDateTime proposedTime;
    private LocalDateTime actualTime;
    private Integer user1Rating;
    private Integer user2Rating;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Users getUser1() {
        return user1;
    }

    public void setUser1(Users user1) {
        this.user1 = user1;
    }

    public Users getUser2() {
        return user2;
    }

    public void setUser2(Users user2) {
        this.user2 = user2;
    }

    public Skill getSkillOffered() {
        return skillOffered;
    }

    public void setSkillOffered(Skill skillOffered) {
        this.skillOffered = skillOffered;
    }

    public Skill getSkillRequested() {
        return skillRequested;
    }

    public void setSkillRequested(Skill skillRequested) {
        this.skillRequested = skillRequested;
    }

    public ExchangeStatus getStatus() {
        return status;
    }

    public void setStatus(ExchangeStatus status) {
        this.status = status;
    }

    public LocalDateTime getProposedTime() {
        return proposedTime;
    }

    public void setProposedTime(LocalDateTime proposedTime) {
        this.proposedTime = proposedTime;
    }

    public LocalDateTime getActualTime() {
        return actualTime;
    }

    public void setActualTime(LocalDateTime actualTime) {
        this.actualTime = actualTime;
    }

    public Integer getUser1Rating() {
        return user1Rating;
    }

    public void setUser1Rating(Integer user1Rating) {
        this.user1Rating = user1Rating;
    }

    public Integer getUser2Rating() {
        return user2Rating;
    }

    public void setUser2Rating(Integer user2Rating) {
        this.user2Rating = user2Rating;
    }


    public enum ExchangeStatus {
        PENDING, ACCEPTED, COMPLETED, CANCELLED, REJECTED
    }
}