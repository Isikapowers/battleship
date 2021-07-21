require "./lib/ship"
require "./lib/cell"
require "./lib/board"

RSpec.describe Board do
  context "states" do
    it "exists" do
      board = Board.new(10, 10)
      expect(board).to be_an_instance_of(Board)
    end

    it "has cells" do
      board = Board.new(4, 4)

      expect(board.cells.keys).to eq(["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"])
    end
  end

  context "behaviors" do
    it "has valid coordinates" do
      board = Board.new(4, 4)

      expect(board.valid_coordinate?("A1")).to eq(true)
      expect(board.valid_coordinate?("D4")).to eq(true)
      expect(board.valid_coordinate?("A5")).to eq(false)
      expect(board.valid_coordinate?("E1")).to eq(false)
      expect(board.valid_coordinate?("A22")).to eq(false)
    end

    it "has valid placement" do
      board = Board.new(4, 4)

      cruiser = Ship.new("Cruiser", 3)
      submarine = Ship.new("Submarine", 2)

      expect(board.valid_placement?(cruiser, ["A1", "A2"])).to eq(false)
      expect(board.valid_placement?(submarine, ["A2", "A3", "A4"])).to eq(false)
      expect(board.valid_placement?(cruiser, ["A1", "A2", "A4"])).to eq(false)
      expect(board.valid_placement?(submarine, ["A1", "C1"])).to eq(false)
      expect(board.valid_placement?(cruiser, ["A3", "A2", "A1"])).to eq(false)
      expect(board.valid_placement?(submarine, ["C1", "B1"])).to eq(false)
      expect(board.valid_placement?(cruiser, ["A1", "B2", "C3"])).to eq(false)
      expect(board.valid_placement?(submarine, ["C2", "D3"])).to eq(false)
      expect(board.valid_placement?(submarine, ["A1", "A2"])).to eq(true)
      expect(board.valid_placement?(cruiser, ["B1", "C1", "D1"])).to eq(true)
    end

    it "has coordinates in the same row" do
      board = Board.new(4, 4)

      expect(board.all_in_same_row?(["A1", "A2", "A3"])).to eq(true)
      expect(board.all_in_same_row?(["A2", "A3"])).to eq(true)
      expect(board.all_in_same_row?(["A1", "A2", "B4"])).to eq(false)
      expect(board.all_in_same_row?(["A1", "C1"])).to eq(false)
      expect(board.all_in_same_row?(["A3", "A2", "A1"])).to eq(true)
    end

    it "has coordinates in the same row with consecutive numbers" do
      board = Board.new(4, 4)

      expect(board.all_in_same_row_consecutive?(["A1", "A2", "A3"])).to eq(true)
      expect(board.all_in_same_row_consecutive?(["A2", "A3"])).to eq(true)
      expect(board.all_in_same_row_consecutive?(["A1", "A2", "B4"])).to eq(false)
      expect(board.all_in_same_row_consecutive?(["A1", "C1"])).to eq(false)
      expect(board.all_in_same_row_consecutive?(["A3", "A2", "A1"])).to eq(false)

      board = Board.new(10, 10)
      expect(board.all_in_same_row_consecutive?(["A8", "A9", "A10"])).to eq(true)
    end

    it "has coordinates in the same column" do
      board = Board.new(4, 4)

      expect(board.all_in_same_column?(["A1", "B1", "C1"])).to eq(true)
      expect(board.all_in_same_column?(["B2", "C2"])).to eq(true)
      expect(board.all_in_same_column?(["A1", "C1", "B4"])).to eq(false)
      expect(board.all_in_same_column?(["A1", "C2"])).to eq(false)
      expect(board.all_in_same_column?(["A3", "A2", "A1"])).to eq(false)
      board = Board.new(10, 10)
      expect(board.all_in_same_column?(["A10", "B10", "C10"])).to eq(true)
    end

    it "has coordinates in the same column with consecutive chars" do
      board = Board.new(4, 4)

      expect(board.all_in_same_column_consecutive?(["A1", "B1", "C1"])).to eq(true)
      expect(board.all_in_same_column_consecutive?(["A2", "B2"])).to eq(true)
      expect(board.all_in_same_column_consecutive?(["A1", "A2", "B4"])).to eq(false)
      expect(board.all_in_same_column_consecutive?(["A1", "C1"])).to eq(false)
      expect(board.all_in_same_column_consecutive?(["C2", "B2", "A2"])).to eq(false)
    end

    it "can place a ship" do
      board = Board.new(4, 4)
      sub = Ship.new("Submarine", 2)
      cruiser = Ship.new("Cruiser", 3)
      board.place(cruiser, ["A1", "A2", "A3"])
      cell_1 = board.cells["A1"]
      cell_2 = board.cells["A2"]
      cell_3 = board.cells["A3"]

      expect(cell_1.ship).to eq(cruiser)
      expect(cell_2.ship).to eq(cruiser)
      expect(cell_3.ship).to eq(cruiser)
      expect(cell_1.ship == cell_2.ship).to eq(true)

      expect(board.place(sub, ["E3", "A1"])).to eq("Your spaces are invalid. Please try again:")
    end

    it "knows when ships are overlapped" do
      board = Board.new(4, 4)

      cruiser = Ship.new("Cruiser", 3)
      board.place(cruiser, ["A1", "A2", "A3"])

      expect(board.overlapping?(["A1", "B1"])).to eq(true)
      expect(board.overlapping?(["B2", "B3"])).to eq(false)
    end

    it "can render a board" do
      board = Board.new(4, 4)

      cruiser = Ship.new("Cruiser", 3)
      board.place(cruiser, ["A1", "A2", "A3"])

      expect(board.render).to eq("  1 2 3 4\nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
      expect(board.render(true)).to eq("  1 2 3 4\nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")

      submarine = Ship.new("Submarine", 2)
      board.place(submarine, ["B2", "C2"])

      expect(board.render(true)).to eq("  1 2 3 4\nA S S S . \nB . S . . \nC . S . . \nD . . . . \n")

      board.cells["A1"].fire_upon
      board.cells["B4"].fire_upon
      expect(board.render(true)).to eq("  1 2 3 4\nA H S S . \nB . S . M \nC . S . . \nD . . . . \n")

      board.cells["B2"].fire_upon
      board.cells["C2"].fire_upon
      expect(board.render(true)).to eq("  1 2 3 4\nA H S S . \nB . X . M \nC . X . . \nD . . . . \n")
    end
  end
end
