/******************************************************
      Created by Bernardo Cassina 24/03/2015

          Composer Memory Game / Composer Memorama
******************************************************/

import 'dart:html';
import 'dart:async';
//dart2js --out=main.js memory_game.dart
//dev_appserver.py deploy

/* GAME CONFIG */
//This strings are used as classes
const String _CARD_BACK = 'clef';
const List<String> _COMPOSERS = const ['bach', 'bartok',
                                        'beetho', 'brahms',
                                        'liszt', 'pucc',
                                        'rach', 'tchai'];
//To keep track of new deck every new game
List<String> currentDeck = new List();

//Game rules and user score update
int cardsLeft = 16;
int strikes = 0;

//Elements handled int the DOM
Element gameCanvas = querySelector('.game-canvas');
Element userController = querySelector('.user-controller');
DivElement userAlert = new DivElement();
ImageElement lastClickedCard;
/* */

/* MAIN FUNCTION */
void main() {
  newGame();
}

/* GAME HANDLERS */
//New Game method
void newGame() {
  restart();
}

//Create new list (deck) of composers. Display the cards and
// add composer name as class to display composer photo.
void shuffleCards() {
  for(int i = 0; i < (cardsLeft / _COMPOSERS.length); i++) {
    for(String composer in _COMPOSERS) {
      currentDeck.add(composer);
    }
  }
  currentDeck.shuffle();

  for(String composer in currentDeck) {
    ImageElement card = new ImageElement();
    card.classes.add(composer + ' card' + ' card-back');
    gameCanvas.append(card);
  }
}


//Main logic, user interactivity. Quits or restarts game.
void gameAsyncAction(MouseEvent event) {
  //Get current clicked card and flip it
  ImageElement clickedCard = event.target;
  clickListener(clickedCard);
  //If the user hasn't click any two <img> yet,
  // add the current <img> clicked as the last <img> clicked
  if (lastClickedCard == null) {
    lastClickedCard = clickedCard;
    //If the user found a pair,
    // end method: don't flip that composer back
    //TODO append Overlay instead of beaten to solve
  } else if(clickedCard.classes.contains('beaten')) {
    return;
  } else {
    //Test if it is a match between last clicked <img> and current <img> and
    //add elements to DOM and update game scoring
    if(lastClickedCard.classes.toString() == clickedCard.classes.toString()){
      reloadCardsLeft();
      userController.insertAdjacentElement('afterBegin', userAlert);
      userAlert.text = 'MATCH! \n Cards left: ${cardsLeft} \n Strikes: ${strikes}';
      //Add beaten class so the user can't flip current <img> back
      beatPair(clickedCard);
      beatPair(lastClickedCard);
    }
    //Test after every beaten pair if got any chances left.
    // If so, end game and ask for Restart or Quit.
    //TODO change order of if statements
    else if(strikes == 8) {
      endGame();
      //Test if it's a strike and, elements to DOM to update game scoring and
      //Flip back the cards clicked after 1 second
    } else {
      reloadStrikes();
      userController.insertAdjacentElement('afterBegin', userAlert);
      userAlert.text = 'STRIKE! \n Cards left: ${cardsLeft} \n Strikes: ${strikes}';
      ImageElement tempClicked = lastClickedCard;
      Timer t = new Timer(const Duration(seconds: 1), () {
        flipBack(clickedCard);
        flipBack(tempClicked);
      });
    }
    //Reset last clicked <img> to begin a new user try
    lastClickedCard = null;
  }
}

//Update cards left
void reloadCardsLeft() {
  cardsLeft-=2;
}
//Update Strikes
void reloadStrikes() {
  strikes++;
}
//Flip card back
void flipBack(ImageElement element) {
  element.classes.add('card-back');
}
//Beaten card method
void beatPair(ImageElement element) {
  element.classes.add('beaten');
}
//Click listener method for every user selection
void clickListener(Element element) {
  element.classes
    ..remove('card-back')
    ..add('flipped');
}
//Restart game method
void restart() {
  shuffleCards();
  querySelectorAll('.card').onClick.listen(gameAsyncAction);
}
//End game method asks for restart or quit
void endGame(){
  //Appends Overlay z-index > game canvas
  DivElement overlay = new DivElement();
  overlay.setAttribute('style', 'background-color: black; z-index:3;');
  querySelector('body').insertAdjacentElement('afterEnd', overlay);
  //Pops div > Overlay TODO with Restart or quit buttons & score
  DivElement yesOrNo = new DivElement();
  overlay.setAttribute('style', 'background-color: blue; z-index:4;');
  querySelector('body').insertAdjacentElement('afterEnd', yesOrNo);
}
/*TODO bool quit(){
//Quit erases the DOM entirely must reload page to new game
// while(!quit) => new game
  bool quit;
  querySelector('.quit-game-button').onClick.listen((Event event) {
    quit == true;
  });
  return quit;
}
*/











