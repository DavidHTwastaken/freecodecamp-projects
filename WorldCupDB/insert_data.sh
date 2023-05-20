#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams")
while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  #get winner_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
  if [[ -z $WINNER_ID ]]
  then
    #insert winner into teams
    INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
    #get new winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")    
  fi

  #get opponent_id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
  if [[ -z $OPPONENT_ID ]]
  then
    #insert opponent into teams
    INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
    #get new opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")    
  fi

  #insert the game into games
  echo $($PSQL "INSERT INTO 
    games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
    VALUES($year,'$round',$WINNER_ID, $OPPONENT_ID,$winner_goals,$opponent_goals)"
    )
done < <(tail -n +2 games.csv)