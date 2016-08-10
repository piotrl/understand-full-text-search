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
       setweight(to_tsvector(c.name), 'C')
FROM article a
  JOIN article_category ac ON ac.articleid = a.id
  JOIN category c ON c.id = ac.categoryid;

-- endregion

-- region Ranking of relevance

EXPLAIN ANALYSE
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
         JOIN article_category ac ON ac.articleid = a.id
         JOIN category c ON c.id = ac.categoryid
     ) search,
      plainto_tsquery(:query) search_query
WHERE search.document @@ search_query
ORDER BY relevance DESC;

-- endregion