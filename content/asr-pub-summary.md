Title: Speech Recognition: A Pub-level Overview
Date: 2022-11-28 22:09
Modified: 2022-11-28 22:10
Category: Speech
Tags: Speech, ASR
Slug: Speech-recognition-a-pub-level-overview
Authors: Alasdair Taylor
Summary: A non-technical description of how **traditional** speech recognition works from the audio file to the decoded text.

# Introduction

I've been puzzled trying to think of a subject for the first blog post, but luckily an idea eventually struck.
Whenever I'm asked what I do in my new job and say that I work in automatic speech recognition (or ASR for short), I can see their eyes glaze over.
Typically I try to relate it to speech recognition technologies they've heard of, mentioning prominent voice assistants like Alexa and Siri or describing transcription software.
While they are typically knowledgable of such tech and the conversation typically ends there, a few people have asked exactly what that *means* or what I *do*. 

This is a harder question to answer off-the-cuff and really requires a more technical explanation than what people can be bothered listening to.
**However,**, it's a valuable question to know how to answer, and so I thought it would be worth trying to outline my best non-technical explanation in a short blog post that I can refer to.

At it's core, speech recognition is the translation of speech-to-text, and more broadly audio-to-text.
Both audio processing and speech are complex, so it only makes sense that trying to solve this problem is **intensely** complicated.
So where do we start?

# Raw Audio to Features

Speech for ASR is captured in an audio signal, which is itself just a sequence of digital values that best describe the analogue speech waveform.
This sequence will typically have between 16000 and 48000 values (or samples) per second for a typical audio file.
This is a large amount of information to deal with when thinking of it in data terms, and so the first step of speech recognition is typically *extracting relevant features* from the audio file.
This sounds more complicated than it is: all we are doing is trying to cut down these huge audio sequences into a more manageable size, without losing the parts of the file that are relevant for us to parse human speech.

Without getting bogged down in technical details, a good way of doing this is through *Mel-Frequency Cepstral Coefficients (or MFCCs for short)*.
This is a way of representing audio that better represents the human auditory system, and thanks to the fact that speech has **evolved** specifically to be heard by the human ear, it turns out that MFCC's are a really good way of representing speech sounds too.
However, this raises a relevant question: what is this mythical 'speech sound' we are looking for?

The answer to this lies in linguistics: I am not a linguist, so will keep this part short before I embarrass myself.
Words are made up of distinct small building blocks of sound called **phones** - as an example, the word 'cat' can be thought of as three distinct phones ('k', 'ae', 't'), while the word 'bat' can be thought of as sharing all but one of these phones ('b', 'ae', 't').
As these are the core differentiator in words, if we can accurately tell what phone is being made at any given point in the sequence of MFCCs, we can (hopefully) start telling apart words.

Knowing all this, we want to convert the sequence of audio samples into a sequence of MFCCs that better represent these blocks of speech.
We can choose how large a time-period these MFCCs cover - a relatively standard length is ~20ms.
These become our 'features'.

# Turning Features into an Acoustic Model

At this point, we have converted our huge sequence of audio samples into a more managable sequence of 20ms speech features.
However, this is the tip of the iceberg.
Let's say we have an input file of audio we are wanting to transcribe, and we convert it as above into a sequence of MFCCs and take the first one.
We need to have a system that will determine what speech sound is 'most alike' to the MFCC in the input: this is where we need to determine the **statistically most likely** speech sound is given the input feature.
This is called the *acoustic* model, and is a very important component in decoding speech.
I won't go into detail here about Hidden Markov Models and the statistical methods for doing so, but in a grand scale it involves comparing with previous examples of the speech sound in question and spitting out a probability for each.

The end goal of this system basically tells us the most likely speech sound for every 20ms feature, giving us a sequence of the most likely speech sound in each 20ms frame.

# Above the Acoustic Model - The Lexicon

We are missing some key information at this point: we have no idea what specific speech sounds make up words!
This is where something called a *lexicon* is needed - this can be thought of as a database for a language where it displays every valid word that can be transcribed, alongside the possible combinations of speech sounds that make up that word.
This can help account for accents too - think of the word tomato being pronounced as either 'tomayto' or 'tomahto'.
One can build that into a lexicon so that both pronounciations would be accepted and transcribed as the written word tomato.

# And Above the Lexicon - The Language Model

At this point you may be thinking we must have everything that we need to transcribe speech from an audio input.
We have a sequence of the most likely speech sounds, and we have a way to assemble those into words.
However, if a speech recognition system just used the acoustic model and didn't care about the actual sentences it was producing, it would be terrible.

If you take your phone and ask Siri or Alexa the nonsense phrase 'Blay me a song', it will automatically assume you meant to say 'Play me a song', no matter how hard you try to pronounce the 'B' sound at the start of 'Blay'.
The reason for this is something called the *Language Model* - this is a component of the overall speech system that tries to produce reasonable English sentences.
It looks at a wider window of the speech sounds and considers what the most likely **sequence** of words is given the words around it.
The human brain will do this automatically: if you're in a bar and someone asks 'What would you like to dr[UNINTELLIGIBLE]?', you can make a fair assumption that they're asking for a drink order and not what you would like to drive, for instance.
The language model uses the same context to try and decide what a reasonable transcription would be.

# Bringing It All Together

So at this point, we have a dense and complex system that balances up the most likely speech sounds detected, the most likely words they can make up and the likelihood of the overall utterance.
The system will balance up these likelihoods with different weights assigned to each to decide the most likely transcription given the audio input.
This is the basis of traditional speech recognition: even some rudimentary modern systems still use a framework similar to this.
However, a huge amount of ASR has been replaced by machine learning, deep learning and AI which is for another blog post.
Hopefully this post has served as an useful description of how audio files or speech captured from a microphone can be magically turned into transcripts.

# Note From Alasdair

I have left out far more detail than I have included: speech recognition is an entire field of industry and research and it's impossible to summarize in a <1500 word blog post from a fresh-faced graduate.
It is a highly technical subject rooted in Mathematics, Statistics and Linguistics. 
If the content of the post has interested you at all, there are fantastic other resources that can be accessed: I personally think [the Wikipedia page for speech recognition](https://en.wikipedia.org/wiki/Speech_recognition) is a surprisingly good place for an overview for an unfamiliar reader.
For true rigour, [Jurafsky and Martin's 'Speech and Language Processing'](https://books.google.co.uk/books/about/Speech_and_Language_Processing.html?id=fZmj5UNK8AQC&source=kp_book_description&redir_esc=y) can be thought of as a bible for not only speech recognition, but all fields of speech and text processing.
