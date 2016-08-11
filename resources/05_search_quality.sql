

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
      ' to_tsvector(''simple'', article.title) || ' ||
      ' to_tsvector(''simple'', article.content) ' ||
      'FROM article'
  );

-- REFRESH MATERIALIZED VIEW misspell_index;

-- endregion


-- region Typo hints


-- TODO: Make possible to searching by multiple words
SELECT
  word,
  similarity
FROM misspell_index,
      similarity(word, 'twiter') AS similarity
WHERE similarity > 0.5
ORDER BY similarity DESC;

SELECT similarity('twitter', 'twiter');
SELECT similarity('winter', 'winer');


-- endregion