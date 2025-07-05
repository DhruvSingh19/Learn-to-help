package com.example.spring_security.Config;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.cglib.proxy.NoOp;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.bind.annotation.CrossOrigin;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private JWTFilter jwtFilter;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {

    /*    httpSecurity.csrf(customizer -> customizer.disable()); //disable csrf
        httpSecurity.authorizeHttpRequests(request -> request.anyRequest().authenticated()); //enable authentication on requests since we are
        // using our own filter chain, the default one was removed

        //httpSecurity.formLogin(Customizer.withDefaults()); //enable default form login
        //need to comment because this statment and stateless session statment is contradiction


        httpSecurity.httpBasic(Customizer.withDefaults()); // to make postman work or else it will show
        // form login interface in response

        httpSecurity.sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        return httpSecurity.build();
        */


     return httpSecurity
             .csrf(AbstractHttpConfigurer::disable)
             .authorizeHttpRequests(requests -> requests
                     .requestMatchers("register", "login")
                     .permitAll()
                     .anyRequest().authenticated())
             .httpBasic(Customizer.withDefaults())
             .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
             .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
             .build();
    }


    /*
    till noew we are using username and password defined in application.properties
    static
    we need dynamic
    @Bean
    public UserDetailsService userDetailsService(){

        //inmemoryuse.... has one constructor where variable length userdetails can be passed
        // userdteails is interface so user which implements is used
        UserDetails userDetails1 = User
                .withDefaultPasswordEncoder()
                .username("tsec")
                .password("tsec@123")
                .roles("USER")
                .build();

        UserDetails userDetails2 = User
                .withDefaultPasswordEncoder()
                .username("new")
                .password("new@123")
                .roles("ADMIN")
                .build();

        return new InMemoryUserDetailsManager(userDetails2, userDetails1);
        //we need to return userdteailsservice object but since inmemory... implements userdetailsservice that object is okay
        //now defualt username and password will not work
    }
    so this thing is again using harcoded values only
    we need databse integration
     */


    /*we need to use authenticationprovider(ap) which can also connect to users database
    basically, an unauthenticated request comes to authenticationprovider which authenticates it
    therefore we do our implementation in that bean since it ap is an interface
    we are using DaoAuthen..... which extends ap
     */
    @Bean
    public AuthenticationProvider authenticationProvider(){
        DaoAuthenticationProvider daoAuthenticationProvider = new DaoAuthenticationProvider();

        daoAuthenticationProvider.setPasswordEncoder(new BCryptPasswordEncoder(12));
        //not using any password encoder

        daoAuthenticationProvider.setUserDetailsService(userDetailsService);
        //we are providing userdetailsservice which is autowired above
        //this userdetailsservice is created by us and not the default one

        return daoAuthenticationProvider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();

    }

}
