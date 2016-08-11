

-- region Ranking examples


SELECT ts_rank(
    to_tsvector('Example document'),
    to_tsquery('Example & document')
); -- 0.099

SELECT ts_rank(
    to_tsvector('Example document'),
    to_tsquery('Example | document')
); -- 0.060


-- endregion


-- region Weight of document


SELECT setweight(to_tsvector(a.title), 'A') ||
       setweight(to_tsvector(a.content), 'B') ||
       setweight(to_tsvector(coalesce(c.name, '')), 'C')
FROM article a
  LEFT JOIN category c ON c.id = a.categoryid;


-- endregion


-- region Ranking of relevance


SELECT
  ts_rank(a.searchcache, searchquery) AS relevance,
  a.title,
  c.name AS category
FROM article a
  LEFT JOIN category c ON c.id = a.categoryid
  , plainto_tsquery(:query) searchquery
WHERE a.searchcache @@ searchquery
ORDER BY relevance DESC;


-- endregion


-- region Headline


SELECT
  ts_rank(a.searchcache, searchquery) AS relevance,
  ts_headline(a.title, searchquery),
  ts_headline(a.content, searchquery)
FROM article a,
      plainto_tsquery(:query) searchquery
WHERE a.searchcache @@ searchquery
ORDER BY relevance DESC;


-- endregion