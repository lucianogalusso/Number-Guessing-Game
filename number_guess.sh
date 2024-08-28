#! /bin/bash

: '	Previous:

mkdir number_guessing_game

cd number_guessing_game

git init 

git branch -m main

touch README.md 

git add README.md 

git commit -m "Initial commit"

touch info1.txt

git add info1.txt 

git commit -m "test: second commit"

echo "Text to the README file" > README.md

git add README.md 

git commit -m "test: third commit"

echo "There is no info to add, just to make commits" > info1.txt 

git add info1.txt 

git commit -m "test: fourth commit"

touch number_guess.sh

chmod +x number_guess.sh

'

#psql --username=freecodecamp --dbname=number_guess  -c "SQL QUERY HERE"
PSQL="psql --username=freecodecamp --dbname=number_guess  -t --no-align -c"

SELECT_USER="SELECT * FROM users WHERE username="

INSERT_USER="INSERT INTO users(username,games_played,best_game) VALUES"

UPDATE_USER="UPDATE users SET"

RANDOM_NUMBER=$(head /dev/urandom | tr -dc '0-9' | head -c 3)
#echo $RANDOM_NUMBER

echo "Enter your username:"
read USERNAME

#ver 22 digitos NO ESPECIFICA CASO NO CUMPLE
USERNAME=${USERNAME:0:22}

USER=$($PSQL "$SELECT_USER '$USERNAME';")

if [ -z "$USER" ]; 
then
  $PSQL "$INSERT_USER ('$USERNAME',1,0);" > /dev/null
  #volver a actualizar al final
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  IFS="|" read -r USER_ID USERNAME GAMES_PLAYED BEST_GAME <<< "$USER"
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

TRIES=1
echo "Guess the secret number between 1 and 1000:"
read NUMBER_GUESSED

while true;
do

  if ! [[ "$NUMBER_GUESSED" =~ ^[0-9]+$ ]];
  then
    ((TRIES=TRIES+1))
    echo "That is not an integer, guess again:"
    read NUMBER_GUESSED
    continue
  fi

  if [ $NUMBER_GUESSED -eq $RANDOM_NUMBER ];
  then
    break
  fi

  ((TRIES=TRIES+1))

  if [ $NUMBER_GUESSED -gt $RANDOM_NUMBER ]; 
  then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi

  read NUMBER_GUESSED

done

echo "You guessed it in $TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"

#update users
if [ -z "$USER" ]; 
then
  $PSQL "$UPDATE_USER best_game = $TRIES WHERE username = '$USERNAME';" > /dev/null
else 
  ((GAMES_PLAYED=GAMES_PLAYED+1))
  if [[ $BEST_GAME -eq 0 || $BEST_GAME -gt $TRIES ]]; 
  then
    $PSQL "$UPDATE_USER best_game = $TRIES, games_played = $GAMES_PLAYED WHERE username = '$USERNAME';" > /dev/null
  else 
    $PSQL "$UPDATE_USER games_played = $GAMES_PLAYED WHERE username = '$USERNAME';" > /dev/null
  fi
fi

#git add . && git commit -m "feat: final commit"