

-- region Headline


SELECT
  ts_rank(a.searchcache, search_query) AS relevance,
  a.title,
  ts_headline(a.title, search_query),
  ts_headline(a.content, search_query)
FROM article a,
      plainto_tsquery(unaccent(:query)) search_query
WHERE a.searchcache @@ search_query
ORDER BY relevance DESC;


-- endregion


-- region Language extensions
-- Note: requires admin privileges


CREATE EXTENSION unaccent;
CREATE EXTENSION pg_trgm;


-- endregion

-- region unaccent() remove national characters


SELECT unaccent('bądź łaskawy');

SELECT unaccent('With wide support');

SELECT unaccent('我要打破这个');


-- endregion


-- region similarity() for misspelling


-- a) the same words, different formatting

SELECT similarity('Something', 'something');

-- b) Multiple words

SELECT similarity('Something different', 'samething diferent');

-- c) Different words, common part

SELECT similarity('Something', 'everything');


-- endregion


-- region similarity in practise


-- List of misspelled words
CREATE MATERIALIZED VIEW misspell_index AS
  SELECT word
  FROM ts_stat(
      'SELECT ' ||
      ' to_tsvector(''simple'', article.content) ' ||
      'FROM article'
  );

-- REFRESH MATERIALIZED VIEW misspell_index;
-- DROP MATERIALIZED VIEW IF EXISTS misspell_index;


-- Query


SELECT plainto_tsquery('zoveel and surprise');

-- TODO: Make possible to searching by multiple words
SELECT word
FROM misspell_index
WHERE similarity(word, 'wintr') BETWEEN 0.5 AND 0.99
LIMIT 1;

SELECT similarity('winter', 'wintr');
SELECT similarity('zoveel', 'zoveel and surprise');


-- endregion