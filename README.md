# heroku-buildpack-sonar

# Note on JDBC Config

It appears that you do not need to configure anything except the `DATABASE_URL` (which is configured automatically when you
add the Postgres add-on).    According to [this Heroku documentation on JDBC](https://devcenter.heroku.com/articles/connecting-to-relational-databases-on-heroku-with-java):

> The official Heroku buildpacks for Java, Scala, Clojure, and Gradle will attempt to 
> create a `JDBC_DATABASE_URL` environment variable when a dyno starts up. 
> This variable is dynamic and will not appear in your list of configuration variables 
> when running heroku config. You can view it by running the following command:
>   ```
>        $ heroku run echo \$JDBC_DATABASE_URL
>    ```
> The variable will include `?user=<user>&password=<password>` parameters, but `JDBC_DATABASE_USERNAME`
> and `JDBC_DATABASE_PASSWORD` environment variables will also be set when possible.

