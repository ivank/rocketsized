# Rocketsized

[![Rocketsized landscape portrait](/assets/poster_landscape.jpg)](https://rocketsized.com)

A small hobby project to list and compare various launch vehicles against one another. I've always seen those rockets lined up side by side but its always a one-off thing, I wanted an automated tool that could do that for any combination of rockets.

Also a way to take a look at and learn elixir and phoenix, which I was unfamiliar with until now.

Project is developed with elixir and phoenix.
Deployed at [rocketsized.com](https://rocketsized.com)

# Developing locally

Should have a postgres database on localhost port 5432. Run docker compose to create one.

```bash
docker compose up -d
```

Now you can download dependencies, compile the app and run the migrations. Then you can start the local server:

```bash
mix setup
mix phx.server
```

## Copyright

Apache License 2 - 2023 Ivan Kerin, Read the [LICENSE](./LICENSE) file.
