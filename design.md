#Game
handles input and output, uses the rest as model
## properties
- gameState: GameSate
## methods
- play() - starts interactive loop
- state() - get and set state


GameState
## properties
- game: Game
## methods
- done() // is game done?
- next() // go to next state
- printState() // prints the players stats and game state

InitialState: GameState
PlayState: GameState
EndState: GameState


Player
## properties
lives: number
## methods
lose_life



Question
## properties
question: string
answer: number
## methods
static getRandomQuestion(): Question
answer(number): boolean
