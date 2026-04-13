package com.cinevault.service;

import com.cinevault.entity.Movie;
import com.cinevault.repository.MovieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.jdbc.core.JdbcTemplate;
import java.time.LocalDate;

@Service
public class TmdbSyncService {

    @Value("${app.tmdb.api-key}")
    private String apiKey;

    @Value("${app.tmdb.base-url}")
    private String baseUrl;

    @Autowired
    private MovieRepository movieRepository;
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RestTemplate restTemplate = new RestTemplate();

    public void syncBollywoodMovies() {
        // Example implementation stub
        String url = baseUrl + "/discover/movie?api_key=" + apiKey + "&with_original_language=hi&region=IN&sort_by=popularity.desc";
        // Map TMDB response and save to repository...
    }

    public void syncSouthIndianMovies() {
        String[] languages = {"ta", "te", "ml", "kn"};
        for (String lang : languages) {
            String url = baseUrl + "/discover/movie?api_key=" + apiKey + "&with_original_language=" + lang + "&region=IN";
            // Map TMDB response and save to repository...
        }
    }

    public void syncMovieDetails(Integer tmdbId) {
        String url = baseUrl + "/movie/" + tmdbId + "?api_key=" + apiKey + "&append_to_response=credits,watch/providers";
        // Fetch full details, cast, crew, and OTT streaming availability.
        // Convert to entity, fetch existing, update or insert.
    }
}
