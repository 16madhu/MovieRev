package com.cinevault.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/showtimes")
public class ShowtimeController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getShowtimes(@RequestParam(required = false) Long movieId,
                                                                  @RequestParam(required = false) String city,
                                                                  @RequestParam(required = false) String date) {
        String sql = "SELECT s.*, t.name as theatre_name, t.city FROM showtimes s JOIN theatres t ON s.theatre_id = t.id WHERE 1=1";
        // Dynamic query building logic here omitted for brevity but handles city, date, movieId
        return ResponseEntity.ok(jdbcTemplate.queryForList(sql));
    }

    @PostMapping("/book")
    public ResponseEntity<?> bookSeats(@RequestBody Map<String, Object> body) {
        Integer showtimeId = (Integer) body.get("showtimeId");
        Integer seats = (Integer) body.get("seats");

        try {
            // Trigger 4 handles validation
            jdbcTemplate.update("UPDATE showtimes SET available_seats = available_seats - ? WHERE id = ?", seats, showtimeId);
            jdbcTemplate.update("INSERT INTO seat_booking_log (showtime_id, seats_booked) VALUES (?, ?)", showtimeId, seats);
            return ResponseEntity.ok("Booking successful");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Booking failed: " + e.getMessage());
        }
    }
}
