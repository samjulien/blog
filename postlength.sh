#!/bin/sh
# Outputs your post's word count and post length score
# Run the script and pass in the path to your post:
# source ./postlength.sh 2018-08-27-my-post.markdown
# Then add the score to your article front matter as post_length.
WORDS=$(wc -w < "$1")
echo "word count:" $WORDS
if [ "$WORDS" -le 1500 ]; then
  POST_LENGTH=1
elif [ "$WORDS" -gt 1501 ] && [ "$WORDS" -le 2500 ]; then
  POST_LENGTH=2
elif [ "$WORDS" -gt 2501 ] && [ "$WORDS" -le 4000 ]; then
  POST_LENGTH=3
elif [ "$WORDS" -gt 4001 ] && [ "$WORDS" -le 6000 ]; then
  POST_LENGTH=4
elif [ "$WORDS" -gt 6000 ]; then
  POST_LENGTH=5
fi
echo "post length score:" $POST_LENGTH