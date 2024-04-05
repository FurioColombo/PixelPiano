
class PianoHeroPage implements Page {
  
  String midiFilePath;
  int pageIndex = PIANO_HERO_PAGE_INDEX;
  DropdownList midiFilesDropdown;
  String[] midiFilesDropdownItemList;
  Button backButton;
  Button loadMidiButton;
  Button prepareMidiButton;
  Button startMidiButton;
  float[] midiFilesDropdownPosition;
  float[] backButtonPosition;
  float[] loadMidiButtonPosition;
  float[] startMidiButtonPosition;
  float[] prepareMidiButtonPosition;
  float[] inactivePosition;
  float[] midiNameTextPosition;
  ButtonClickListener buttonClickListener;
  GroupControlListener groupControlListener;
  Fingers fingers;
  PlayPagePiano keyboard;
  int currentTime=0;
  int prevTime=0;
  int diff;
  int index = 0;
  ArrayList<FallingNote> fallingNotes;
  float pianoHeight;
  float keyWidth;
  float margin;
  float velocity = 1;
  float rectY = 0;
  float barLength;
  float speed = 3;
  float[] heights = new float[36];
  float[] rectHeight = new float[36];
  int[] blackKeys = {1,3,6,8,10,13,15,18,20,22,25,27,30,32,34};
  float[][] played = {
    {40, 1000, 7000}, {43,500,10000},{40, 250, 10000}, {40,250,11000}
  };

  MidiLoader midiLoader;
  GameNoteSequence noteSequence;

  public PianoHeroPage() {
    this.fingers = new Fingers();
    this.keyboard = new PlayPagePiano();

    this.pianoHeight = height/3;
    this.margin = width / 10;
    this.keyWidth = (width -  margin) / 21;
    this.noteSequence = new GameNoteSequence();

    this.midiFilesDropdownItemList = new String[] {"BWV_0578.mid", "HesaPirate.mid"};
    this.midiFilePath = this.midiFilesDropdownItemList[0];

    this.midiLoader = new MidiLoader();

    this.buttonsSetup();
    this.textSetup();

    for(int i = 0; i<heights.length; i++){
        heights[i] = -1000000;
    }
    
    for(int j = 0; j<rectHeight.length; j++){
      rectHeight[j] = Float.POSITIVE_INFINITY;
    }
    
    fallingNotes = new ArrayList<FallingNote>();
  }

  public int getID(){
    return this.pageIndex;
  }

  public String[] getMidiFilesDropdownItemList(){
    return this.midiFilesDropdownItemList;
  }

  public void handleButtonClick(ControlEvent event) {
    if (!event.isController()) return;
    String buttonName = event.getController().getName();
    
    if ("pianoHeroBackButton".equals(buttonName)) {
      navigationController.changePage(activePage, modeSelectionPage);

    } else if ("pianoHeroLoadMidiButton".equals(buttonName)) {
      this.midiLoader.setMidiFilePath();
    } else if ("pianoHeroPrepareMidiButton".equals(buttonName)) {
      this.noteSequence = this.midiLoader.computeGameNoteSequence();
      this.midiFilePath = this.midiLoader.getMidiFilePath();

    } else if ("pianoHeroStartMidiButton".equals(buttonName)) {
      
    } else if ("pianoHeroMidiFilesDropdown".equals(buttonName)) {   
      println("value: " + this.midiFilesDropdown.getValue());
      this.midiFilePath = sketchPath() + "\\" + this.midiFilesDropdownItemList[round(this.midiFilesDropdown.getValue())];
      this.midiLoader.setMidiFilePath(this.midiFilePath);
      print("Set new midi file path: " + this.midiFilePath);
    }
  }
  
  public float defineKey(int inx){
    if(Arrays.binarySearch(blackKeys, inx )>=0){ 
      keyWidth = ((width - margin) / 21) / 1.5;
    } else {
      keyWidth = (width - margin) / 21;
    }
    return keyWidth;
  }

  public void draw() {
    prevTime = currentTime;
    currentTime = millis();
    diff = currentTime - prevTime;
    println(diff);


    if (index<played.length && millis() > played[index][2]){
      int noteNumber = (int)played[index][0]%36;
      FallingNote note = new FallingNote(keyboard.getCoord(noteNumber), -played[index][1]/30*speed, defineKey(noteNumber), played[index][1]/30*speed, speed); //<>//

      fallingNotes.add(note);
      index++;
    }

    for (int i = fallingNotes.size()-1; i >= 0; i--) {
      FallingNote note = fallingNotes.get(i);
      note.update();
      note.draw();
      if (note.isOffScreen()) {
        fallingNotes.remove(i);
      }

    }
    
    
     // keyboard
    this.keyboard.setNotes(notesOutput);
    this.keyboard.draw();
    
    // fingers
    notesOutput = this.fingers.getPressedNotes(notesInput, pressedSens, shift, this.keyboard);
    this.fingers.positions(coordinates);

    // text 
    this.drawText();
    if (30-diff >0){
      delay(30-diff);
    }
     
  }
   //<>//

