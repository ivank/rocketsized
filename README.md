# Rocketsized

[![Rocketsized landscape portrait](/priv/static/images/poster_landscape.jpg)](https://rocketsized.com)

A small hobby project to list and compare various launch vehicles against one another. I've always seen those rockets lined up side by side but its always a one-off thing, I wanted an automated tool that could do that for any combination of rockets.

Also a way to take a look at and learn elixir and phoenix, which I was unfamiliar with until now.

Project is developed with elixir and phoenix.
Deployed at [rocketsized.com](https://rocketsized.com)

## Developing locally

Should have a postgres database on localhost port 5432. Run docker compose to create one.

```bash
docker compose up -d
```

Now you can download dependencies, compile the app and run the migrations. Then you can start the local server:

```bash
mix setup
mix phx.server
```

## Development

Chronological explanation on how this project got built. It started mostly as a hobby project to be able to generate a [rockets of the world](https://www.visualcapitalist.com/comparing-the-size-of-the-worlds-rockets-past-and-present/) poster on the fly. Also I wanted a project to mess around with tailwind/elixir/phoenix/ecto. I knew exactly how to build it in the tech stacks I'm familiar with, but I wanted a challenge to learn something new.

### Step 1. Data origins

The initial data load was from scraping wikipedia with [Crawly](https://github.com/elixir-crawly/crawly) and parsing with [Floki](https://github.com/philss/floki). Though after loading everything, I had to go back and manually modify some data.

### Step 2. Admin

To modify and edit new data, I considered using one of the phoenix admin generators, though after looking at [kaffy](https://github.com/aesmail/kaffy) and [live_admin](https://github.com/mojotech/torch) I decided I just wanted to learn how to do it from scratch and went ahead and utilized phoenix's crud generators. The admin interface ended up crude, but more than sufficient for my needs

### Step 3. Authentication

I decided to got with the default phoenix security generators, even though new fancy [webauthn](https://github.com/liveshowy/webauthn_components) implementations on the horizon, since this is more about learning phoenix itself. Turned out mostly adequate.

### Step 3. Flop

For the frontend filter decided to use a dedicated library for filtering with query parameters - [Flop](https://github.com/woylie/flop). Refactored the code several times with a more custom filters -> query params implementation, because the default one from FLop seemed rather tedious.

### Step 4. Rect Layout

Decided to go with svg as a render file format, so that it can be more portable to different file format. But since relative positioning is quite limited, I had to implement a graphics library to help position the various rockets correctly. Split this effort out to its own package - [rect_layout](https://github.com/ivank/rect_layout)

### Render pipeline

Added a pipeline to create and transform graphical files, so that the svgs can be downloaded in other formats. After some testing it turned out that the SVG is quite complex and cannot be correctly displayed by cairo or rsvg packages. Would need to investigate further, but left the render pipeline so it can be used again.

## Copyright

Apache License 2 - 2023 Ivan Kerin, Read the [LICENSE](./LICENSE) file.
