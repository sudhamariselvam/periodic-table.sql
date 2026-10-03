#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT_INFO=$($PSQL "
SELECT
  elements.atomic_number,
  elements.name,
  elements.symbol,
  CASE properties.type_id
    WHEN 1 THEN 'metal'
    WHEN 2 THEN 'nonmetal'
    WHEN 3 THEN 'metalloid'
  END,
  properties.atomic_mass,
  properties.melting_point_celsius,
  properties.boiling_point_celsius
FROM elements
JOIN properties USING(atomic_number)
WHERE elements.atomic_number::TEXT = '$1'
   OR elements.symbol = '$1'
   OR elements.name = '$1'
")

if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
else
  echo "$ELEMENT_INFO" | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi
