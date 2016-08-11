-- region Simple queries


SELECT to_tsquery('winner & EURO');
SELECT to_tsquery('winner & !RIO');
SELECT to_tsquery('(gas | diesel) & bikes');

SELECT to_tsquery('POLAND CAN''T INTO SPACE');
SELECT plainto_tsquery('POLAND CAN''T INTO SPACE');


-- endregion


-- region Searching


SELECT to_tsvector('Running in the dark!') @@ plainto_tsquery('run');

SELECT to_tsvector('You are the winner!') @@ plainto_tsquery('who is the winner?');

SELECT to_tsvector('You are the winner!') @@ plainto_tsquery('Looking for a winner...');

SELECT plainto_tsquery('who is the winner?');

SELECT plainto_tsquery('Looking for winner');


-- endregion


-- region Searching for real


SELECT search.content
FROM (SELECT
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


-- no simple way for weights and ranking
-- added support for InnoDB tables in MySQL 5.6


-- endregion


-- region Multi table search

SELECT
  search.category,
  search.title,
  search.content
FROM (
       SELECT
         a.*,
         c.name AS category,
         to_tsvector(coalesce(a.title, '')) ||
         to_tsvector(coalesce(a.content, '')) ||
         to_tsvector(coalesce(c.name, ''))
                AS document
       FROM article a
         LEFT JOIN category c ON c.id = a.categoryid
     ) search
WHERE search.document @@ plainto_tsquery('witcher');

-- Remember to add coalesce() for strings
-- Concatenate tsvectors instead of strings


-- endregion