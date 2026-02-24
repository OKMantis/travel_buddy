# Travel Buddy

An AI-powered travel activity recommender. Select a city, category, and season, and get a curated list of activities. Save the ones you like to your personal Travel Book.

## Stack

- **Rails 7.2** + PostgreSQL
- **Devise** for authentication
- **Hotwire** (Turbo + Stimulus) for real-time chat updates
- **Bootstrap 5** + Font Awesome
- **OpenAI** via `ruby_llm` for activity recommendations

## Setup

```bash
bundle install
bin/rails db:create db:migrate db:seed
```

Set `OPENAI_API_KEY` in a `.env` file, then start the server:

```bash
bin/rails server
```

## How it works

The AI is given the pre-seeded activity database (filtered by city, category, and season) and constrained to only recommend activities that exist in the database. Users can save recommended activities to their Travel Book from within the chat.

Supported cities: **New York**, **Barcelona**, **Tokyo**
