local class = require("middleclass")
require('Game')
AI = class('AI')
function AI:initialize(gameObject, depth)
    self.choice = null
    self:minmax(gameObject, depth)
end

function AI:Score(gameObject, depth)
    status = gameObject:status()
    turn = gameObject.turn
    if status == 1 then
        if turn == 1 then
            return 10 - depth --calculate score for player
        else
            return depth - 10 -- score for AI
        end
    end
    if status == 2 then
        return 0 -- a draw return
    end
end

function AI:minmax(gameObject, depth)
    if gameObject:status() == 1 or gameObject:status() == 2 then
        return self:Score(gameObject)
    end

    depth = depth+1
    local scores = {}
    local moves = {}
    for i,v in ipairs(self:getAvailableMoves(gameObject)) do
        print('heeere')
        local possibleMove = gameObject.turns
        possibleMove[v] = gameObject.turn
        possibleGame = Game:new(possibleMove,
                        gameObject.turn,
                        {},--example on a symbol array == {drawble, squareKey,turn}
                        depth, 
                        {{35, 40},{190, 40},{345, 40},{35, 190},{190, 190},{345, 190},{35, 345},{190, 345},{345, 345}}) --board hitboxes
        currScore = self:Score(possibleGame, depth)
        table.insert(scores,currScore)
        table.insert(moves, v)
    end

    if gameObject.turn == 1 then
        maxScoreIndex = self:max(scores)
        self.choice = moves[maxScoreIndex]
        return scores[maxScoreIndex]
    else
        minScoreIndex = self:min(scores)
        self.choice = moves[minScoreIndex]
        return scores[minScoreIndex]
    end
end
function AI:getChoice()
    return self.choice
end

function AI:getAvailableMoves(gameObject)
    local moves = {}
    local board = gameObject.turns

    for i,v in ipairs(board) do
        if v == 0 then
            table.insert(moves, i)
        end
    end

    return moves
end

function AI:max(array)
    local index = 0
    local max = 0
    for i, v in ipairs(array) do
        if v > max then
            index, max = i, v
        end
    end
    return index
end

function AI:min(array)
    local index = 0
    local min = 0
    for i, v in ipairs(array) do
        if v < min then
            index, min = i, v

        end
    end
    return index
end