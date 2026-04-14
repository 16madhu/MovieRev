- [x] **Database & Cleanup**
    - [x] Drop `trg_update_movie_rating` trigger to prevent rating overwrites.
    - [x] Purge movies without posters (`poster_url` IS NULL) — deleted 44 movies.
    - [x] Clear existing reviews (698 fake reviews removed).

- [x] **DTO Enrichment**
    - [x] Update `TmdbReviewsDto.java` to support `author_details.rating` and `created_at`.

- [x] **Backend Accuracy Logic**
    - [x] Update `TmdbSyncService.java`:
        - [x] Skip movies with no `poster_path`.
        - [x] Parse real `created_at` timestamp for reviews.
        - [x] Extract real individual `rating` for reviews.
        - [x] Re-enforce `aggregate_rating` from TMDB `vote_average` after all sub-syncs.

- [x] **Re-Synchronization**
    - [x] Restart backend to trigger fresh sync cycle.
    - [x] Automated background sync initiated — 330+ movies filled so far.
    - [x] Data integrity verified via API tests.

- [x] **Frontend Accuracy**
    - [x] `MovieDetail.jsx` reviews now show real author name, real date, real per-author rating with color-coding.

- [x] **Walkthrough**
    - [x] Finalized with technical post-mortem and feature audit.
