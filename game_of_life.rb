# basic file

require 'pry'

class Game 
    attr_accessor :world, :seeds

    def initialize(world=World.new, seeds=[])
        @world = world
        @seeds = seeds

        seeds.each do |seed|
            world.cell_grid[seed[0]][seed[1]].alive = true
        end
    end

    def tick!
        next_round_live_cells = []
        next_round_dead_cells = []
        # Rule 1
        world.cells.each do |cell|
            # rule 1
            # Any live cell with fewer than two live neighbours dies
            next_round_dead_cells.push(cell) if cell.alive? and world.live_neighbors_around_cell(cell).count < 2
            # rule 2
             # Any live cell with two or three live neighbours lives on to the next generation
             next_round_live_cells.push(cell) if cell.alive? && ([2, 3].include?(world.live_neighbors_around_cell(cell).count))
             # rule 3
             # Any live cell with more than three live neighbours dies
            next_round_dead_cells.push(cell) if cell.alive? && world.live_neighbors_around_cell(cell).count > 3
            # rule 4
            # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction
            next_round_live_cells.push(cell) if cell.alive? && world.live_neighbors_around_cell(cell).count == 3
        end

        next_round_live_cells.each do |cell| 
            cell.revive!
        end

        next_round_dead_cells.each do |cell|
            cell.die!
        end
    end
end

class World 
    attr_accessor :rows, :cols, :cell_grid, :cells # generates read/write methods for rows and cols
    
    def initialize(rows=3, cols=3)
        @rows = rows
        @cols = cols
        @cells = []
    

        @cell_grid = Array.new(rows) do |row| # defines an array with as many elements as there are rows
                        Array.new(cols) do |col| # creates new array in place of first element in rows array
                            Cell.new(col, row)           # initialize new cell object
                        end
                    end

                    cell_grid.each do |row|
                        row.each do |element|
                          if element.is_a?(Cell)
                            cells << element
                          end
                        end
                    end
    end

    def live_neighbors_around_cell(cell)
        live_neighbors = []

        # it detects a neighbor to the north
        if cell.y > 0  # y can be 0 or 1
            candidate = self.cell_grid[cell.y - 1][cell.x]
            live_neighbors.push(candidate) if candidate.alive? 
        end

        # it detects a neighbor to the north east
        if cell.y > 0 && cell.x < (cols - 1) # y can be 1 or 2, x can be 0 or 1
            candidate = self.cell_grid[cell.y - 1][cell.x + 1]
            live_neighbors.push(candidate) if candidate.alive? 
        end

        # it detects a neighbor to the east
        if cell.x > 0
            candidate = self.cell_grid[cell.y][cell.x + 1]
            live_neighbors.push(candidate) if candidate.alive?
        end

        # it detects a neighbor to the northwest
        if cell.y > 0 && cell.x > 0 # x or y can be 1 or 2
            candidate = self.cell_grid[cell.y - 1][cell.x - 1]
            live_neighbors.push(candidate) if candidate.alive?
        end
        # it detects a neighbor to the south
        if cell.y < (rows - 1)
            candidate = self.cell_grid[cell.y + 1][cell.x]
            live_neighbors.push(candidate) if candidate.alive? 
        end

        # it detects a neighbor to the south east
        if cell.y < (rows - 1) && cell.x < (cols + 1) 
            candidate = self.cell_grid[cell.y + 1][cell.x + 1]
            live_neighbors.push(candidate) if candidate.alive? 
        end

        # it detects a neighbor to the south west
        if cell.y < (rows - 1) && cell.x > 0
            candidate = self.cell_grid[cell.y + 1][cell.x - 1]
            live_neighbors.push(candidate) if candidate.alive? 
        end

        # it detects a neighbor to the west
        if cell.x < (cols - 1)
            candidate = self.cell_grid[cell.y][cell.x + 1]
            live_neighbors.push(candidate) if candidate.alive?
        end

        live_neighbors
    end

    def live_cells
      cells.select { |cell| cell.alive }
    end
    
    def dead_cells
      cells.select { |cell| cell.alive == false }
    end
end

class Cell
    attr_accessor :alive, :x, :y, :dead

    def initialize(x=0, y=0)
        @alive = false
        @x = x
        @y = y
    end

    def alive?
        alive
    end

    def dead?
        !alive
    end

    def die!
       @alive = false
    end

    def revive!  
        @alive = true
    end
end

