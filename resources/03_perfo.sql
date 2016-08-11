

-- region Previous search, but simpler


SELECT
  c.name,
  a.title,
  a.content
FROM article a
  LEFT JOIN category c ON c.id = a.categoryid
WHERE a.searchcache @@ plainto_tsquery(:query);


-- endregion


-- region MOAR RECORDS


SELECT setval('article_id_seq', max(id))
FROM article;

INSERT INTO article (title, content)
  SELECT
    'long article #' || generate_series,
    'Stuur het Klantcontactcentrum twitter een e-mail of meld het incident per telefoon. Indien het incident per email naar vragen@stipter wordt verzonden verzoeken wij u zoveel mogelijk informatie te vermelden. Informatie over de browser en de processtap in de applicatie zijn gewenst. Stuur het Klantcontactcentrum een e-mail of meld het incident per telefoon. Indien het incident per email naar vragen@stipter wordt verzonden verzoeken wij u zoveel mogelijk informatie te vermelden. Informatie over de browser en de processtap in de applicatie zijn gewenst. Stuur het Klantcontactcentrum een e-mail of meld het incident per telefoon. Indien het incident per email naar vragen@stipter wordt verzonden verzoeken wij u zoveel mogelijk informatie te vermelden. Informatie over de browser en de processtap in de applicatie zijn gewenst. Stuur het Klantcontactcentrum een e-mail of meld het incident per telefoon. Indien het incident per email naar vragen@stipter wordt verzonden verzoeken wij u zoveel mogelijk informatie te vermelden. Informatie over de browser en de processtap in de applicatie zijn gewenst.'
  FROM generate_series(1, 10000);


-- endregion

-- region search cache update


UPDATE article
SET searchcache = to_tsvector('english', title) ||
                  to_tsvector('english', content) ||
                  to_tsvector('english', coalesce(search_data.category, ''))
FROM (SELECT
        a.id,
        c.name AS category
      FROM article a
        LEFT JOIN category c ON c.id = a.categoryid) search_data
WHERE article.id = search_data.id;


-- endregion


-- region Index


CREATE INDEX article_searchcache_index
  ON article USING GIN (searchcache);


-- endregion

-- region results


-- Query with building document:
-- Planning time:   0.665 ms
-- Execution time:  27s

-- With search cache:
-- Planning time:   0.5 - 1 ms
-- Execution time:  170 - 240ms

-- Witch search cache + index:
-- Planning time:   0.6 - 1.3ms
-- Execution time:  0.2 - 0.6 ms


-- endregion