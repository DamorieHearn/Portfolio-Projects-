from textblob import TextBlob

#code adapted from Pranayteja, 2023

#define textblob object
def get_sentiment_scores(blob):
    #sentiment = [] - was doing this because polarity was defined in VADER
    positive_scores = []
    negative_scores = []
    neutral_scores = []

    sentiment_score = blob.sentiment

    if sentiment_score[-1] > 0:
            positive_scores.append(sentiment_score)
            print("The comment has got a Positive response")
    elif sentiment_score[-1] < 0:
            negative_scores.append(sentiment_score)
            print("The comment has got a Negative response")
    else:
            neutral_scores.append(sentiment_score)
            print("The comment has got a Neutral response")



    #return positive_scores, negative_scores, neutral_scores
    return sentiment_score

#end of adapted code

polarity = []

#code adapted from Whalen, 2020
#code to open and read .txt files with comments inside


with open("Euphoria-ZendayaComments1.txt", encoding='`utf-8') as f:
            comment = f.readlines()

#end of adapted code

# print the sentiments for all the comments in the .txt file

            print("Analysing Comments...")
            for index, items in enumerate(comment):
                blob = TextBlob(items)
                polarity = get_sentiment_scores(blob)
                print(polarity[-1])

#code adapted from GeeksforGeeks, 2023
#How to get the overall polarity of the comments in the .txt file

avg_polarity = sum(polarity) / len(polarity)
print("Average Polarity:", avg_polarity)
if avg_polarity > 0.05:
    print("The Video has got a Positive response")
elif avg_polarity < -0.05:
    print("The Video has got a Negative response")
else:
    print("The Video has got a Neutral response")

#end of adapted code

