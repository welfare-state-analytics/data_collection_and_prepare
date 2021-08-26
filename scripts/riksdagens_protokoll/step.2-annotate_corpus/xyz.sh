#!/bin/bash

x=$(ls data/annotated* | sed -e s/annotated/riksdagens-protokoll\./)

for file in data/annotated* ; do
	target=$(echo $file | sed -e s/annotated/riksdagens-protokoll\./)
	mv $file $target
done

