class Game

  attr_reader :player_board, :computer_board, :player, :computer, :board_height, :board_width

  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    @player = Player.new
    @computer = Computer.new
    @board_height
    @board_width
  end

  def main_menu
    puts " "
     puts "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit."
     input = gets.chomp
     input
  end

  def place_player_ships
    puts "I have laid out my ships on the grid.\nYou now need to lay out your two ships.\nThe Cruiser is three units long and the Submarine is two units long."
    puts @player_board.render
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    puts " "
    puts "Enter the squares for the Cruiser (3 spaces):"

    result = "Your spaces are invalid. Please try again:"
    while result == "Your spaces are invalid. Please try again:" do
      input = gets.chomp.split(" ")
      result = @player_board.place(cruiser, input)
      if result == "Your spaces are invalid. Please try again:"
        puts result
      end
    end

    puts @player_board.render(true)
    puts " "
    puts "Enter the squares for the Submarine (2 spaces):"

    result = "Your spaces are invalid. Please try again:"
    while result == "Your spaces are invalid. Please try again:" do
      input = gets.chomp.split(" ")
      result = @player_board.place(submarine, input)
      if result == "Your spaces are invalid. Please try again:"
        puts result
      end
    end

    puts @player_board.render(true)
    return @player_board
  end

  def place_computer_ships
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    @computer_board = @computer.place_ship(@computer_board, submarine)
    @computer_board = @computer.place_ship(@computer_board, cruiser)
    @computer_board
  end

  def play_game
    board_size
    @player_board = Board.new(@board_height, @board_width)
    @computer_board = Board.new(@board_height, @board_width)
    @player = Player.new
    @computer = Computer.new(@board_height, @board_width)
    place_player_ships
    place_computer_ships
    puts " "
    puts "=============COMPUTER BOARD============="
    puts @computer_board.render(true)
    puts "==============PLAYER BOARD=============="
    puts @player_board.render(true)
    while !all_ships_sunk?(@computer_board) && !all_ships_sunk?(@player_board) do
      puts " "
      puts "Enter the coordinate for your shot:"
      result = ""
      input = ''
      while result.class == String do
        input = gets.chomp
        result = @player.take_turn(input, @computer_board)
        if result.class == String
          puts result
        end
      end

      @player_board = @computer.take_turn(@player_board)

       puts " "
       puts @player.display_turn_message(input, @computer_board)
       puts @computer.display_turn_message(@player_board)

       puts " "
       puts "=============COMPUTER BOARD============="
       puts @computer_board.render(true)
       puts "==============PLAYER BOARD=============="
       puts @player_board.render(true)
    end
    puts endgame
    start
  end

  def endgame
    if all_ships_sunk?(@computer_board) && !all_ships_sunk?(@player_board)
      puts ""
      return "**************** Player wins! ****************"
    else
      puts ""
      return "**************** Computer wins! ****************"
    end
  end

  def start
    result = main_menu
    if result == 'p'
      play_game
    elsif result == 'q'
      exit
    else
      start
    end
  end

  def board_size
    puts "Please enter a height for your board ranging from 4 to 26"
    @board_height = gets.chomp.to_i
    puts "Please enter a width for your board ranging from 4 to 26"
    @board_width = gets.chomp.to_i
  end

  def all_ships_sunk?(board)
    result = board.cells.any? do |coordinate, cell|
      cell.ship != nil && !cell.fired_upon?
    end

    !result
  end

end
