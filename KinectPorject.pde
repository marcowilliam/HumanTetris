/* Kinect Project done for the Physical Computing class
 Marco Silva */

/*For MAC, use MACorPC = "MAC"
 For PC, use  MACorPC = "PC"
 */
final String MACorPC = "MAC";

//constant for the number of movements
final int NMOVEMENTS = 8 ;


//Importing libraries
import SimpleOpenNI.*;
import ddf.minim.*;

//Global Variables

//Audio 
AudioPlayer playerAdvanced;
AudioPlayer playerMenu;
AudioPlayer playerGame;
AudioPlayer playerMenuChoice;
AudioPlayer playerGameOver;
AudioPlayer playerMenuOptions;

Minim minim;
SimpleOpenNI  context;
String[] advancedModeSongs = {
  "songs/song11.mp3", "songs/song12.mp3", "songs/song13.mp3", "songs/song14.mp3", "songs/song15.mp3"
};
String[] menuSongs = {
  "songs/menu1.mp3", "songs/menu2.mp3"
};
String[] gameOverSongs = {
  "songs/gameOverSad.mp3", "songs/gameOverHappy.mp3"
};


String playerPosition1 = "";

//variables for the parts of the body
PVector realHead=new PVector();
PVector projHead=new PVector();
PVector realNeck=new PVector();
PVector projNeck=new PVector();
PVector realLShoulder=new PVector();
PVector projLShoulder=new PVector();
PVector realRShoulder=new PVector();
PVector projRShoulder=new PVector();
PVector projRElbow=new PVector();
PVector realRElbow=new PVector();
PVector projLElbow=new PVector();
PVector realLElbow=new PVector();
PVector realLHand=new PVector();
PVector projLHand=new PVector();
PVector realRHand=new PVector();
PVector projRHand=new PVector();
PVector realTorso=new PVector();
PVector projTorso=new PVector();
PVector realLHip=new PVector();
PVector projLHip=new PVector();
PVector realRHip=new PVector();
PVector projRHip=new PVector();
PVector realLKnee=new PVector();
PVector projLKnee=new PVector();
PVector realRKnee=new PVector();
PVector projRKnee=new PVector();
PVector realLFoot=new PVector();
PVector projLFoot=new PVector();
PVector realRFoot=new PVector();
PVector projRFoot=new PVector();

//Variables related to the score
float playerHeight = 0;
int highScore = 0;
int currentScore = 0;
int score = 0;
int mainMenu = 0;

int lives = 5;
int startGame = 0;
int userId;
int saveLastXposition = 0;
int nextXposition = 0;
int status3Decision = 0;
int status = 0;
/* -1 = GameOver
 0 = StartingGame
 1 = Trainning Mode
 2 = Advanced Mode
 3 = Continue/Exit Mode
 4 = Instructions screen
 */

int[] userList;

//Images
PImage gameover;
PImage backGround00;
PImage backGround01;
PImage backGround0;
PImage backGround1;
PImage continueExit;
PImage continueExitContinue;
PImage continueExitExit;
PImage menu;
PImage menuTraining;
PImage menuAdvanced;
PImage menuInstructions;
PImage instructionsScreen;
PImage menuOk;
PImage cloud;
PImage backgroundGame;
float moveCloudY = 0;

float velocity = 0.03;
float velocityControl = 1;
float moveY[] = new float[4];
ArrayList<Movement> movement = new ArrayList<Movement>(4);
ArrayList<Movement> listOfMovement = new ArrayList<Movement>(4);
int count[] = new int[4];
PImage imgType;
int[] positionsX = {
  0, 300, 600, 900
};

