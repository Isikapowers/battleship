class Board

  attr_reader :cells, :last_row, :last_column

  def initialize(height = 4, width = 4)
    @last_row = (64 + height).chr
    @last_column = width.to_s
    @cells = create_board
  end

  def create_board
    board_hash = {}
    alphabet = ("A"..@last_row).to_a
    numbers = ("1"..@last_column).to_a
    alphabet.each do |letter|
      numbers.each do |num|
        coordinate = letter + num
        board_hash[coordinate] = Cell.new(coordinate)
      end
    end
    board_hash
  end

  def valid_coordinate?(coordinate)
    @cells.has_key?(coordinate)
  end

  def valid_placement?(ship, coordinates)
    not_all_valid = coordinates.any? do |coordinate|
      valid_coordinate?(coordinate) == false
    end

    if  not_all_valid || ship.length != coordinates.length || overlapping?(coordinates)
      false
    elsif all_in_same_row_consecutive?(coordinates) || all_in_same_column_consecutive?(coordinates)
      true
    else
      false
    end
  end

  def all_in_same_row?(coordinates)
    first_letter = coordinates[0][0]
    coordinates.all? do |item|
      item[0] == first_letter
    end
  end

  def all_in_same_row_consecutive?(coordinates)
    range = 1..@last_column.to_i
    array = range.to_a

    if all_in_same_row?(coordinates) == false
      return false
    end

    valid_coordinates = []
    array.each_cons(coordinates.count) do |item|
      valid_coordinates << item
    end
    actual_coordinates = coordinates.map do |item|
      if item.length == 2
        item[1].to_i
      elsif item.length > 2
        item[1,2].to_i
      end
    end

    valid_coordinates.include?(actual_coordinates)
  end

  def all_in_same_column?(coordinates)
    if @last_column.to_i < 10
      same_number = coordinates[0][1]
      coordinates.all? do |item|
        item[1] == same_number
      end
    else
      same_number = coordinates[0][1..2]
      coordinates.all? do |item|
        item[1..2] == same_number
      end
    end
  end

  def all_in_same_column_consecutive?(coordinates)
    range = "A"..@last_row
    array = range.to_a

    if all_in_same_column?(coordinates) == false
      return false
    end

    valid_coordinates = []

    array.each_cons(coordinates.count) do |item|
      valid_coordinates << item
    end

    actual_coordinates = coordinates.map do |item|
      item[0]
    end

    valid_coordinates.include?(actual_coordinates)
  end

  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
    else
      return "Your spaces are invalid. Please try again:"
    end
  end

  def overlapping?(coordinates)
    coordinates.any? do |coordinate|
      @cells[coordinate].ship != nil
    end
  end

  def render(ship = false)
    strings = " "
    alphabet = ("A"..@last_row).to_a
    numbers = ("1"..@last_column).to_a
    numbers.each do |num|
      strings = strings + " " + num
    end
    strings = strings + "\n"
    alphabet.each do |letter|
      strings = strings + letter+ " "
      numbers.each do |number|
        coordinate = letter + number
        strings = strings + @cells[coordinate].render(ship) + " "
      end
      strings = strings + "\n"
    end
    return strings
  end
end
