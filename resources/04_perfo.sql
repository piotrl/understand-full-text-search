

-- region search cache


UPDATE article
SET searchcache = setweight(to_tsvector('english', title), 'A') ||
                  setweight(to_tsvector('english', content), 'B') ||
                  setweight(to_tsvector('english', coalesce(search_data.category, '')), 'C')
FROM (SELECT
        a.id,
        c.name AS category
      FROM article a
        LEFT JOIN category c ON c.id = a.categoryid
      GROUP BY a.id, c.name) search_data
WHERE article.id = search_data.id;


-- endregion


-- region Previous search, but simpler


SELECT
  ts_rank(a.searchcache, search_query) AS relevance,
  a.title
FROM article a,
      plainto_tsquery(:query) search_query
WHERE a.searchcache @@ search_query
ORDER BY relevance DESC;


-- endregion


-- region Index


CREATE INDEX article_searchcache_index
  ON article USING GIN (searchcache);

DROP INDEX article_searchcache_index;


-- endregion


-- region Measure

SELECT setval('article_id_seq', max(id)) FROM article;

INSERT INTO article (title, content)
  SELECT
    'long article',
    'Stuur het Klantcontactcentrum twitter een e-mail of meld het incident per telefoon. Indien het incident per email naar vragen@stipter wordt verzonden verzoeken wij u zoveel mogelijk informatie te vermelden. Informatie over de browser en de processtap in de applicatie zijn gewenst. Stuur het Klantcontactcentrum een e-mail of meld het incident per telefoon. Indien het incident per email naar vragen@stipter wordt verzonden verzoeken wij u zoveel mogelijk informatie te vermelden. Informatie over de browser en de processtap in de applicatie zijn gewenst. Stuur het Klantcontactcentrum een e-mail of meld het incident per telefoon. Indien het incident per email naar vragen@stipter wordt verzonden verzoeken wij u zoveel mogelijk informatie te vermelden. Informatie over de browser en de processtap in de applicatie zijn gewenst. Stuur het Klantcontactcentrum een e-mail of meld het incident per telefoon. Indien het incident per email naar vragen@stipter wordt verzonden verzoeken wij u zoveel mogelijk informatie te vermelden. Informatie over de browser en de processtap in de applicatie zijn gewenst.'
  FROM generate_series(1, 50000);

-- endregion