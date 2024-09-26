#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

ENTER_NUMBER_GUESS() {
  echo "That is not an integer, guess again:"
  read NUMBER_GUESS
  if [[ ! $NUMBER_GUESS =~ ^[0-9]+$ ]]
  then
    ENTER_NUMBER_GUESS
  else
    MAIN
  fi
}

ENTER_AGAIN_LT_NUMBER() {
  echo "It's lower than that, guess again:"
  read NUMBER_GUESS
  if [[ ! $NUMBER_GUESS =~ ^[0-9]+$ ]]
  then
    ENTER_NUMBER_GUESS
  else
    MAIN
  fi
}

ENTER_AGAIN_GT_NUMBER() {
  echo "It's higher than that, guess again:"
  read NUMBER_GUESS
  if [[ ! $NUMBER_GUESS =~ ^[0-9]+$ ]]
  then
    ENTER_NUMBER_GUESS
  else
    MAIN
  fi
}

INSERT_USER_INTO_DATABASE() {
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
  if [[ -z $BEST_GAME ]]
  then
    INSERT=$($PSQL "INSERT INTO users(username,games_played,best_game) VALUES('$USERNAME',1,'$COUNT')")
  else
    if [[ $BEST_GAME > $COUNT ]]
    then
      UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game='$COUNT' WHERE username='$USERNAME'")
    fi
  fi
}

MAIN() {
  COUNT=`expr $COUNT + 1`
  if [[ $NUMBER_GUESS > $NUMBER_RANDOM ]]
  then
    ENTER_AGAIN_LT_NUMBER
  elif [[ $NUMBER_GUESS < $NUMBER_RANDOM ]]
  then
    ENTER_AGAIN_GT_NUMBER
  else
    INSERT_USER_INTO_DATABASE
    echo "You guessed it in $COUNT tries. The secret number was $NUMBER_GUESS. Nice job!"
  fi
}

echo "Enter your username:"
read USERNAME
USER=$($PSQL "SELECT * FROM users WHERE username='$USERNAME'")
if [[ -z $USER ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  echo "$USER" | while read NAME BAR GAMES_PLAYED BAR BEST_GAME BAR USER_ID
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi
NUMBER_RANDOM=$(( RANDOM % 1000 + 1 ))
COUNT=0
echo "$NUMBER_RANDOM"
echo "Guess the secret number between 1 and 1000:"
read NUMBER_GUESS
if [[ ! $NUMBER_GUESS =~ ^[0-9]+$ ]]
then
  ENTER_NUMBER_GUESS
else
  MAIN
fi
