`wordlist` is a command-line application that outputs a random list of words, designed to generate memorable passwords.

## Example usage

Download a list of words:

    bash$ export WORD_LIST_PATH="$HOME/words"
    bash$ wget -O "$WORD_LIST_PATH" 'https://raw.githubusercontent.com/trezor/python-mnemonic/ec21884db9f3af236732121e7ccf97435b924915/mnemonic/wordlist/english.txt'

By default, @wordlist@ generates four words separated by spaces.

    bash$ wordlist
    afraid avoid sunset cactus

The number of words and the separator are customizable.

    bash$ wordlist -n 3 -d '/'
    kite/wire/impact

For full command-line documentation:

    bash$ wordlist --help
