$words = File.readlines("english_words_basic.txt")

HANGMANPICS = ['
          +---+
          |   |
              |
              |
              |
              |
        =========', '
          +---+
          |   |
          O   |
              |
              |
              |
        =========', '
          +---+
          |   |
          O   |
          |   |
              |
              |
        =========', '
          +---+
          |   |
          O   |
         /|   |
              |
              |
        =========', '
          +---+
          |   |
          O   |
         /|\  |
              |
              |
        =========', '
          +---+
          |   |
          O   |
         /|\  |
         /    |
              |
        =========', '
          +---+
          |   |
          O   |
         /|\  |
         / \  |
              |
        =========']

def validate str
    chars = ('a'..'z').to_a
    str.chars.detect {|ch| !chars.include?(ch)}.nil?
end

def save_game(word, hidden_word, stage, hanged_letters, right_letters)
    Dir.mkdir("save") unless Dir.exists? "save"
    File.open("save/savehangman", 'w') do |file|
        file.puts "#{word.join("")}\n#{hidden_word.join("")}\n#{stage.last}\n#{hanged_letters.join("")}\n#{right_letters.join("")}"
    end
end

def load_saved_game
    saved_game = File.readlines "save/savehangman"
    word = saved_game[0].chomp.split("")
    hidden_word = saved_game[1].chomp.split("")
    stage = [saved_game[2].to_i]
    hanged_letters = saved_game[3].chomp.split("")
    right_letters = saved_game[4].chomp.split("")
    puts "    Welcome back! Continue playing:"
    wait_confirmation
    loop do
        play_turn(word, hidden_word, stage, hanged_letters, right_letters)
    end
end

def options_menu
    loop do
        puts %Q{\n    1. Save Game
    2. Resume
    3. Quit
\n}
        answer = gets.chomp
        case answer
        when "1" 
            puts "    Saving your game!"
            return true
        when "2" then return
        when "3" then exit
        else puts "Type a valid command!\n"
        end
    end
end

def check_if_valid(answer, hanged_letters, right_letters)
    case true
        when answer.length > 1
            puts "    Only a letter at a time!" unless answer == "options"
        when hanged_letters.include?(answer)
            puts "    This word is a no-no!"
        when right_letters.include?(answer)
            puts "    We already know this is correct!"
        when !validate(answer)
            puts "    Are you sure about this?"
        when answer == ""
            puts "    You have to type something!"
        else 
            return true
    end
end

def check_if_lost(chosen_word, stage)
    if stage.last == 6
        puts %Q{    That's it! You are hanged!
    The word was: #{chosen_word.join("")}}
        wait_confirmation
        menu
    end
end

def check_if_win(chosen_word, hidden_word)
    if chosen_word == hidden_word
        puts %Q{    Hoo-ray! You won!}
        wait_confirmation
        menu
    end
end

def play_turn(word, hidden_word, stage, hanged_letters, right_letters)
    answer = ""
    
    loop do
        puts %Q{#{HANGMANPICS[stage.last]}
    
    Choose a letter:
    (Type "OPTIONS" for options)
    Hanged letters: [#{hanged_letters.join("-")}]
    \n    => #{hidden_word.join(" ")} <=\n\n}
    
        check_if_win(word, hidden_word)
        check_if_lost(word, stage)

        answer = gets.chomp.downcase
        break if check_if_valid(answer, hanged_letters, right_letters) == true
       
        save_game(word, hidden_word, stage, hanged_letters, right_letters) if answer == "options" && options_menu == true

        puts "    Try again:" unless answer == "options"
        wait_confirmation
    end

    answer_matches = word.each_index.select{|i| word[i] == answer}
    
    if answer_matches.length == 0
        stage << stage.last + 1
        hanged_letters << answer
        return
    end
    
    right_letters << answer

    answer_matches.each {|matched_letter_index| hidden_word[matched_letter_index] = answer}
    
end

def run_game
    hanged_letters = Array.new
    right_letters = Array.new
    stage = [0]
    chosen_word = $words[rand(1..$words.length)].chomp.split("")
    hidden_word = Array.new
    chosen_word.each {hidden_word << "_"}
    loop do
        play_turn(chosen_word, hidden_word, stage, hanged_letters, right_letters)
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
        4. Quit
    }

    answer = gets.chomp

    case answer
        when "1" then run_game
        when "2" then show_rules
        when "3" then load_saved_game
        when "4" then exit
        else 
            puts "\n    Write something I can understand, bro"
            wait_confirmation
            menu
    end

end

menu