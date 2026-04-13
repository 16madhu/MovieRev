-- =========================================================
-- VIEWS
-- =========================================================

-- view_top_bollywood - Top 10 Hindi movies by aggregate_rating this month
CREATE OR REPLACE VIEW view_top_bollywood AS
SELECT id, title, poster_url, aggregate_rating, release_date
FROM movies
WHERE original_language = 'hi' 
  AND EXTRACT(MONTH FROM release_date) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR FROM release_date) = EXTRACT(YEAR FROM CURRENT_DATE)
ORDER BY aggregate_rating DESC
LIMIT 10;

-- view_top_south_indian - Top 10 Tamil/Telugu/Malayalam/Kannada movies by aggregate_rating this month
CREATE OR REPLACE VIEW view_top_south_indian AS
SELECT id, title, poster_url, aggregate_rating, original_language, release_date
FROM movies
WHERE original_language IN ('ta', 'te', 'ml', 'kn')
  AND EXTRACT(MONTH FROM release_date) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR FROM release_date) = EXTRACT(YEAR FROM CURRENT_DATE)
ORDER BY aggregate_rating DESC
LIMIT 10;

-- view_movie_full_cast - For each movie, show all cast with character names and character type
CREATE OR REPLACE VIEW view_movie_full_cast AS
SELECT 
    m.id AS movie_id, 
    p.id AS person_id, 
    p.name AS person_name, 
    p.profile_photo_url,
    mc.character_name, 
    mc.character_type, 
    mc.screen_time_minutes
FROM movies m
JOIN movie_cast mc ON m.id = mc.movie_id
JOIN people p ON mc.person_id = p.id;

-- view_active_ott_listings - All movies active on Netflix, Prime, Hotstar
CREATE OR REPLACE VIEW view_active_ott_listings AS
SELECT 
    m.id AS movie_id, 
    m.title, 
    o.name AS platform_name, 
    mo.streaming_url, 
    mo.available_from
FROM movies m
JOIN movie_ott mo ON m.id = mo.movie_id
JOIN ott_platforms o ON mo.platform_id = o.id
WHERE mo.is_active = TRUE
  AND o.name IN ('Netflix', 'Prime Video', 'Hotstar');

-- view_most_reviewed_this_week - Top 10 movies by review count in last 7 days
CREATE OR REPLACE VIEW view_most_reviewed_this_week AS
SELECT 
    m.id AS movie_id, 
    m.title, 
    COUNT(r.id) AS review_count
FROM movies m
JOIN reviews r ON m.id = r.movie_id
WHERE r.created_at >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY m.id, m.title
ORDER BY review_count DESC
LIMIT 10;

-- view_person_filmography - For each person, all movies they appeared in with role type/character name
CREATE OR REPLACE VIEW view_person_filmography AS
SELECT 
    p.id AS person_id, 
    p.name AS person_name,
    m.id AS movie_id, 
    m.title, 
    m.release_date,
    'Cast' AS role_category,
    mc.character_name AS role_or_character
FROM people p
JOIN movie_cast mc ON p.id = mc.person_id
JOIN movies m ON mc.movie_id = m.id
UNION ALL
SELECT 
    p.id AS person_id, 
    p.name AS person_name,
    m.id AS movie_id, 
    m.title, 
    m.release_date,
    'Crew' AS role_category,
    mcr.role_type AS role_or_character
FROM people p
JOIN movie_crew mcr ON p.id = mcr.person_id
JOIN movies m ON mcr.movie_id = m.id;

-- view_user_review_stats - For each user: total reviews, avg rating, most reviewed language, joined date
CREATE OR REPLACE VIEW view_user_review_stats AS
WITH user_languages AS (
    SELECT 
        r.user_id, 
        m.original_language, 
        COUNT(*) as lang_count,
        ROW_NUMBER() OVER(PARTITION BY r.user_id ORDER BY COUNT(*) DESC) as rn
    FROM reviews r
    JOIN movies m ON r.movie_id = m.id
    WHERE r.user_id IS NOT NULL
    GROUP BY r.user_id, m.original_language
)
SELECT 
    u.id AS user_id, 
    u.username, 
    u.created_at AS joined_date,
    COUNT(r.id) AS total_reviews,
    COALESCE(AVG(r.rating), 0.00) AS avg_rating_given,
    ul.original_language AS most_reviewed_language
FROM users u
LEFT JOIN reviews r ON u.id = r.user_id
LEFT JOIN user_languages ul ON u.id = ul.user_id AND ul.rn = 1
GROUP BY u.id, u.username, u.created_at, ul.original_language;


-- =========================================================
-- FUNCTIONS AND PROCEDURES
-- =========================================================

