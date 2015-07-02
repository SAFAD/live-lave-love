local AI = class('AI')

function AI:initialize(...)
    
end


function checkBoard(turns, isWon, turn)
    --print(unpack(turns))
    

    
    return isWon, turn
end

function score(isWon, depth)
	if isWon == 1 then
	    if turn == 1 then
	        return 10 - depth --calculate score for player
	    else
	        return depth - 10 -- score for AI
	    end
	end
	if isWon == 2 then
        return 0 -- a draw return
    end
end

chosenMove = null

function minmax(board, depth, isWon, turn)
    
    local isWon, turn = checkBoard(board, isWon, turn)
    
    
    if isWon == 1 or isWon == 2 then
        print('I AM HERE BOY')
        return {score(isWon, depth), chosenMove}
    end

    depth = depth+1
    scores = {}
    moves = {}

    for i,v in ipairs(getAvailableMoves(board)) do
        possibleMove = getNewBoard(board, v, turn)
        minmaxv = minmax(possibleMove, depth, isWon, turn)
        chosenMove = minmaxv[3]
        table.insert(scores, minmaxv[1])
        table.insert(moves, v)
    end

    if turn == 1 then
        maxScoreIndex = max(scores)
        chosenMove = moves[maxScoreIndex]
        return {scores[maxScoreIndex], chosenMove}
    else
        minScoreIndex = min(scores)
        chosenMove = moves[minScoreIndex]
        return {scores[minScoreIndex], chosenMove}
    end

end

function getAvailableMoves(board)
    local moves = {}
    for i,v in ipairs(board) do

        if v == 0 then
            table.insert(moves, i)
        end
    end
    return moves
end

function getNewBoard(board, move, turn)
    board[move] = turn
    return board
end

function max(array)
    local index = 0
    local max = 0
    for i, v in ipairs(array) do
        if v > max then
            index, max = i, v
        end
    end
    return index
end

function min(array)
    local index = 0
    local min = 0
    for i, v in ipairs(array) do
        if v < min then
            index, min = i, v

        end
    end
    return index
end

