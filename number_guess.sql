/*https://www.freecodecamp.org/learn/relational-database/build-a-number-guessing-game-project/build-a-number-guessing-game*/

CREATE DATABASE number_guess;

CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(22) NOT NULL UNIQUE,
  games_played INT NOT NULL,
  best_game INT NOT NULL
);