void setup() {

  size(1200, 700);

  minim = new Minim(this);
  playerGame = minim.loadFile("songs/slap.mp3", 2048);
  playerAdvanced = minim.loadFile(advancedModeSongs[(int)random(5)], 2048);
  playerMenu = minim.loadFile(menuSongs[(int)random(2)],2048);
  playerGameOver = minim.loadFile(gameOverSongs[0],2048);
  playerMenuOptions = minim.loadFile("songs/menuOptions.mp3",2048);
  playerMenuChoice = minim.loadFile("songs/menuChoice.mp3",2048);
  cloud = loadImage("gameRunning/cloud.png");
  backgroundGame = loadImage("gameRunning/backGroundGame.png");
  backGround00 = loadImage("menusImages/backGround00.png");
  gameover = loadImage("menusImages/gameover.png");
  backGround01 = loadImage("menusImages/backGround01.png");
  backGround0 = loadImage("menusImages/backGround1.png");
  backGround1 = loadImage("menusImages/backGround2.png");
  menu = loadImage("menusImages/MainMenu.png");
  menuTraining = loadImage("menusImages/MainMenuTrainingMode.png");
  menuAdvanced = loadImage("menusImages/MainMenuAdvancedMode.png");
  menuInstructions = loadImage("menusImages/MainMenuInstructions.png");
  instructionsScreen = loadImage("menusImages/InstructionsScreen.png");
  menuOk = loadImage("menusImages/MainMenuOK.png");
  continueExit = loadImage("menusImages/continueExit.png");
  continueExitContinue = loadImage("menusImages/continueExitContinue.png");
  continueExitExit = loadImage("menusImages/continueExitExit.png");
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // enable depthMap generation 
  context.enableDepth();
  context.enableUser();

  smooth();
}
void draw() {

  
  // update the cam
  context.update();
  trackPlayer();


  //Show the GameOver screen when the game is over
  if (status==-1) {
    playerAdvanced.pause();
    playerGameOver.play();
    image(gameover, 0, 0, width, height);
    if (frameCount>100) {
      frameCount = 0;
      status =0;
    }
  }
  //Show the "position your self in front of the kinect" screen when it does not recognize the player
  if (status==0) { 
    playerAdvanced.pause(); 
    startScreen();
  }
  //Run the game and all the functions that go along it
  if (status==1) { 
    drawClouds();
    setupMovements();
    playerMenu.pause();
    playerAdvanced.play();
    runGame();
    drawSkeleton();
    drawMovements();
    dropMovement();
    detectMovement();
    countLives();
    checkGameOver();
    showScoreLives();
  }

  if (status == 2) {
    
    drawClouds();
    setupMovements();
    playerMenu.pause();
    playerAdvanced.play();
    runGame();
    drawSkeleton();
    drawMovements();
    dropMovement();
    detectMovement();
    countLives();
    checkGameOver();
    showScoreLives();
  }

  if (status == 3) {
    playerAdvanced.pause();
    startScreen();
  }
  
  if (status == 4){
    instructionsScreen();
  }
 // scale(-1,1);
  textSize(32);
      fill(0);
      //text("projRHand.y > projRShoulder.y "+projRHand.y+">"+projRShoulder.y, 50, 70);
      //text("projRElbow.y <= projRShoulder.y "+projRElbow.y+"<="+projRShoulder.y, 50, 120);
  fill(255);
 // scale(-1,1);
}

void dropMovement() {

  for (int i = 0; i<movement.size (); i++) {
    if (movement.get(i).draw == true) {
      moveY[i] = moveY[i] + velocity;
      movement.get(i).y = movement.get(i).y + moveY[i];
    }
  }
  if ( score!= 0 && score%3 == 0 && velocity <1.5) {
    if((score/velocityControl) == 3){
        velocity = velocity + 0.03;
        velocityControl++;
    }
  }
}

void runGame() {

  //background(255);
  movement.get(0).draw = true;
  drawMovement(movement.get(0));

  if (frameCount>300) {
    drawMovement(movement.get(1));
    movement.get(1).draw = true;
  }
  if (frameCount>1000) {
    drawMovement(movement.get(2));
    movement.get(2).draw = true;
  }
  if (frameCount>2000) {
    drawMovement(movement.get(3));
    movement.get(3).draw = true;
  }
}

