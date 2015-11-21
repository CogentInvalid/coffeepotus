import random

#Inputs a string and a double in the range 0-1 representing the probability of a character being muddled
#And outputs the string with some of the characters being garbled
#The garbled characters will usually, but not always, be lower case letters
# 0.1 is a decent number for prob if you wish a decent chance of comprehension, whereas 0.3 or higher will usually result in an illegible string
# Assuming you are using no other muddling functions
def Muddle(string, prob):
    result = ""
    for c in string:
        if(random.random() > prob):
            result += c
        else:
            n = 95 #represents the ascii code of the generated character
            n += int(28*random.random())
            #Regarbles the character as an upper case letter if it was garbled to be the actual character to make the requested garbling probability accurate
            if(chr(n) == c):
                n = 64
                n += int(28*(random.random()))
            result += chr(n) #Adds the garbled character in place of the actual character
    return result

#Inputs a string and a double in the range 0-1 representing the probability of a pair of characters being flipped
#And outputs the string with the order of some of the characters swapped
def SwapMuddle(string, prob):
    result = ""
    array = []
    #puts all the characters in the string into the array
    for c in string:
        array.append(c)
    n = 1;
    #Swamps the order of character in the array
    while n < len(array):
        if(random.random() < prob):
            char = array[(n-1)]
            array[(n-1)] = array[n]
            array[n] = char
            n += 1
        n += 1
    for char in array:
        result += char
    return result

#Inputs a string and a double in the range 0-1 representing the probability of a character being lost
#And outputs the string with some of the characters missing
def BlotMuddle(string,prob):
    result = ""
    for c in string:
        if(random.random() > prob):
            result += c
        else:
            result += ' '
    return result

#Inputs a string and a double in the range 0-1 representing the probability of a character being muddled/lost or a pair of characters being flipped
#And outputs a string muddled using Muddle, SwapMuddle and BlotMuddle
# A prob value of 0.1 has a fairly low average legibility, with around a 20% chance of being halfway legible
# A prob value of around 0.05 is more reasonable
def FullMuddle(string, prob):
    return BlotMuddle(Muddle(SwapMuddle(string,prob),prob), prob)

#test code
#strin = "Should there be world peace?"
#print FullMuddle(strin, 0.05)