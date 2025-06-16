print('''
*******************************************************************************
  _   _            _      _____ _               _   _      _                     
 | | | |          | |    / ____| |             | | | |    (_)                    
 | |_| | __ _  ___| | __| (___ | |__   ___  ___| |_| | ___ _ _ __   ___ _ __ ___ 
 |  _  |/ _` |/ __| |/ / \___ \| '_ \ / _ \/ __| __| |/ / | | '_ \ / _ \ '__/ __|
 | | | | (_| | (__|   <  ____) | | | |  __/ (__| |_|   <| | | | | |  __/ |  \__ \\
 |_| |_|\__,_|\___|_|\_\|_____/|_| |_|\___|\___|\__|_|\_\_|_|_| |_|\___|_|  |___/
*******************************************************************************
''')
print("Welcome to Hacker's Challenge.")
print("Your mission is to bypass security and find the digital treasure.")

# Level 1: Phishing Awareness
choice1 = input('You get an email: "Click here to claim $1,000,000!" What do you do?\n'
                '(A) Click the link\n'
                '(B) Report as spam\n'
                '(C) Forward to a friend\n').lower()

if choice1 == "b":
    # Level 2: Password Security
    choice2 = input('Choose the strongest password:\n'
                    '(A) password123\n'
                    '(B) P@ssw0rd!\n'
                    '(C) 123456\n').lower()
    if choice2 == "b":
        # Level 3: Encryption Puzzle
        choice3 = input('Decode this: R0x1YyEh (Hint: Base64)\n').lower()
        if choice3 == "hack!!":
            print("Access granted! You found the digital treasure: ₿1,000,000!")
        else:
            print("Wrong decryption. The FBI traces your IP. Game Over.")
    else:
        print("Weak password! Your account gets hacked. Game Over.")
else:
    print("You fell for a phishing scam. Game Over.")