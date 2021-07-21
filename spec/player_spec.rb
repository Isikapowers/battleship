require "./lib/cell"
require "./lib/board"
require "./lib/player"
require "./lib/ship"

RSpec.describe Player do
  context "initialize" do
    it 'exists' do
      player = Player.new

      expect(player).to be_a(Player)
    end

    it 'tracks coordinates already used' do
      opponent_board = Board.new
      player = Player.new

      expect(player.coordinates_track).to eq([])
    end
  end

  context 'methods' do
    it 'takes a turn' do
      opponent_board = Board.new
      player = Player.new

      player.take_turn("A1", opponent_board)
      expect(player.coordinates_track).to eq(["A1"])
      expect(opponent_board.render).to eq("  1 2 3 4\nA M . . . \nB . . . . \nC . . . . \nD . . . . \n")

      expect(player.take_turn("A1", opponent_board)).to eq("You have already entered this coordinate. Try again:")
      expect(player.take_turn("Z1", opponent_board)).to eq("This is an invalid coordinate. Try again:")
    end

    it 'creates turn messages' do
      opponent_board = Board.new
      player = Player.new
      ship = Ship.new("Cruiser", 3)
      ship2 = Ship.new("Submarine", 2)
      opponent_board.place(ship, ["A1", "A2", "A3"])

      player.take_turn("A1", opponent_board)
      expect(player.display_turn_message("A1", opponent_board)).to eq("Your shot on A1 was a hit.")

      player.take_turn("B1", opponent_board)
      expect(player.display_turn_message("B1", opponent_board)).to eq("Your shot on B1 was a miss.")

      player.take_turn("A2", opponent_board)
      player.take_turn("A3", opponent_board)
      expect(player.display_turn_message("A3", opponent_board)).to eq("Your shot on A3 sunk their Cruiser.")
    end
  end
end
