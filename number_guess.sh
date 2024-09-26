#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --no-align --tuples-only -c"

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
  echo "$USERNAME"
  INSERT=$($PSQL "INSERT INTO users(username,guesses) VALUES('$USERNAME','$COUNT')")
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
IS_USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
if [[ -z $IS_USERNAME ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM users GROUP BY username HAVING username='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM users WHERE username='$USERNAME' GROUP BY guesses")
  BEST_GAME_CUSTOM
  echo "$GAMES_PLAYED $BEST_GAME"
  echo "Welcome back, $NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
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

# add commit 3
# add commit 3
# add commit 5
