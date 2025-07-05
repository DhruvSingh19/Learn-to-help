package com.example.spring_security.Controller;
import com.example.spring_security.Model.Student;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@CrossOrigin
@RestController
public class StudentController {

    private List<Student> studentList = new ArrayList<>(
            List.of(new Student(1, "Jay", 101),
                    new Student(2, "Tom", 102))
    );

    @GetMapping("/csrf-token")
    public CsrfToken getCsrfToken(HttpServletRequest request){
        return (CsrfToken) request.getAttribute("_csrf");
    }

    @GetMapping("/students")
    public List<Student> getStudents(){
        return studentList;
    }

    @PostMapping("/students")
    public Student addStudent(@RequestBody Student student){
        studentList.add(student);
        return student;
    }
}
