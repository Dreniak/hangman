$words = File.readlines("english_words_basic.txt")

HANGMANPICS = ['''
    +---+
    |   |
        |
        |
        |
        |
  =========''', '''
    +---+
    |   |
    O   |
        |
        |
        |
  =========''', '''
    +---+
    |   |
    O   |
    |   |
        |
        |
  =========''', '''
    +---+
    |   |
    O   |
   /|   |
        |
        |
  =========''', '''
    +---+
    |   |
    O   |
   /|\  |
        |
        |
  =========''', '''
    +---+
    |   |
    O   |
   /|\  |
   /    |
        |
  =========''', '''
    +---+
    |   |
    O   |
   /|\  |
   / \  |
        |
  =========''']
  
  def play_turn(word, hidden_word, stage)
    
    puts %Q{#{HANGMANPICS[stage.last]}
    
    Choose a letter:
    
    => #{hidden_word.join(" ")} <=
    
    }

    answer = gets.chomp
    stage << stage.last + 1

    answer_matches = word.each_index.select{|i| word[i] == answer}

    answer_matches.each do |matched_letter_index|
        hidden_word[matched_letter_index] = answer
    end

end

def run_game
    stage = [0]
    chosen_word = $words[rand(1..$words.length)].chomp.split("")
    hidden_word = Array.new
    chosen_word.each {hidden_word << "_"}
    loop do
        play_turn(chosen_word, hidden_word, stage)
    end
end

def wait_confirmation
    sleep(0.3)
    puts
    sleep(0.3)
    puts "    press <enter>"
    gets
end

def show_rules
    puts "\n    You really know nothing, huh!?"
    puts "    Check it out: https://www.wikihow.com/Play-Hangman\n"
    wait_confirmation
    menu
end

def menu
    puts %Q{
        888                                                           
        888                                                           
        888                                                           
        88888b.  8888b. 88888b.  .d88b. 88888b.d88b.  8888b. 88888b.  
        888 "88b    "88b888 "88bd88P"88b888 "888 "88b    "88b888 "88b 
        888  888.d888888888  888888  888888  888  888.d888888888  888 
        888  888888  888888  888Y88b 888888  888  888888  888888  888 
        888  888"Y888888888  888 "Y88888888  888  888"Y888888888  888 
                                     888                              
                                Y8b d88P                              
                                "Y88P"                               
    }

    sleep(0.1)

    puts %Q{
        1. Play Game
        2. Rules
        3. Load game
    }

    answer = gets.chomp

    case answer
        when "1" then run_game
        when "2" then show_rules
        when "3" then load_saved_game
        else 
            puts "\n    Write something I can understand, bro"
            wait_confirmation
            menu
    end

end

menu