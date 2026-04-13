package com.cinevault.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;

@Entity
@Table(name = "movies")
@Data
public class Movie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tmdb_id", unique = true)
    private Integer tmdbId;

    @Column(nullable = false)
    private String title;

    @Column(name = "original_language")
    private String originalLanguage;

    @Column(name = "release_date")
    private LocalDate releaseDate;

    private String synopsis;

    @Column(name = "poster_url")
    private String posterUrl;

    @Column(name = "trailer_url")
    private String trailerUrl;

    @Column(name = "age_certificate")
    private String ageCertificate;

    private String status;

    @Column(name = "runtime_minutes")
    private Integer runtimeMinutes;

    private String format;

    @Column(name = "production_house")
    private String productionHouse;

    private Long budget;

    @Column(name = "box_office")
    private Long boxOffice;

    @Column(name = "aggregate_rating")
    private Double aggregateRating;
    
    // search_vector omitted as it's handled completely by PG and shouldn't be read/written standardly
}
