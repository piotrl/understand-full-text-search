/**
 * How search works?
 *
 * Full text search is set of techniques
 */


-- region Key mechanism: Stemmer


SELECT to_tsvector('impossible is nothing');

SELECT to_tsvector('impossible, impossibility, imposter');


-- endregion


-- region Tokenization


-- region a)  Suffix-stripping + Eliminate casing


SELECT to_tsvector('SCREAMING on interns'); -- ... is normal in Japan

SELECT to_tsvector('ran != run or running');

-- endregion


-- region b)   Parsing special tokens


SELECT to_tsvector('Sponsored by: https://goyello.com');

SELECT to_tsvector('<a href="http://piotrl.net/">HTML</a> content');

SELECT *
FROM ts_debug('<strong>HTML 5.1</strong>');


-- endregion


-- endregion


-- region Difference between languages


SELECT to_tsvector('english', 'It''s not a bug - it''s a feature.');
SELECT to_tsvector('dutch', 'It''s not a bug - it''s a feature.');
SELECT to_tsvector('simple', 'It''s not a bug - it''s a feature.');


-- endregion


-- region Supported languages


SELECT cfgname
FROM pg_ts_config;


-- endregion


-- regio Building document


SELECT to_tsvector(a.title) ||
       to_tsvector(a.content) ||
       to_tsvector(coalesce(c.name, '')) AS document
FROM article a
  LEFT JOIN article_category ac ON ac.articleid = a.id
  LEFT JOIN category c ON c.id = ac.categoryid;


-- endregio