void drawMovements() {

  int gettingType = 0;
  int randomType;
  int random = (int)random(NMOVEMENTS);

  if (status == 2) {
    randomType = 8;
  } else {
    randomType = 0;
  }
  for (int i = 0; i<movement.size (); i++) { 
    if (movement.get(i).y>680 || movement.get(i).status == false) {

      if (movement.get(i).y>300) {
        while (nextXposition == saveLastXposition) {
          nextXposition = positionsX[(int)random(3)];
        }

        movement.get(i).x = nextXposition;
        saveLastXposition = nextXposition;
        movement.get(i).draw = true;
        movement.get(i).status = true;
        while (gettingType == 0) {
          for (int j = 0; j<movement.size (); j++) {
            if (j!=i) {
              if (random == movement.get(i).type) {
                random = (int)random(NMOVEMENTS+randomType);
              } else {
                gettingType++;
                movement.get(i).type = random+randomType;
                break;
              }
            }
          }
        }         
        moveY[i] = 0;
        movement.get(i).y = -360;
      }
    }
  }
}

void startScreen() {

  background(255);

  if (userList.length<1) {
    playerMenu.pause();
    image(backGround00, 0, 0, width, height);
  } else {
    
    //If the game is starting
    if (status==0) {
      playerMenu.play();
      //Shows the main menu Image
      image(menu, 0, 0, width, height);

      if (projLHand.y<projTorso.y && projLHand.y>projHead.y) {
        image(menuAdvanced, 0, 0, width, height);
        if(mainMenu!=1){
          playerMenuOptions = minim.loadFile("songs/menuOptions.mp3",2048);
          playerMenuOptions.play();
        }
        mainMenu=1;
      } else if (projLHand.y<projHead.y) {
        if(mainMenu!=2){
          playerMenuOptions = minim.loadFile("songs/menuOptions.mp3",2048);
          playerMenuOptions.play();
        }
        image(menuTraining, 0, 0, width, height);
        mainMenu=2;
      } else if (projLHand.y>projTorso.y) {
        if(mainMenu!=3){
          playerMenuOptions = minim.loadFile("songs/menuOptions.mp3",2048);
          playerMenuOptions.play();
        }
        image(menuInstructions , 0, 0, width, height);
        mainMenu=3;
      }
      text("Last Score: "+currentScore, 100, 600);
      text("Hi-Score: "+highScore, 100, 650);
      
      //Advanced Mode
      if (projRHand.y<projHead.y) {
        if (status==0 && mainMenu==1) {
          if (startGame==0) {
            frameCount=0;
            startGame++;
            playerAdvanced = minim.loadFile(advancedModeSongs[(int)random(5)], 2048);
          }
          playerMenuChoice = minim.loadFile("songs/menuChoice.mp3",2048);
          playerMenuChoice.play();
          status = 1;
          mainMenu=0;
          frameCount = 0;
          loop();
          redraw();
        //Trainning Mode
        } else if (status==0 && mainMenu==2) {
          if (startGame==0) {
            frameCount=0;
            startGame++;
            playerAdvanced = minim.loadFile(advancedModeSongs[(int)random(5)], 2048);

          }
          playerMenuChoice = minim.loadFile("songs/menuChoice.mp3",2048);
          playerMenuChoice.play();
          status = 2;
          mainMenu = 0;
          frameCount = 0;
          loop();
          redraw();
        //Instructions
        } else if (status==0 && mainMenu==3) {
          if (startGame==0) {
            frameCount=0;
            startGame++;
          }
          playerMenuChoice = minim.loadFile("songs/menuChoice.mp3",2048);
          playerMenuChoice.play();
          status = 4;
          mainMenu = 0;
          loop();
          redraw();
        }
      }
    }
    if (status==3) {
      //Shows the continue/exit image
      image(continueExit, 0, 0, width, height);

      if (projLHand.x>projTorso.x) {
        image(continueExitContinue, 0, 0, width, height);
        if(mainMenu!=1){
          playerMenuOptions = minim.loadFile("songs/menuOptions.mp3",2048);
          playerMenuOptions.play();
        }
        mainMenu=1;
      } else if (projLHand.x<projTorso.x) {
        image(continueExitExit, 0, 0, width, height);
        if(mainMenu!=2){
          playerMenuOptions = minim.loadFile("songs/menuOptions.mp3",2048);
          playerMenuOptions.play();
        }
        mainMenu=2;
      }
      text("Last Score: "+currentScore, 100, 600);
      text("Hi-Score: "+highScore, 100, 650);

      if (projRHand.y<projHead.y) {
        if (status==3 && mainMenu==1) {
          playerMenuChoice = minim.loadFile("songs/menuChoice.mp3",2048);
          playerMenuChoice.play();
          status = status3Decision;
          mainMenu=0;
          loop();
          redraw();
        } else if (status==3 && mainMenu==2) {
          playerMenuChoice = minim.loadFile("songs/menuChoice.mp3",2048);
          playerMenuChoice.play();
          lives=0;
          checkGameOver();
          mainMenu=0;
          loop();
          redraw();
        }
      }
    }
  }
}

