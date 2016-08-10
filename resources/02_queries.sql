-- region Simple queries


SELECT to_tsquery('winner & EURO');
SELECT to_tsquery('winner & !RIO');
SELECT to_tsquery('(gas | diesel) & american');

SELECT plainto_tsquery('cars in gas or diesel');


-- endregion


-- region Searching


SELECT to_tsvector('Running in the dark!') @@ plainto_tsquery('run');

SELECT to_tsvector('You are the winner!') @@ plainto_tsquery('who is the winner?');

SELECT to_tsvector('You are the winner!') @@ plainto_tsquery('Looking for a winner...');


-- endregion


-- region  plainto_tsquery once again


SELECT plainto_tsquery('who is the winner?');
SELECT plainto_tsquery('Looking for winner');


-- endregion


-- region Searching for real


SELECT *
FROM (
       SELECT
         a.*,
         to_tsvector(a.title) || to_tsvector(a.content) AS document
       FROM article a
     ) search
WHERE
  search.document @@ plainto_tsquery('type system');


-- endregion


-- region How it looks in MySQL?


SELECT *
FROM article
WHERE MATCH(title, content)
AGAINST ('query' IN NATURAL LANGUAGE MODE );


-- simpler query
-- no simple way for weights and ranking
-- from MySQL 5.6 supports InnoDB


-- endregion


-- region Multi table search

SELECT *
FROM (
       SELECT
         c.name,
         a.*,
         to_tsvector(coalesce(a.title, '')) ||
         to_tsvector(coalesce(a.content, '')) ||
         to_tsvector(coalesce(c.name, ''))
           AS document
       FROM article a
         JOIN article_category ac ON ac.articleid = a.id
         JOIN category c ON c.id = ac.categoryid
     ) search
WHERE search.document @@ plainto_tsquery('twitter');

-- Remember to add coalesce() for strings
-- Concatenate tsvectors instead of strings


-- endregion