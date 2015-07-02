local class = require("middleclass")

Game = class('Game')

function Game:initialize(board, turn, symbols, depth, squares)
	self.turns   =   board
	self.symbols = symbols
	self.depth   =   depth
	self.turn    =    turn
    self.squares = squares
    _V = {turns = self.turns, symbols = self.symbols, depth =  self.depth, turn =  self.turn, squares = self.squares} --exclusively used for get and set variable methods
end

function Game:resetVariablesTable()

    _V = {turns = self.turns, symbols = self.symbols, depth =  self.depth, turn =  self.turn, squares = self.squares} --exclusively used for get and set variable methods
end

function Game:getVariable(variableName)
    return _V[variableName]
end

function Game:setVariable(variableName, value, args)
    if args ~= null then
        _V[variableName][args] = value
    else
        _V[variableName] = value
    end
    
end

function Game:status() --checks the game status (win, neutral, lose)
	local boardStatus = -1
	for i=7,1,-3 do
        --print(i,i+1,i+2) --uncomment to understand the loops functionality
        if (self.turns[i] == 1 and self.turns[i+1] == 1 and self.turns[i+2] == 1) or (self.turns[i] == 2 and self.turns[i+1] == 2 and self.turns[i+2] == 2) then
            --checks for horizontal win
            boardStatus = 1
        end
    end

    for i=1,3 do
        --[[uncomment the two lines below to understand how these work
            print(i,i+3,i+6)
            print('-------')
            ]]--
        if (self.turns[i] == 1 and self.turns[i+3] == 1 and self.turns[i+6] == 1) or (self.turns[i] == 2 and self.turns[i+3] == 2 and self.turns[i+6] == 2) then
            --checks for vertical win
            boardStatus = 1
        end
    end

    for i=3,1,-2 do
        --[[uncomment the two lines below to understand how these work
            print('-------')
            print(i,5,10-i)]]--
        if (self.turns[i] == 1 and self.turns[5] == 1 and self.turns[10-i] == 1) or (self.turns[i] == 2 and self.turns[5] == 2 and self.turns[10-i] == 2) then
            --checks for a Cross win
            boardStatus = 1
        end
    end

    --now we check for draw
    if table.getn(self.symbols) == 9 and boardStatus == -1 then
        --its a draw fellas
        boardStatus = 2
    end

    return boardStatus
end

function Game:switchTurns(currentTurn)
    if currentTurn == null then
        currentTurn = self.turn
    end
    if currentTurn > 1 then --switch turns
        self.turn = 1
    else
        self.turn =  2
    end
end

function Game:checkMouseHit(mouseX, mouseY)
	local squareKey = null
	for key,value in pairs(self.squares) do
		if mouseX < value[1]+115 and
		   mouseY < value[2]+115 and
		   value[1] < mouseX and
		   value[2] < mouseY then -- simply put, check if the clicked mouse location is inside the square
		   
		   squareKey = key
		   break
		end
	end
	return squareKey
end

function Game:validateInput(squareKey)
	local isValid = true
    if squareKey == null then
        return false
    end
	for i,v in ipairs(self.symbols) do
		if v[2] == squareKey then -- loop through the drawn symbols, if we match something, break to return false
		    return false
		end
	end
	return isValid
end