from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

#Code adapted from GeeksforGeeks, 2023
def sentiment_scores(comment, polarity):
    # Creating a SentimentIntensityAnalyzer object.
    sentiment_object = SentimentIntensityAnalyzer()

    sentiment_dict = sentiment_object.polarity_scores(comment)
    polarity.append(sentiment_dict['compound'])

    return polarity


polarity = []
positive_comments = []
negative_comments = []
neutral_comments = []


f = open("Euphoria-AlgeeSmithComments20.txt", 'r', encoding='`utf-8')
comments = f.readlines()
f.close()
print("Analysing Comments...")
for index, items in enumerate(comments):
    polarity = sentiment_scores(items, polarity)

    if polarity[-1] > 0.05:
        positive_comments.append(items)
    elif polarity[-1] < -0.05:
        negative_comments.append(items)
    else:
        neutral_comments.append(items)


# Print polarity
#print the sentiments for all of the comments in the .txt file
print(polarity[:75])


#overall polarity

avg_polarity = sum(polarity) / len(polarity)
print("Average Polarity:", avg_polarity)
if avg_polarity > 0.05:
    print("The Video has got a Positive response")
elif avg_polarity < -0.05:
    print("The Video has got a Negative response")
else:
    print("The Video has got a Neutral response")

print("The comment with most positive sentiment:", comments[polarity.index(max(
    polarity))], "with score", max(polarity), "and length", len(comments[polarity.index(max(polarity))]))
print("The comment with most negative sentiment:", comments[polarity.index(min(
    polarity))], "with score", min(polarity), "and length", len(comments[polarity.index(min(polarity))]))

#end of adapted code
