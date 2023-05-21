#!/bin/bash 

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT=$1
if [[ -z $ELEMENT ]]
then
echo "Please provide an element as an argument."
else
 if [[ ! $ELEMENT =~ ^[0-9]+$ ]]
 then
   CHECK_ELEMENT=$($PSQL "SELECT * FROM elements WHERE name = '$ELEMENT' OR symbol = '$ELEMENT'")
   if [[ -z $CHECK_ELEMENT ]]
   then
     echo "I could not find that element in the database."
     else
     ELEMENT_BY_SYMBOL_OR_NAME=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$ELEMENT' OR symbol='$ELEMENT'")
     echo "$ELEMENT_BY_SYMBOL_OR_NAME" | while IFS='|' read -r BAR ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING BOILING TYPE 
     do
       echo  "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
     done
     fi
  else
  CHECK_ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$ELEMENT")
  if [[ -z $CHECK_ELEMENT ]]
  then
  echo "I could not find that element in the database."
  else
  ELEMENT_BY_ATOMIC_NUMBER=$($PSQL"SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ELEMENT")
   echo "$ELEMENT_BY_ATOMIC_NUMBER" | while IFS='|' read -r BAR ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING BOILING TYPE 
     do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
  fi
 fi
fi
