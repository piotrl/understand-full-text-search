

-- region Ranking examples


SELECT ts_rank(
    to_tsvector('Example document'),
    plainto_tsquery('Example document')
); -- 0.099


-- endregion


-- region Weight of document


SELECT setweight(to_tsvector(a.title), 'A') ||
       setweight(to_tsvector(a.content), 'C') ||
       setweight(to_tsvector(coalesce(c.name, '')), 'D')
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
  , plainto_tsquery('twitter') searchquery
WHERE a.searchcache @@ searchquery
ORDER BY relevance DESC;


-- endregion


-- region Headline


SELECT
  ts_rank(a.searchcache, searchquery) AS relevance,
  ts_headline(a.title, searchquery),
  ts_headline(a.content, searchquery)
FROM article a,
      plainto_tsquery('twitter') searchquery
WHERE a.searchcache @@ searchquery
ORDER BY relevance DESC;


-- endregion