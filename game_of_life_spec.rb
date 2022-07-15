# spec file
require_relative 'game_of_life.rb'
require 'rspec'
require 'pry'

describe "game of life" do
    let!(:world) { World.new }
    let!(:cell) { Cell.new(1,1) }
    let!(:game) { Game.new(world, [[1, 1]]) }

    context Game do
        let(:subject) { Game.new }

        it 'should create a new game object' do
            expect(subject.is_a?(::Game)).to be true
            # expect(subject.world.cell_grid[1][1].alive).to be true
        end

        it 'should respond to proper methods' do
            expect(subject).to respond_to :world
            expect(subject).to respond_to :seeds
        end

        it 'should initialize properly' do
            expect((subject.world).is_a?(::World)).to be true
            expect((subject.seeds).is_a?(::Array)).to be true
        end

        it 'should plant seeds properly' do
            game = Game.new(world, [[0,1], [1,1]])
            expect(game.world.cell_grid[0][1].alive).to be true
            expect(game.world.cell_grid[1][1].alive).to be true
        end

        it 'Counts cells properly' do
            game = Game.new(world, [[0, 1], [1, 1], [2, 1]])
            expect(world.live_cells.count) == 3
            expect(world.dead_cells.count) == 6
          end
    end

    context World do
        it 'should be a world object' do
         expect( World.new )
        end

        it 'should create a new world object' do
            expect(subject).not_to be nil
        end

        it 'should respond to proper methods' do
           expect(subject).to respond_to :cols
           expect(subject).to respond_to :rows
           expect(subject).to respond_to :live_neighbors_around_cell
           expect(subject).to respond_to :cell_grid
           expect(subject).to respond_to :cells
        end

        it 'should create proper cell grid on initialization' do
            expect(subject.cell_grid.is_a?(::Array)).to be true

            subject.cell_grid.each do |row|
                expect(row.is_a?(::Array)).to be true
                row.each do |col|
                    expect(col.is_a?(Cell)).to be true
                end
            end
        end

        it 'can count cells' do
            expect(subject.cells.count) == subject.rows * subject.cols
        end

        it 'should add all cells to cells array' do
           expect(subject.cells.count).to eq(9)
        end

        it 'Can count live cells' do
            expect(subject.live_cells.count) == 0
            game.world.cell_grid[1][1].alive = true
            expect(subject.cell_grid[1][1].alive) == true
            expect(subject.live_cells.count) == 1
          end

        it 'should detect a neighbor to the North' do
            expect(subject.cell_grid[cell.y - 1][cell.x].alive?) == true
            expect(subject.live_neighbors_around_cell(cell).count) == 1
        end

        it 'should detect a neighbor to the northeast' do
            expect(subject.cell_grid[cell.y - 1][cell.x - 1].alive?) == true
            expect(subject.live_neighbors_around_cell(cell).count) == 1
        end

        it 'should detect a neighbor to the northwest' do
            expect(subject.cell_grid[cell.y - 1][cell.x + 1].alive?) == true
            expect(subject.live_neighbors_around_cell(cell).count) == 1
        end

        it 'should detect a neighbor to the East' do
            expect(subject.cell_grid[cell.y][cell.x + 1].alive?) == true
            expect(subject.live_neighbors_around_cell(cell).count) == 1
        end

        it 'should detect a neighbor to the South' do
            subject.cell_grid[cell.y + 1][cell.x].alive == true
            subject.live_neighbors_around_cell(cell).count == 1
        end

        it 'should detect a neighbor to the south east' do
            expect(subject.cell_grid[cell.y + 1][cell.x + 1].alive?) == true
            expect(subject.live_neighbors_around_cell(cell).count) == 1
        end

        it 'should detect a neighbor to the West' do
            expect(subject.cell_grid[cell.y][cell.x - 1].alive?) == true
            expect(subject.live_neighbors_around_cell(cell).count) == 1
        end
    end

    context Cell do
        let(:cell) { Cell.new }

        it 'should create a new cell object' do
            expect(subject.is_a?(Cell)).to be true
        end

        it 'should respond to proper methods' do
            expect(subject).to respond_to :alive, :x, :y, :alive?, :die!

        end

        it 'should initialize properly' do
            expect(subject.alive).to be false
            expect(subject.x).to eq(0)
            expect(subject.y).to eq(0)
        end
    end

    context 'Rules' do
    let(:game) { Game.new }

        context 'Rule 1: Any live cell with fewer than two live neighbours dies (referred to as underpopulation).' do
            it 'should kill a live cell with no neighbors' do
                game.world.cell_grid[1][1].alive = true
                expect(game.world.cell_grid[1][1]).to be_alive 
                game.tick!
                expect(game.world.cell_grid[1][1]).to be_dead
            end
            
            it 'should kill a live cell with 1 live neighbor' do
                game = Game.new(world, [[1,0],[2,0]])
                game.tick! # describes a method that changes the object permenantly
                expect(world.cell_grid[1][0]).to be_dead
                expect(world.cell_grid[2][0]).to be_dead
            end  

            it 'doesnt kill live cell with 2 neighbors' do
                game = Game.new(world, [[0,1], [1,1], [2,1]])
                game.world.cell_grid[1][1].alive = true
                game.tick!
                expect(world.cell_grid[1][1]).to be_alive
            end
        end

        context 'Rule 2: Any live cell with two or three live neighbours lives on to the next generation.' do
            it 'should keep cell alive with two live neighbors onto the next gen' do
                game = Game.new(world, [[0,1], [1,1], [2,1]])
                expect(world.live_neighbors_around_cell(world.cell_grid[1][1]).count) == 2
                game.tick!
                expect(world.cell_grid[0][1]).to be_dead
                expect(world.cell_grid[1][1]).to be_alive
                expect(world.cell_grid[2][1]).to be_dead
            end

            it 'it should keep cell alive w 3 neighbors onto next gen' do
                game = Game.new(world, [[0,1], [1,1], [2,1], [2,2]])
                expect(world.live_neighbors_around_cell(world.cell_grid[1][1]).count) == 3
                game.tick!
                expect(world.cell_grid[0][1]).to be_dead
                expect(world.cell_grid[1][1]).to be_alive
                expect(world.cell_grid[2][1]).to be_alive
                expect(world.cell_grid[2][2]).to be_alive
            end
        end

        context 'Rule 3: Any live cell with more than three live neighbours dies, as if by overpopulation.' do
            it 'should kill all live cells with more than 3 live neighbors' do
                game = Game.new(world, [[0,1], [1,1], [2,1], [2,2], [1,2]])
                expect(world.live_neighbors_around_cell(world.cell_grid[1][1]).count) == 4
                game.tick!
                binding.pry 
                expect(world.cell_grid[0][1]).to be_alive
                expect(world.cell_grid[1][1]).to be_dead
                expect(world.cell_grid[2][1]).to be_alive
                expect(world.cell_grid[2][2]).to be_alive
                expect(world.cell_grid[1][2]).to be_dead
            end
        end
    end     
 end