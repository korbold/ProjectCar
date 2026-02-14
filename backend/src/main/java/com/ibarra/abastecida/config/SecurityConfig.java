package com.ibarra.abastecida.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Security configuration. Public access for /auth/**, authenticated for the rest.
 * JWT filters are left as TODO for later implementation.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    // TODO: Add JWT filter bean when implemented
    // @Bean
    // public JwtAuthenticationFilter jwtAuthenticationFilter() { ... }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/**").permitAll()
                        .requestMatchers("/api/camiones/**").permitAll()
                        .anyRequest().authenticated());

        // TODO: Register JWT filter when implemented
        // http.addFilterBefore(jwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
