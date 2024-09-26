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

MAIN() {
  COUNT=`expr $COUNT + 1`
  if [[ $NUMBER_GUESS > $NUMBER_RANDOM ]]
  then
    ENTER_AGAIN_LT_NUMBER
  elif [[ $NUMBER_GUESS < $NUMBER_RANDOM ]]
  then
    ENTER_AGAIN_GT_NUMBER
  else
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




