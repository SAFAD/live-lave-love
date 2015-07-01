function checkBoard(turns, isWon, turn)
    --print(unpack(turns))
    for i=7,1,-3 do
        --print(i,i+1,i+2) --uncomment to understand the loops functionality
        if (turns[i] == 1 and turns[i+1] == 1 and turns[i+2] == 1) or (turns[i] == 2 and turns[i+1] == 2 and turns[i+2] == 2) then
            --checks for horizontal win
            isWon = 1
        end
    end

    for i=1,3 do
        --[[uncomment the two lines below to understand how these work
            print(i,i+3,i+6)
            print('-------')
            ]]--
        if (turns[i] == 1 and turns[i+3] == 1 and turns[i+6] == 1) or (turns[i] == 2 and turns[i+3] == 2 and turns[i+6] == 2) then
            --checks for vertical win
            isWon = 1
        end
    end

    for i=3,1,-2 do
        --[[uncomment the two lines below to understand how these work
            print('-------')
            print(i,5,10-i)]]--
        if (turns[i] == 1 and turns[5] == 1 and turns[10-i] == 1) or (turns[i] == 2 and turns[5] == 2 and turns[10-i] == 2) then
            --checks for a Cross win
            isWon = 1
        end
    end

    
    --now we check for draw
    if table.getn(symbols) == 9 and isWon == -1 then
        --its a draw fellas
        isWon = 2
    end

    if isWon == -1 then
        if turn > 1 then --switch turns
            turn = 1
        else
            turn = 2
        end
    end
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

--[[ the AI mumbo Jumbo starts here
def score(game, depth)
    if game.win?(@player)
        return 10 - depth
    elsif game.win?(@opponent)
        return depth - 10
    else
        return 0
    end
end

def minimax(game, depth)
    return score(game) if game.over?
    depth += 1
    scores = [] # an array of scores
    moves = []  # an array of moves

    # Populate the scores array, recursing as needed
    game.get_available_moves.each do |move|
        possible_game = game.get_new_state(move)
        scores.push minimax(possible_game, depth)
        moves.push move
    end

    # Do the min or the max calculation
    if game.active_turn == @player
        # This is the max calculation
        max_score_index = scores.each_with_index.max[1]
        @choice = moves[max_score_index]
        return scores[max_score_index]
    else
        # This is the min calculation
        min_score_index = scores.each_with_index.min[1]
        @choice = moves[min_score_index]
        return scores[min_score_index]
    end
end
]]--
