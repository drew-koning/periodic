#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
SELECTS="atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius"
JOINS="elements LEFT JOIN properties using(atomic_number) LEFT JOIN types USING(type_id)"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  NUM_RESULT=$($PSQL "SELECT $SELECTS FROM $JOINS where atomic_number=$1")
  else
  SYM_RESULT=$($PSQL "SELECT $SELECTS FROM $JOINS where symbol='$1'")
  NAME_RESULT=$($PSQL "SELECT $SELECTS FROM $JOINS where name='$1'")
  fi
  if [[ $NUM_RESULT ]]
  then 
  RESULT=$NUM_RESULT
  fi
  if [[ $SYM_RESULT ]]
  then 
  RESULT=$SYM_RESULT
  fi
  if [[ $NAME_RESULT ]]
  then 
  RESULT=$NAME_RESULT
  fi
  if [[ -z $RESULT ]]
  then 
  echo "I could not find that element in the database."
  else
  echo "$RESULT" | while read NUM BAR NAME BAR SYM BAR TYPE BAR MASS BAR MELT BAR BOIL
  do
  echo "The element with atomic number $NUM is $NAME ($SYM). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
  fi
fi
