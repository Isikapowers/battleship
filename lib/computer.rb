class Computer

  attr_reader :coordinates_track, :unhit_coordinates

  def initialize(height = 4, width = 4)
    @unhit_coordinates = Board.new(height, width).cells.keys
    @coordinates_track = []
    @board_height = height
    @board_width = width
  end

  def get_random_coordinate
    spaces = Board.new(@board_height, @board_width).cells.keys
    spaces.sample
  end

  def get_random_direction
    [0, 1].sample
  end

  def place_ship(computer_board, ship)
    ship_length = ship.length
    result = "Your spaces are invalid.  Please try again:"
    while result.class == String do
      random_coordinate = get_random_coordinate
      random_direction = get_random_direction
      random_coordinate_letter = random_coordinate[0]
      random_coordinate_number = random_coordinate[1]
      coordinates = []
      if random_direction == 0
        counter = 0
        ship_length.times do
          coordinates << random_coordinate_letter + (random_coordinate_number.to_i + counter).to_s
          counter += 1
        end
      else
        counter = 0
        ship_length.times do
          coordinates << (random_coordinate_letter.ord + counter).chr + random_coordinate_number
          counter += 1
        end
      end
      result = computer_board.place(ship, coordinates)
    end
    return computer_board
  end

  def get_random_unhit_coordinates
    @unhit_coordinates.sample
  end

  def take_turn(player_board)
    coordinate = get_random_unhit_coordinates
    player_board.cells[coordinate].fire_upon
    @unhit_coordinates.delete(coordinate)
    @coordinates_track << coordinate
    player_board
  end

  def display_turn_message(player_board)
    coordinate = @coordinates_track.last
    if player_board.cells[coordinate].ship == nil
      return "The Computer's shot on #{coordinate} was a miss."
    elsif player_board.cells[coordinate].ship.sunk?
      return "The Computer's shot on #{coordinate} sunk your #{player_board.cells[coordinate].ship.name}."
    else
      return "The Computer's shot on #{coordinate} was a hit."
    end
  end
end
