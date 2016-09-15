# cabot in a container

[Cabot](http://cabotapp.com/) dockerized.

## Required environment variables
`GRAPHITE_API` - hostname of your Graphite server instance (including trailing slash)

## Optional environment variables

`DATABASE_URL` - postgresql database URL, default value is `postgres://cabot:cabot@localhost:5432/index`

`TIME_ZONE` - server timezone, choices can be found [here](http://en.wikipedia.org/wiki/List_of_tz_zones_by_name), default value is `Etc/UTC`

`ADMIN_EMAIL` - default value is `admin@cabot`

`CABOT_FROM_EMAIL` - default value is `noreply@cabot`

For complete list of environment variables, see [production.env.example](https://github.com/arachnys/cabot/blob/master/conf/production.env.example)
