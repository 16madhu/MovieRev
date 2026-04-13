package com.cinevault.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "theatres")
@Data
public class Theatre {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String city;

    private String state;

    @Column(name = "supported_formats")
    private String supportedFormats;
}
