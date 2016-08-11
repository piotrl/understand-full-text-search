
## Understand full-text search with Postgres

#### Piotr Lewandowski, [@constjs](http://twitter.com/constjs)

----


#### When full-text search? 

* Search by content created by people (not programmers)
* Divide more and less important fragments of document
* Searching database dumps from WikiLeaks


#### Why just not RegEx?

* Regex is good to find only simple, finite languages
* Helpless for grammar
* Slow 
* Lots of pitfalls even for simple languages like HTML
* Complicated to maintain, e.g.

    ```
    ^(?=[A-Z0-9][A-Z0-9@._%+-]{5,253}$)[A-Z0-9._%+-]{1,64}@(?:(?=[A-Z0-9-]{1,63}\.)[A-Z0-9]+(?:-[A-Z0-9]+)*\.){1,8}[A-Z]{2,63}$
    ```


#### Why Postgres?

* Pretty rich in features
* Flexible and extensible
* Maybe you already have it
    * Low entry point
    * If your technology stack is already over-engineered


#### [Further reading](./FURTHER_READING.md)