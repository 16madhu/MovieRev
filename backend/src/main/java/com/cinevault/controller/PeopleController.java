package com.cinevault.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/people")
public class PeopleController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getPerson(@PathVariable Long id) {
        String queryPerson = "SELECT * FROM people WHERE id = ?";
        Map<String, Object> person = jdbcTemplate.queryForMap(queryPerson, id);

        String queryFilmography = "SELECT * FROM get_person_full_profile(?)";
        List<Map<String, Object>> filmography = jdbcTemplate.queryForList(queryFilmography, id);
        
        person.put("filmography", filmography);
        return ResponseEntity.ok(person);
    }

    @GetMapping("/{id}/costar-network")
    public ResponseEntity<List<Map<String, Object>>> getCostarNetwork(@PathVariable Long id) {
        String sql = "SELECT * FROM get_costar_network(?)";
        return ResponseEntity.ok(jdbcTemplate.queryForList(sql, id));
    }
}