void instructionsScreen(){
  image(instructionsScreen, 0, 0, width, height);
  if(projLHand.y<projHead.y){
    playerMenuChoice.play();
    status = 0;
  }

}

void detectMovement() {
  /*
      movement.get(order.get(0)).status = false;
   for(int i= 0;i<order.size();i++){
   println(order.get(i));
   }
   */

  for (int i=0; i<movement.size(); i++) {       
    if ( movement.get(i).checkMovement(projHead, projNeck, projLShoulder, projRShoulder, projRElbow, projLElbow, projLHand, projRHand, projTorso, projLHip, projRHip, projLKnee, projRKnee, projLFoot, projRFoot) == true && movement.get(i).status == true && movement.get(i).draw == true && movement.get(i).y > 5) {
      playerGame.play();
      movement.get(i).status = false;
      score = score+1;
    }
  }
  if(projRHand.y > projRKnee.y && projLHand.y > projLKnee.y){
    if (startGame != 0 && status!=4) {
      if (status == 1) {
        status3Decision = 1;
      } else if (status == 2) {
        status3Decision = 2;
      }
    status=3;
    }
  }
}

void trackPlayer() {

  userList = context.getUsers();
  for (int i=0; i<userList.length; i++) {
    if (userList.length>1) {
      text("More than one person is being detected ", 100, 550);
    }
    userId = userList[0];

    if (MACorPC.equals("MAC")) {
      //Tracking the Right Shoulder of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, realLShoulder);
      context.convertRealWorldToProjective(realLShoulder, projLShoulder);
      //Tracking the Left Shoulder of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, realRShoulder);
      context.convertRealWorldToProjective(realRShoulder, projRShoulder);
      //Tracking the Right Elbow of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, realLElbow);
      context.convertRealWorldToProjective(realLElbow, projLElbow);
      //Tracking the Left Elbow of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, realRElbow);
      context.convertRealWorldToProjective(realRElbow, projRElbow);
      //Tracking the Left hand of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, realRHand);
      context.convertRealWorldToProjective(realRHand, projRHand);
      //Tracking the Right hand of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, realLHand);
      context.convertRealWorldToProjective(realLHand, projLHand);
      //Tracking the Right Hip of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, realLHip);
      context.convertRealWorldToProjective(realLHip, projLHip);
      //Tracking the Left Hip of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, realRHip);
      context.convertRealWorldToProjective(realRHip, projRHip);
      //Tracking the Right Knee of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, realLKnee);
      context.convertRealWorldToProjective(realLKnee, projLKnee);
      //Tracking the Left Knee of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, realRKnee);
      context.convertRealWorldToProjective(realRKnee, projRKnee);
      //Tracking the Right Foot of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, realLFoot);
      context.convertRealWorldToProjective(realLFoot, projLFoot);
      //Tracking the Left Foot of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, realRFoot);
      context.convertRealWorldToProjective(realRFoot, projRFoot);
    } else if (MACorPC.equals("PC")) {
      //Tracking the Right Shoulder of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, realRShoulder);
      context.convertRealWorldToProjective(realRShoulder, projRShoulder);
      //Tracking the Left Shoulder of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, realLShoulder);
      context.convertRealWorldToProjective(realLShoulder, projLShoulder);
      //Tracking the Right Elbow of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, realRElbow);
      context.convertRealWorldToProjective(realRElbow, projRElbow);
      //Tracking the Left Elbow of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, realLElbow);
      context.convertRealWorldToProjective(realLElbow, projLElbow);
      //Tracking the Right hand of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, realRHand);
      context.convertRealWorldToProjective(realRHand, projRHand);
      //Tracking the Left hand of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, realLHand);
      context.convertRealWorldToProjective(realLHand, projLHand);
      //Tracking the Right Hip of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, realRHip);
      context.convertRealWorldToProjective(realRHip, projRHip);
      //Tracking the Left Hip of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, realLHip);
      context.convertRealWorldToProjective(realLHip, projLHip);
      //Tracking the Right Knee of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, realRKnee);
      context.convertRealWorldToProjective(realRKnee, projRKnee);
      //Tracking the Left Knee of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, realLKnee);
      context.convertRealWorldToProjective(realLKnee, projLKnee);
      //Tracking the Right Foot of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, realRFoot);
      context.convertRealWorldToProjective(realRFoot, projRFoot);
      //Tracking the Left Foot of the user
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, realLFoot);
      context.convertRealWorldToProjective(realLFoot, projLFoot);
    }  

    //Tracking the Head of the user
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, realHead);
    context.convertRealWorldToProjective(realHead, projHead);
    //Tracking the Neck of the user
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, realNeck);
    context.convertRealWorldToProjective(realNeck, projNeck);
    //Tracking the Torso of the user
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, realTorso);
    context.convertRealWorldToProjective(realTorso, projTorso);
  }
}
void setupMovements() {

  int randomType;
  if (status == 2) {
    randomType = 8;
  } else {
    randomType = 0;
  }
  while (movement.size()<4) {
    //The maximum of movements at the same time in the window is 4, otherwise it would be too much information on it
    movement.add(new Movement(positionsX[(int)random(3)], -365, (int)random(NMOVEMENTS)+randomType));
  }
}
void drawMovement(Movement movement) {

  if (movement.type == 0) {
    imgType = loadImage("advancedModeImages/Movement11.png");
  } else if (movement.type == 1) {
    imgType = loadImage("advancedModeImages/Movement12.png");
  } else if (movement.type == 2) {
    imgType = loadImage("advancedModeImages/Movement13.png");
  } else if (movement.type == 3) {
    imgType = loadImage("advancedModeImages/Movement14.png");
  } else if (movement.type == 4) {
    imgType = loadImage("advancedModeImages/Movement15.png");
  } else if (movement.type == 5) {
    imgType = loadImage("advancedModeImages/Movement16.png");
  } else if (movement.type == 6) {
    imgType = loadImage("advancedModeImages/Movement17.png");
  } else if (movement.type == 7) {
    imgType = loadImage("advancedModeImages/Movement18.png");
  } else if (movement.type == 8) {
    imgType = loadImage("trainingModeImages/Movement1.png");
  } else if (movement.type == 9) {
    imgType = loadImage("trainingModeImages/Movement2.png");
  } else if (movement.type == 10) {
    imgType = loadImage("trainingModeImages/Movement3.png");
  } else if (movement.type == 11) {
    imgType = loadImage("trainingModeImages/Movement4.png");
  } else if (movement.type == 12) {
    imgType = loadImage("trainingModeImages/Movement5.png");
  } else if (movement.type == 13) {
    imgType = loadImage("trainingModeImages/Movement6.png");
  } else if (movement.type == 14) {
    imgType = loadImage("trainingModeImages/Movement7.png");
  } else if (movement.type == 15) {
    imgType = loadImage("trainingModeImages/Movement8.png");
  }
  if (movement.status==false)
    imgType = loadImage("nothing.png");

  image(imgType, movement.x, movement.y);
}

