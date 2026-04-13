package com.cinevault.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;

@Entity
@Table(name = "people")
@Data
public class Person {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tmdb_id", unique = true)
    private Integer tmdbId;

    @Column(nullable = false)
    private String name;

    @Column(name = "profile_photo_url")
    private String profilePhotoUrl;

    @Column(name = "birth_date")
    private LocalDate birthDate;

    private String nationality;

    private String biography;
}
