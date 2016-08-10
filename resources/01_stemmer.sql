/**
 * How search works?
 *
 * Full text search is set of techniques
 */


-- region Key mechanism: Stemmer


SELECT to_tsvector('satisfies and satisfy');


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


SELECT to_tsvector('english', 'satisfies and satisfy');
SELECT to_tsvector('dutch', 'satisfies and satisfy');
SELECT to_tsvector('simple', 'SCREAMING on interns');


-- endregion


-- region Supported languages


SELECT cfgname
FROM pg_ts_config;


-- endregion
