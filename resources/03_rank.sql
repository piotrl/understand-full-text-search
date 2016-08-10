-- Ranking


-- setweight() can set 'A', 'B', 'C', 'D'


-- region Examples


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
  ts_rank(search.document, search_query) AS relevance,
  search.category,
  search.article
FROM (
       SELECT
         c.name  AS category,
         a.title AS article,
         setweight(to_tsvector(a.title), 'A') ||
         setweight(to_tsvector(a.content), 'B') ||
         setweight(to_tsvector(c.name), 'C')
                 AS document
       FROM article a
         LEFT JOIN category c ON c.id = a.categoryid
     ) search,
      plainto_tsquery(:query) search_query
WHERE search.document @@ search_query
ORDER BY relevance DESC;


-- endregion