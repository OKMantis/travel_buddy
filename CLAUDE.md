# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Travel Buddy is a Rails 7.2 app that uses an LLM (via OpenAI) to recommend travel activities. Users select a city, category, and season; the AI returns a list of activities from the database (no hallucination), and users can save activities to their personal Travel Book.

## Commands

```bash
# Start the server
bin/rails server

# Run all tests
bin/rails test

# Run a single test file
bin/rails test test/models/chat_test.rb

# Run a single test by line number
bin/rails test test/models/chat_test.rb:10

# Lint (rubocop excludes bin/, db/, config/, test/ — see .rubocop.yml)
bundle exec rubocop

# Database
bin/rails db:create db:migrate db:seed

# Security scan
bundle exec brakeman
```

## Architecture

### Data Model

- **User** — Devise authentication; owns many Chats
- **Chat** — Belongs to User; stores city/category/season filters; has many Messages
- **Message** — Belongs to Chat (role: `"user"` or `"assistant"`); has many Activities through TravelBooks
- **Activity** — Pre-seeded database of activities (city, category, season, content, link); NOT AI-generated
- **TravelBook** — Join table linking a Message to an Activity; represents a saved activity

### LLM Integration

The AI integration uses the `ruby_llm` gem configured with `OPENAI_API_KEY` (set in `.env`).

Key pattern in `Chat#system_prompt`: the system prompt passes the **full activity database** (filtered by city/category/season) as JSON to the LLM, instructing it to only return activities from that list. The LLM embeds HTML `<a>` links with the format `/messages/:message_id/activities/:activity_id` inside its response so users can click "Add to travelbook."

When a user visits that link, `ActivitiesController#show` creates a `TravelBook` record and rewrites the link text in the stored message content to "Saved!" via string substitution on `message.content`.

### Request Flow

1. User submits the home form → `ChatsController#create` builds the first user message, calls the LLM with a system prompt containing filtered activities, stores both messages, generates a chat title
2. Follow-up messages → `MessagesController#create` rebuilds conversation history via `build_conversation_history`, calls LLM, stores assistant reply; responds with Turbo Stream
3. Saving an activity → GET `/messages/:message_id/activities/:id` → `ActivitiesController#show` creates TravelBook, mutates message HTML, redirects back to chat
4. Travelbook page — `PagesController#travelbook` queries `current_user.travel_books` grouped by city

### Frontend

- Bootstrap 5 + Font Awesome via Sass gems
- Hotwire (Turbo + Stimulus) for real-time chat updates without full page reloads
- Turbo Stream responses in `app/views/messages/create.turbo_stream.erb` and `app/views/chats/destroy.turbo_stream.erb`
- Markdown in AI responses is rendered via `kramdown` + `kramdown-parser-gfm` + `rouge`

### Supported Cities / Categories / Seasons

Defined as constants on `Activity`:
- **Cities**: New York, Barcelona, Tokyo
- **Categories**: Experiences & Activities, Culture & Entertainment, Family-Friendly, Nightlife & Social, Instagrammable Spots
- **Seasons**: Winter, Spring, Summer, Fall

Activities are seeded from `db/seeds.rb`. The LLM is constrained to this seeded data only.

### Message Limit

`Message::MAX_USER_MESSAGES = 10` — a validation prevents users from sending more than 10 messages per chat.
