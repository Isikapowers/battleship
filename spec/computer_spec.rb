require "./lib/cell"
require "./lib/board"
require "./lib/computer"
require "./lib/ship"

RSpec.describe Computer do
  context "initialize" do
    it 'exists' do
      computer = Computer.new

      expect(computer).to be_a(Computer)
    end

    it 'keeps track of all used coordinates' do
      computer = Computer.new

      expect(computer.coordinates_track).to eq([])
    end

    it 'tracks coordinates have not been used' do
      computer = Computer.new
      board = Board.new

      expect(computer.unhit_coordinates).to eq(board.cells.keys)
    end
  end

  context 'methods' do
    it 'takes a turn randomly' do
      board = Board.new
      computer = Computer.new

      allow(computer).to receive(:get_random_unhit_coordinates).and_return("A3")

      board = computer.take_turn(board)

      expect(computer.unhit_coordinates.length).to eq(15)
      expect(computer.coordinates_track).to eq(["A3"])
      expect(board.render).to eq("  1 2 3 4\nA . . M . \nB . . . . \nC . . . . \nD . . . . \n")
    end

    it "can randomly place ships" do
      computer_board = Board.new
      computer = Computer.new
      ship2 = Ship.new("Submarine", 2)

      allow(computer).to receive(:get_random_coordinate).and_return("A1")
      allow(computer).to receive(:get_random_direction).and_return(0)

      expect(computer.place_ship(computer_board, ship2).render(true)).to eq("  1 2 3 4\nA S S . . \nB . . . . \nC . . . . \nD . . . . \n")

      cruiser = Ship.new("Cruiser", 3)

      allow(computer).to receive(:get_random_coordinate).and_return("B2")
      allow(computer).to receive(:get_random_direction).and_return(1)

      expect(computer.place_ship(computer_board, cruiser).render(true)).to eq("  1 2 3 4\nA S S . . \nB . S . . \nC . S . . \nD . S . . \n")
    end

    it 'can display turn messages' do
      board = Board.new
      computer = Computer.new
      ship = Ship.new("Cruiser", 3)
      ship2 = Ship.new("Submarine", 2)
      board.place(ship2, ["A1", "A2"])

      allow(computer).to receive(:get_random_unhit_coordinates).and_return("A3")

      board = computer.take_turn(board)

      expect(computer.display_turn_message(board)).to eq("The Computer's shot on A3 was a miss.")

      allow(computer).to receive(:get_random_unhit_coordinates).and_return("A1")

      board = computer.take_turn(board)

      expect(computer.display_turn_message(board)).to eq("The Computer's shot on A1 was a hit.")

      allow(computer).to receive(:get_random_unhit_coordinates).and_return("A2")

      board = computer.take_turn(board)

      expect(computer.display_turn_message(board)).to eq("The Computer's shot on A2 sunk your Submarine.")
    end
  end
end
