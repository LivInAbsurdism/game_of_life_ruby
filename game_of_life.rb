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
        # Rule 1
        world.cells.each do |cell|
            if cell.alive? && world.live_neighbors_around_cell(cell).count < 2
                cell.die!
            end
            
            # if cell.alive? && world.live_neighbors_around_cell(cell).count >

        end

        # Rule 2
        # TODO: implement other 3 rules
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
        if cell.y > 0  # y can be 1 or 2
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
end

