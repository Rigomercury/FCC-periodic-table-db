#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Si no hay argumento
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Buscar el elemento (por número, símbolo o nombre)
ELEMENT_INFO=$($PSQL "
  SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, 
         p.melting_point_celsius, p.boiling_point_celsius
  FROM elements e
  JOIN properties p ON e.atomic_number = p.atomic_number
  JOIN types t ON p.type_id = t.type_id
  WHERE e.atomic_number::varchar = '$1' OR e.symbol = '$1' OR e.name = '$1'
")

# Si no se encuentra
if [[ -z $ELEMENT_INFO ]]; then
  echo "I could not find that element in the database."
  exit
fi

# Parsear la información
IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT_INFO"

# Mostrar resultados
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
