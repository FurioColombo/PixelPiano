void oscEvent(OscMessage msg) {
    try {
      if (msg.checkAddrPattern("/note_numbers")) {
        int argumentCount = msg.arguments().length; // Get the number of arguments in the message
        int[] receivedValues = new int[argumentCount]; 
  
        for (int i = 0; i < argumentCount; i++) {
            int receivedValue = msg.get(i).intValue();
            receivedValues[i] = receivedValue-12-shift;
            //println("notesInput: "+ receivedValues[i]);
            }
        notesInput = receivedValues;
      }
      
    if (msg.checkAddrPattern("/belapressure")){
              int argumentCount = msg.arguments().length;
              for(int i = 0; i< argumentCount; i++){
                 //prevPressureValues[i] = pressedSens[i];
                 pressedSens[i] = msg.get(i).intValue();
              } 
              println(pressedSens);
          }
      
      if(msg.checkAddrPattern("/coords")){
        int argumentCount = msg.arguments().length; // Get the number of arguments in the message
        for (int i = 0; i < argumentCount; i++) {
              coordinates[i] = msg.get(i).floatValue();
            }
      }
    } catch (Exception e) {
      println("Error handling OSC message: " + e.getMessage());
      e.printStackTrace();
    }
}