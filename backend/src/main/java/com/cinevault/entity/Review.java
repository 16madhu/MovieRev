package com.cinevault.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "reviews")
@Data
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "movie_id", nullable = false)
    private Movie movie;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "session_id")
    private UUID sessionId;

    @Column(nullable = false)
    private Integer rating;

    @Column(name = "review_title")
    private String reviewTitle;

    @Column(name = "review_body")
    private String reviewBody;

    private String sentiment;

    @Column(name = "helpful_votes")
    private Integer helpfulVotes = 0;

    @Column(name = "is_reported")
    private Boolean isReported = false;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
