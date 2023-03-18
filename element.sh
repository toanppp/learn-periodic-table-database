#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="atomic_number = $1"
else
  CONDITION="name='$1' OR symbol='$1'"
fi

RESULT=$($PSQL "
  SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
  FROM elements 
  INNER JOIN properties USING(atomic_number) 
  INNER JOIN types USING(type_id) 
  WHERE $CONDITION
")

if [[ $RESULT == "" ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

ATOMIC_NUMBER==$(echo $RESULT | awk '{print $1}')
NAME=$(echo $RESULT | awk '{print $3}')
SYMBOL=$(echo $RESULT | awk '{print $5}')
TYPE=$(echo $RESULT | awk '{print $7}')
ATOMIC_MASS=$(echo $RESULT | awk '{print $9}')
MELT_POINT_CELS=$(echo $RESULT | awk '{print $11}')
BOL_POINT_CELS=$(echo $RESULT | awk '{print $13}')

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_POINT_CELS celsius and a boiling point of $BOL_POINT_CELS celsius."
