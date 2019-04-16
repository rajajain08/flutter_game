# Swipe Card Flutter

Freely Movable,Swipable Cards with fully customizable UI and leftSwipe,rightSwipe and onTap call backs.

# Demo
![Demo](https://github.com/rajajain08/flutter_game/blob/flare_intigration/screenshots/shooter_flare-min.gif)
![Demo](https://github.com/rajajain08/flutter_game/blob/flare_intigration/screenshots/shooter_plane-min.gif)


##### Checkout Examples  [here](https://github.com/rajajain08/swipe_cards_flutter/tree/master/animation_exp/lib/Examples)

# Call Backs
  - onSwipeLeft - Returns index of card in list.
  - onSwipeRight - Returns index of card in list.
  - onCardTap - Returns index of card in list.

### Installation
```sh
flutter run
```
### How to use
```sh
new GestureCardDeck(
      isButtonFixed: false,
      data: imageData,
      animationTime: Duration(milliseconds: 500),
      showAsDeck: true,
      velocityToSwipe: 1200,
      leftSwipeButton: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            )),
        child:
            Center(child: Text("NOPE", style: TextStyle(color: Colors.white))),
      ),
      rightSwipeButton: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            )),
        child:
            Center(child: Text("YEAH", style: TextStyle(color: Colors.white))),
      ),
      onSwipeLeft: (index) {
        print("on swipe left");
        print(index);
      },
      onSwipeRight: (index) {
        print("on swipe right");
        print(index);
      },
      onCardTap: (index) {
        print("on card tap");
        print(index);
      },
      leftPosition: 50,
      topPosition: 90,
      leftSwipeBanner: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Transform.rotate(
          angle: 0.5,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("NOPE",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.red,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
      rightSwipeBanner: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Transform.rotate(
          angle: -0.5,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("YEAH",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
```
