package com.cinevault.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;
import java.util.Map;

@RestController
@RequestMapping("/api/reviews")
public class ReviewController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping
    public ResponseEntity<?> addReview(@RequestBody Map<String, Object> body) {
        Integer movieId = (Integer) body.get("movieId");
        Integer rating = (Integer) body.get("rating");
        String title = (String) body.get("reviewTitle");
        String reviewBody = (String) body.get("reviewBody");
        Object userIdObj = body.get("userId");
        Object sessionIdObj = body.get("sessionId");

        String sql = "INSERT INTO reviews (movie_id, user_id, session_id, rating, review_title, review_body) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            jdbcTemplate.update(sql, movieId, userIdObj, 
                                sessionIdObj != null ? UUID.fromString((String)sessionIdObj) : null, 
                                rating, title, reviewBody);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to add review: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteReview(@PathVariable Long id) {
        jdbcTemplate.update("DELETE FROM reviews WHERE id = ?", id);
        return ResponseEntity.ok().build();
    }
}
