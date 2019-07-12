#!/bin/bash

for i in {1..100}; do
echo -e "$(cat ready_${i})" >> table
done