void countLives() {

  for (int i=0; i<movement.size (); i++) {
    if (movement.get(i).y>680 && movement.get(i).draw == true) {
      lives--;
    }
  }
}

void checkGameOver() {

  if (lives==0) {
    if(score>highScore){
       gameover = loadImage("menusImages/gameOver2.png");
       playerGameOver = minim.loadFile(gameOverSongs[1],2048);
    }
    else{
      gameover = loadImage("menusImages/gameover.png");
      playerGameOver = minim.loadFile(gameOverSongs[0],2048);
    }
    highScore = max(highScore, score);
    frameCount = 0;
    currentScore = score;
    score = 0;
    for (int i=0; i<movement.size(); i++) {
      movement.get(i).y = -360;
      movement.get(i).draw = false;
      moveY[i]=0;
    }
    lives = 5;
    status=-1;
    startGame = 0;
    velocity = 0.03;
    velocityControl = 1;
    while (movement.size() != 0) {
      for (int i=0; i<movement.size(); i++) {
        movement.remove(movement.get(i));
      }
    }
    playerMenu = minim.loadFile(menuSongs[(int)random(2)],2048);
  }
}

void showScoreLives(){
    
  int scoreY = 30;
  int scoreX = 110;
  int scoreFill = #FFFFFF;
    stroke(0);
    textSize(32);
    fill(0);
    text("Score: ", 10, 30);
    if(score > highScore){
        scoreFill = #BD0005;
        textSize(60);
        scoreY=50;
        scoreX=100;
    }
    fill(scoreFill);
    text(""+score, scoreX, scoreY);
    textSize(32);
    fill(0);
    text("Lives: ", 1065, 30);
    if(lives>3){
      fill(#009100);
    } else if(lives>1 && lives<4){
      fill(#F8FF45);
    } else if(lives < 2){
      fill(#BD0005);
    }
    textSize(50);
    text(""+lives, 1155, 40);
    fill(255);
    noStroke();


}
void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  if (startGame != 0 && status!=4) {
    if (status == 1) {
      status3Decision = 1;
    } else if (status == 2) {
      status3Decision = 2;
    }
    status=3;
  } else{
    status=0;
  }
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

void drawSkeleton()
{
  noFill();
  stroke(0);
  strokeWeight(5);
  translate(1250, 400);
  scale(0.5);
  if (MACorPC == "MAC") {
    scale(-1, 1);
  }
  beginShape();
  vertex(projHead.x, projHead.y);
  vertex(projNeck.x, projNeck.y);
  vertex(projLShoulder.x, projLShoulder.y);
  vertex(projLElbow.x, projLElbow.y);
  vertex(projLHand.x, projLHand.y);
  endShape();
  beginShape();
  vertex(projNeck.x, projNeck.y);
  vertex(projRShoulder.x, projRShoulder.y);
  vertex(projRElbow.x, projRElbow.y);
  vertex(projRHand.x, projRHand.y);
  endShape();
  beginShape();
  vertex(projRShoulder.x, projRShoulder.y);
  vertex(projTorso.x, projTorso.y);
  vertex(projLShoulder.x, projLShoulder.y);
  vertex(projTorso.x, projTorso.y);
  endShape();
  beginShape();
  vertex(projTorso.x, projTorso.y);
  vertex(projRHip.x, projRHip.y);
  vertex(projRKnee.x, projRKnee.y);
  vertex(projRFoot.x, projRFoot.y);
  endShape();
  beginShape();
  vertex(projTorso.x, projTorso.y);
  vertex(projLHip.x, projLHip.y);
  vertex(projLKnee.x, projLKnee.y);
  vertex(projLFoot.x, projLFoot.y);
  endShape();
  scale(2);
  if (MACorPC == "MAC") {
    scale(-1, 1);
  }
  translate(-1250, -400);
}

void drawClouds() {
  image(backgroundGame, 0, 0, width, height );
  image(cloud, 313, 114+moveCloudY, 100, 40);
  image(cloud, 470, 400+moveCloudY, 181, 76);
  image(cloud, 255, 500+moveCloudY, 33, 14);
  image(cloud, 78, 300+moveCloudY, 116, 49);
  image(cloud, 913, 114+moveCloudY, 76, 32);
  image(cloud, 1000, 700+moveCloudY, 181, 76);
  image(cloud, 10, 800+moveCloudY, 33, 14);
  image(cloud, 678, 1200+moveCloudY, 116, 49);
  
  moveCloudY--;
  //moveX1--;
  //moveX2--;

  if(moveCloudY == -1250)
    moveCloudY = 700;
  //if (moveX1 == -700)
   // moveX1=650;

  //if (moveX2 == -1300)
    //moveX2=50;
   
}

void stop()
{
  playerAdvanced.close();
  minim.stop();
  super.stop();
}