  private void buttonsSetup(){ //<>//
    this.buttonClickListener = new ButtonClickListener(this);
    this.groupControlListener = new GroupControlListener(this); 

    this.midiFilesDropdownPosition = new float[] {width/20, height/20};
    this.backButtonPosition = new float[] {9*width/10 + 5, 9*height/10 + 25};
    this.loadMidiButtonPosition = new float[] {width/20 , 9*height/10 + 25}; 
    this.prepareMidiButtonPosition = new float[] {5.5*width/10, 9*height/10 + 25};
    this.startMidiButtonPosition = new float[] {7.25*width/10, 9*height/10 + 25};
    this.inactivePosition = new float[] {-1000, -1000};

    this.midiFilesDropdown = cp5.addDropdownList("pianoHeroMidiFilesDropdown")
      .setSize(width/5, 300);
    this.setDropdownStyle(this.midiFilesDropdown);
    this.midiFilesDropdown.addItems(this.midiFilesDropdownItemList);

    this.backButton = cp5.addButton("pianoHeroBackButton")
            .setSize(width/15,30);
    styleManager.setDefaultButtonStyle(this.backButton);
    this.backButton.setLabel("Back");

    this.loadMidiButton = cp5.addButton("pianoHeroLoadMidiButton")
      .setSize(width/7,30);
    styleManager.setDefaultButtonStyle(this.loadMidiButton); 
    this.loadMidiButton.setLabel("Load Midi File");

    this.prepareMidiButton = cp5.addButton("pianoHeroPrepareMidiButton")
      .setSize(width/6,30);
    styleManager.setDefaultButtonStyle(this.prepareMidiButton);
    this.prepareMidiButton.setLabel("Prepare Midi File");
      
    this.startMidiButton = cp5.addButton("pianoHeroStartMidiButton")
      .setSize(width/10,30);
    styleManager.setDefaultButtonStyle(this.startMidiButton);
    this.startMidiButton.setLabel("Start");
    this.addListeners();
  }

  
  public void setVisibility(boolean isVisible){
    if(isVisible){
      this.backButton.setPosition(this.backButtonPosition);
      this.loadMidiButton.setPosition(this.loadMidiButtonPosition);
      this.prepareMidiButton.setPosition(this.prepareMidiButtonPosition);
      this.startMidiButton.setPosition(this.startMidiButtonPosition);
      this.midiFilesDropdown.setPosition(this.midiFilesDropdownPosition);
    } else {
      this.backButton.setPosition(this.inactivePosition);
      this.loadMidiButton.setPosition(this.inactivePosition); 
      this.prepareMidiButton.setPosition(this.inactivePosition);
      this.startMidiButton.setPosition(this.inactivePosition);
      this.midiFilesDropdown.setPosition(this.inactivePosition);
    } 
  }

  public void addListeners(){
    this.backButton.addListener(this.buttonClickListener); 
    this.loadMidiButton.addListener(this.buttonClickListener);
    this.prepareMidiButton.addListener(this.buttonClickListener);
    this.startMidiButton.addListener(this.buttonClickListener);
    this.midiFilesDropdown.addListener(this.groupControlListener);
  }
  public void removeListeners(){}

  
  private void setDropdownStyle(DropdownList ddl) {
    ddl.setPosition(this.inactivePosition);
    ddl.setColorBackground(color(0));
    ddl.setColorForeground(color(50));
    ddl.setVisible(true);
    ddl.setColorActive(color(50));
    ddl.getCaptionLabel().setFont(styleManager.customFont);
    ddl.setItemHeight(30);
    ddl.setBarHeight(30);
    ddl.setColorActive(color(50));
    ddl.setOpen(false);
    ddl.setColorLabel(color(255));
    ddl.setColorValue(color(255));
    ddl.setLabel("Select Midi File"); 
  }

  private void textSetup(){
    this.midiNameTextPosition = new float[] {4*width/20, 9*height/10 + 35};
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
  }

  private void drawText(){
    fill(0);
    textSize(20);
    textAlign(LEFT, CENTER);
    this.midiFilePath = this.midiFilePath != midiLoaderSelectedMIDIFilePath? midiLoaderSelectedMIDIFilePath : this.midiFilePath;
    String midiFileName = this.midiFilePath.contains("\\") ? this.midiFilePath.substring(this.midiFilePath.lastIndexOf("\\") + 1) : this.midiFilePath;
    text(midiFileName, this.midiNameTextPosition[0], this.midiNameTextPosition[1]);
  }
}