-- Function: get_movie_recommendations
CREATE OR REPLACE FUNCTION get_movie_recommendations(input_movie_id INT)
RETURNS TABLE (
    movie_id INT,
    title VARCHAR,
    poster_url TEXT,
    aggregate_rating DECIMAL,
    score INT
) AS $$
BEGIN
    RETURN QUERY
    WITH target_movie AS (
        SELECT m.id, m.original_language, m.aggregate_rating, 
               array_agg(DISTINCT mg.genre_id) as genres,
               array_agg(DISTINCT mc.person_id) as cast_members,
               array_agg(DISTINCT mcr.person_id) FILTER (WHERE mcr.role_type = 'Director') as directors
        FROM movies m
        LEFT JOIN movie_genres mg ON m.id = mg.movie_id
        LEFT JOIN movie_cast mc ON m.id = mc.movie_id
        LEFT JOIN movie_crew mcr ON m.id = mcr.movie_id
        WHERE m.id = input_movie_id
        GROUP BY m.id, m.original_language, m.aggregate_rating
    ),
    candidate_scores AS (
        SELECT 
            m.id as cand_movie_id,
            m.title as cand_title,
            m.poster_url as cand_poster,
            m.aggregate_rating as cand_rating,
            (
                -- +3 points for each shared genre
                3 * (SELECT COUNT(*) FROM movie_genres mg1 JOIN target_movie tm ON mg1.genre_id = ANY(tm.genres) WHERE mg1.movie_id = m.id) +
                
                -- +2 points if same director
                2 * (SELECT COUNT(*) FROM movie_crew mcr1 JOIN target_movie tm ON mcr1.person_id = ANY(tm.directors) WHERE mcr1.movie_id = m.id AND mcr1.role_type = 'Director') +
                
                -- +1 point for each shared cast member
                1 * (SELECT COUNT(*) FROM movie_cast mc1 JOIN target_movie tm ON mc1.person_id = ANY(tm.cast_members) WHERE mc1.movie_id = m.id) +
                
                -- +2 points if same language
                (CASE WHEN m.original_language = (SELECT original_language FROM target_movie) THEN 2 ELSE 0 END) +
                
                -- +1 point if rating within 1.5
                (CASE WHEN abs(m.aggregate_rating - (SELECT aggregate_rating FROM target_movie)) <= 1.5 THEN 1 ELSE 0 END)
            ) as total_score
        FROM movies m
        WHERE m.id != input_movie_id
    )
    SELECT cand_movie_id, cand_title, cand_poster, cand_rating, total_score
    FROM candidate_scores
    WHERE total_score > 0
    ORDER BY total_score DESC, cand_rating DESC
    LIMIT 10;
END;
$$ LANGUAGE plpgsql;


-- Function: get_person_full_profile
CREATE OR REPLACE FUNCTION get_person_full_profile(input_person_id INT)
RETURNS TABLE (
    movie_id INT,
    title VARCHAR,
    release_date DATE,
    role_category TEXT,
    role_or_character VARCHAR,
    aggregate_rating DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT vpf.movie_id, vpf.title, vpf.release_date, vpf.role_category, vpf.role_or_character, m.aggregate_rating
    FROM view_person_filmography vpf
    JOIN movies m ON vpf.movie_id = m.id
    WHERE vpf.person_id = input_person_id
    ORDER BY vpf.release_date DESC;
END;
$$ LANGUAGE plpgsql;


-- Function: merge_guest_to_user
CREATE OR REPLACE FUNCTION merge_guest_to_user(p_session_id UUID, p_user_id INT)
RETURNS VOID AS $$
BEGIN
    -- Merge Watchlist (skip if user already has it)
    INSERT INTO watchlist (user_id, movie_id, is_watched, added_at)
    SELECT p_user_id, movie_id, is_watched, added_at
    FROM watchlist
    WHERE session_id = p_session_id
    ON CONFLICT DO NOTHING;

    -- Delete old session watchlist items after merge
    DELETE FROM watchlist WHERE session_id = p_session_id;

    -- Merge Reviews (skip if user already reviewed that movie)
    UPDATE reviews r
    SET user_id = p_user_id, session_id = NULL
    WHERE session_id = p_session_id 
      AND NOT EXISTS (
          SELECT 1 FROM reviews r2 
          WHERE r2.user_id = p_user_id 
            AND r2.movie_id = r.movie_id
      );

    -- If there are remaining reviews for this session (meaning conflict existed), delete them
    DELETE FROM reviews WHERE session_id = p_session_id;
END;
$$ LANGUAGE plpgsql;


-- =========================================================
-- RECURSIVE CTE - CO-STAR NETWORK
-- Given as a function for easy backend query
-- =========================================================
CREATE OR REPLACE FUNCTION get_costar_network(input_person_id INT)
RETURNS TABLE (
    network_degree INT,
    person_id INT,
    person_name VARCHAR,
    movie_id INT,
    movie_title VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE costar_graph AS (
        -- Base case: degree 1 (Direct co-stars)
        SELECT 
            1 AS degree,
            mc2.person_id AS costar_id,
            p2.name AS costar_name,
            m1.id AS connection_movie_id,
            m1.title AS connection_movie_title
        FROM movie_cast mc1
        JOIN movies m1 ON mc1.movie_id = m1.id
        JOIN movie_cast mc2 ON m1.id = mc2.movie_id
        JOIN people p2 ON mc2.person_id = p2.id
        WHERE mc1.person_id = input_person_id AND mc2.person_id != input_person_id

        UNION ALL

        -- Recursive case: degree 2 (Co-stars of co-stars)
        SELECT 
            cg.degree + 1 AS degree,
            mc4.person_id AS costar_id,
            p4.name AS costar_name,
            m3.id AS connection_movie_id,
            m3.title AS connection_movie_title
        FROM costar_graph cg
        JOIN movie_cast mc3 ON cg.costar_id = mc3.person_id
        JOIN movies m3 ON mc3.movie_id = m3.id
        JOIN movie_cast mc4 ON m3.id = mc4.movie_id
        JOIN people p4 ON mc4.person_id = p4.id
        WHERE cg.degree < 2 
          AND mc4.person_id != input_person_id 
          AND mc4.person_id != cg.costar_id
    )
    SELECT DISTINCT 
        degree, 
        costar_id, 
        costar_name, 
        connection_movie_id, 
        connection_movie_title
    FROM costar_graph
    ORDER BY degree ASC, costar_id ASC;
END;
$$ LANGUAGE plpgsql;
