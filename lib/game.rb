class Game

  attr_reader :player_board, :computer_board, :player, :computer, :board_height, :board_width

  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    @player = Player.new
    @computer = Computer.new
    @board_height
    @board_width
    @ships = []
  end

  def main_menu
    puts " "
    puts "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit."
    input = gets.chomp
    input
  end

  def create_ships
    puts "How many ships would you like to play with?"
    ship_count = gets.chomp.to_i
    ship_count.times do
      puts "To add a ship enter the name then the length and press enter:"
      ship = gets.chomp
      @ships << ship
    end
  end

  def place_player_ships
    puts "I have laid out my ships on the grid.\nYou now need to lay out your ships."
    puts @player_board.render
    puts " "
    @ships.each do |ship_string|
      ship_array = ship_string.split(" ")
      ship = Ship.new(ship_array[0], ship_array[1].to_i)
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"

      result = "Your spaces are invalid. Please try again:"
      while result == "Your spaces are invalid. Please try again:" do
        input = gets.chomp.split(" ")
        result = @player_board.place(ship, input)
        if result == "Your spaces are invalid. Please try again:"
        puts result
        end
      end
      puts @player_board.render(true)
      puts " "
    end
    return @player_board
  end

  def place_computer_ships
    @ships.each do |ship_string|
      ship_array = ship_string.split(" ")
      ship = Ship.new(ship_array[0], ship_array[1].to_i)
      @computer_board = @computer.place_ship(@computer_board, ship)
    end
    @computer_board
  end

  def play_game
    @ships = []
    board_size
    create_ships
    @player_board = Board.new(@board_height, @board_width)
    @computer_board = Board.new(@board_height, @board_width)
    @player = Player.new
    @computer = Computer.new(@board_height, @board_width)
    place_player_ships
    place_computer_ships
    puts " "
    puts "=============COMPUTER BOARD============="
    puts @computer_board.render
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
       puts @computer_board.render
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
