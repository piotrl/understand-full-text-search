

-- region Clear database


DROP EXTENSION IF EXISTS unaccent;
DROP TEXT SEARCH CONFIGURATION IF EXISTS pl;

DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS article CASCADE;


-- endregion


-- region Create schema


CREATE TABLE category
(
  id   SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE article
(
  id          SERIAL PRIMARY KEY,
  title       TEXT NOT NULL,
  content     TEXT NOT NULL,
  searchcache TSVECTOR,
  categoryid  INTEGER,
  CONSTRAINT article_category_id_fk FOREIGN KEY (categoryid) REFERENCES category (id)
);


-- endregion


-- region Insert data


INSERT INTO category (id, name) VALUES (1, 'Witcher');
INSERT INTO category (id, name) VALUES (2, 'Twitter');
INSERT INTO category (id, name) VALUES (3, 'Blogs');

INSERT INTO article (categoryid, title, content)
VALUES (1, 'Witcher quote', 'No. I’ve no time to waste. Winter’s coming.');

INSERT INTO article (categoryid, title, content)
VALUES (2, 'JavaScript is life',
        'I like JavaScript for its clear typing system and Java for neat syntax. I really do. Really.');

INSERT INTO article (categoryid, title, content)
VALUES (3, '32 things to do before deploying to production',
        'On shutdown application should stop accepting new requests and finish the already processing ones.');

INSERT INTO article (categoryid, title, content)
VALUES (2, 'Moderate twitter comments',
        'Life is too short to moderate personal blog comments. The internet is too terrible to have unmoderated comments. Easy answer.');


-- endregion


-- region update search cache


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
