/**
 * How does search works?
 *
 * Full text search is set of techniques
 */


-- region Key mechanism: Stemmer


SELECT to_tsvector('impossible is nothing');

SELECT to_tsvector('impossible, impossibility, imposter');


-- endregion


-- region Under the hood


-- a)  Suffix-stripping + Eliminate casing


SELECT to_tsvector('ran != run or running');

-- b)  Parsing special tokens


SELECT to_tsvector('Sponsored by: https://goyello.com');

SELECT to_tsvector('<a href="#">HTML</a> content');

SELECT *
FROM ts_debug('<strong>HTML 5.1</strong>');


-- endregion


-- region Difference between languages


SELECT to_tsvector('english', 'It''s not a bug - it''s a feature.');
SELECT to_tsvector('dutch', 'Het is bug - niet feature.');


-- endregion


-- region Building document


SELECT to_tsvector(a.title) ||
       to_tsvector(a.content) ||
       to_tsvector(coalesce(c.name, '')) AS document
FROM article a
  LEFT JOIN category c ON c.id = a.categoryid;


-- endregion