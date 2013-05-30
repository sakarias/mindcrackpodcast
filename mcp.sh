#! /bin/bash

# brew install ffmpeg
# brew install youtube-dl
# brew install atomicparsley

TMP="/tmp/mindcrackpodcast"

if [ ! -d ${TMP} ]; then
	mkdir ${TMP}
fi

cd ${TMP}

mcpUrl=$(curl -s -q https://api.twitter.com/1/statuses/user_timeline.rss?screen_name=mindcracklp | grep 'Podcast' | head -n 1 | grep -Eo 'http://[[:alnum:][:punct:]]*[[:alnum:]]')

youtube-dl -x ${mcpUrl}

for file in *.m4a
do
	title=$(echo ${file} | cut -d "-" -f 1 | sed -e 's/^ *//g' -e 's/ *$//g')
	episode=$(echo ${file} | cut -d "-" -f 2 | sed -e 's/^ *//g' -e 's/ *$//g')
	episodeNumber=$(echo ${episode} | cut -d " " -f 2 | sed -e 's/^ *//g' -e 's/ *$//g')
	extra=$(echo ${file} | cut -d "-" -f 3 | sed -e 's/^ *//g' -e 's/ *$//g')

	AtomicParsley "${file}" --artist "MindCrack" --album "MindCrack" --title "${title} - ${episode} - ${extra}" --tracknum ${episodeNumber} --podcastFlag true

	rm "${file}"
done

mv *temp* "$(echo -e "${title} - ${episode} - ${extra}.m4a")"
