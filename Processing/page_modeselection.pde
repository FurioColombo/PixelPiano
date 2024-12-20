class ModeSelectionPage implements Page {
  int pageIndex = MODE_SELECTION_PAGE_INDEX;
  Button freePlayButton;
  float[] freePlayButtonPosition;
  Button pianoHeroButton;
  float[] pianoHeroButtonPosition;
  float[] inactivePosition;
  boolean isVisible;
  ButtonClickListener buttonClickListener;
  String pageTitle;
  float titleX;
  float titleY;
  float titleYshadow;
  Fingers fingers;
  Button[] buttonsArray;
  int pressedbut;

  public ModeSelectionPage() {
    background(255);
    this.isVisible = false;
    this.buttonClickListener = new ButtonClickListener(this);
    this.pianoHeroButtonPosition = new float[]{width/2 - 100, height/2 + 50};
    this.freePlayButtonPosition = new float[]{width/2 - 100, height/2 - 50};
    this.inactivePosition = new float[] {-1000, -1000};  
    
    this.fingers = new Fingers();

    // Draw the title
    this.pageTitle = "Select a Mode to Play";
    this.titleX = width / 2;
    this.titleY = height / 6 - 30;
    this.titleYshadow = height / 6 - 30;
    this.setupButtons();
    this.addListeners();
  }

  public void setup(){
    buttonsArray = new Button[2];
    buttonsArray[0] = this.freePlayButton;
    buttonsArray[1] = this.pianoHeroButton;
  }
  
  public void draw(){
    background(255);
    // title 
    this.drawTitle();
    
    // buttons
    styleManager.drawButtonBox(this.freePlayButton, 10.0);
    styleManager.drawButtonBox(this.pianoHeroButton, 10.0);
    for(int i = 0; i < buttonsArray.length; i++){
      checkCoordinates(coordinates, buttonsArray[i], pressedSens);
        
    }
    // fingers
    this.fingers.positions(coordinates);
  }

  public int getID(){
    return this.pageIndex;
  }

  public void addListeners(){
    println(this, "add listeners");
    this.freePlayButton.addListener(this.buttonClickListener);
    this.pianoHeroButton.addListener(this.buttonClickListener);
  }

  public void removeListeners(){
    this.freePlayButton.removeListener(this.buttonClickListener);
    this.pianoHeroButton.removeListener(this.buttonClickListener);
  }

  public void setVisibility(boolean isVisible) {
    println(this, "set visible:", isVisible);
    this.isVisible = isVisible;
    if (this.isVisible) {
      println(this, "set visible position");
      this.freePlayButton.setPosition(this.freePlayButtonPosition);
      this.pianoHeroButton.setPosition(this.pianoHeroButtonPosition);
    } else {
      this.freePlayButton.setPosition(this.inactivePosition);
      this.pianoHeroButton.setPosition(this.inactivePosition);
    }
  }

  public void handleButtonClick(ControlEvent event) {
    println(event.getName());
    if (!event.isController() && !event.isTab()) return;
    String buttonName = event.getName();
    
    switch (buttonName) {
      case "freePlayButton":
        navigationController.changePage(activePage, freePlayPage);
        break;
      case "pianoHeroButton":
        navigationController.changePage(activePage, pianoHeroPage);
        break;
    }
  }

  private void drawTitle(){
    // Draw the title
    textSize(60);
    textAlign(CENTER, CENTER);
  
    // Draw the shadow
    fill(150, 50);
    text(this.pageTitle, titleX + 3, titleY + 3);
    fill(0);
    text(this.pageTitle, titleX, titleYshadow);
  }

  private void setupButtons(){
    // Create and customize "Free Play" button
    this.freePlayButton = cp5.addButton("freePlayButton")
       .setSize(200, 50);
    styleManager.setDefaultButtonStyle(this.freePlayButton);
    this.freePlayButton.setLabel("Free Play");
    
    // Create and customize "Piano Hero" button
    this.pianoHeroButton = cp5.addButton("pianoHeroButton")
       .setSize(200, 50);
    styleManager.setDefaultButtonStyle(this.pianoHeroButton);
    this.pianoHeroButton.setLabel("Piano Hero");

  }
}
