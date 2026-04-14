# High-Fidelity Data Alignment Plan

This plan ensures that every data point in CineVault — from movie ratings to the timestamps on reviews — is an exact mirror of official TMDB records.

## Proposed Changes

### 1. Metadata Schema Refinement
I will update the TMDB Data Transfer Objects (DTOs) to capture high-resolution details currently being ignored:
- **`TmdbReviewsDto.java`**: Add Support for `created_at` (timestamp) and `author_details.rating` (individual score).

### 2. Database Integrity Cleanup
To fix the "8.0" spike and "DATA_MISSING" issues:
- **Trigger Removal**: I will **drop** the `trg_update_movie_rating` trigger. This trigger was automatically averaging review scores and overwriting official TMDB movie ratings. By removing it, the `aggregate_rating` will stay locked to the official TMDB score.
- **Image Purge**: Execute a deep clean to delete all movies that do not have a poster URL.
- **Review Reset**: Clear existing reviews to allow a fresh re-sync with correct dates and ratings.

### 3. Backend Synchronization Logic
#### [TmdbSyncService.java](file:///e:/TechBuild/MovieRev/backend/src/main/java/com/cinevault/service/TmdbSyncService.java)
- **Review Accuracy**: 
    - Parse the `created_at` string from TMDB and save it to the `created_at` column in the `reviews` table.
    - Extract the author's specific rating from `author_details` and save it.
- **Rating Preservation**:
    - Ensure `aggregateRating` is the last field saved to the movie, protecting it from being overwritten during the sync process.
- **Visual Filter**:
    - Add a strict guard: `if (movieDto.getPosterPath() == null) { skip; }`.

## Verification Plan

### Automated Verification
- Check the `reviews` table: `SELECT created_at FROM reviews LIMIT 5;` should show varied, real-world timestamps instead of "just now".
- Check the `movies` table: `SELECT aggregate_rating FROM movies;` should show precise floats (e.g., 8.6, 7.3) instead of flat 8.0.

### User Impact
- **No broken links**: All movies will have posters.
- **Authentic Feedback**: Review sections will look professional with historical dates and varied ratings.
- **Source of Truth**: The platform will reflect live TMDB data.
