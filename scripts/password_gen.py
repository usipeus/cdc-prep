import random
import string
import sys

wordlist = []
#wordlist_fn = "eff_large_wordlist.txt"
wordlist_fn ="eff_short_wordlist_1.txt"

with open(wordlist_fn, "r") as file:
    for line in file:
        wordlist.append(line.split()[1])

def get_sample(num_passwords = 1, num_words = 3, num_digits = 3, num_letters = 0, num_puctation = 0):
    passwords = []
    for i in range(num_passwords):
        # words
        sample = random.sample(wordlist, num_words)

        # digits
        sample += random.sample(string.digits, num_digits)

        # letters
        sample += random.sample(string.ascii_letters, num_letters)

        # punctuation
        sample += random.sample(string.punctuation, num_puctation)

        password = ""
        for element in sample:
            password += element
        passwords.append(password)
    return passwords

def print_usage():
    print("Usage: password_gen.py num_passwords")
    exit()

if __name__ == '__main__':
    try:
        num_passwords = int(sys.argv[1])
    except(ValueError, IndexError) as e:
        print_usage()
    if num_passwords < 0:
        print_usage()
    passwords = get_sample(num_passwords = num_passwords)
    for i in passwords:
        print(i)
