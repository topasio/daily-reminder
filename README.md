# daily-reminder
A few scripts to help you integrate something you have read into your life. For me, this is a great way to build new habits.

# Purpose
A good friend once told me: We don't need to read so much new stuff all the time, it would help to just remember what you've already learned. Try to integrate it into your life!

So I have a routine for myself that actually works quite well:

1) When I read a book, I take notes or just highlight important sentences on my tolino.

2) I keep them in a text file and then, of course, I never find the time to read them again.

3) That's why I want to get a sentence in my mailbox every day ;-) The script randomly picks a sentence and sends it to me.

4) Leave this email in your inbox all day. When you check your emails from FOMO, you will see this reminder and you may be able to get into the habit of thinking about how you can use this phrase in your life today.

# Mail delivery via crontab

I use this crontab (`crontab -e`) to trigger mail delivery at 6am every day (runs on my vserver):

```
0 6 * * * /usr/local/bin/reminder.sh > ~/reminder.log 2>&1
```
