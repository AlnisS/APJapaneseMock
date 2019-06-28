import java.util.Arrays;

class Action {
  ActionType type;
  String[] parameters;
  float time;
  boolean previous, next;
  Option option;
  float endTime;

  boolean timed;
  AudioPlayer player;
  String file;
  PImage image;
  AudioInput in;
  AudioRecorder recorder;

  Action(TableRow row) {
    type = ActionType.valueOf(row.getString(0));
    parameters = new String[6];
    for (int i = 0; i < 5; i++)
      parameters[i] = row.getString(i + 1);
    timed = !Float.isNaN(time = row.getFloat(6));
    previous = row.getString(7).equals("TRUE");
    next = row.getString(8).equals("TRUE");
    option = null;
    endTime = Float.NaN;
    file = parameters[1];
    if (type == ActionType.LISTENING) {
      player = minim.loadFile("input/" + file);
      time = player.length();
      image = loadImage("input/" + parameters[2]);
      PGraphics v = largeImage.getGraphics();
      v.beginDraw();
      v.background(0);
      v.image(image, 0, 0);
      v.endDraw();
    }
    if (type == ActionType.SPEAKING) {
      in = minim.getLineIn();
      recorder = minim.createRecorder(in, "data/save/" + file);
    }
  }

  boolean isTimed() {
    return timed;
  }

  float remainingTime() {
    return endTime - (millis() / 1000.);
  }

  void setupGUI() {
    if (isTimed())
      endTime = millis() / 1000. + time;
    switch (type) {
    case INSTRUCTIONS:
      instructionsLabel.setText(parameters[0]);
      break;
    case SINGLE_QUESTION:
      questionLabel.setText(parameters[0]);
      option1.setText(parameters[1]);
      option2.setText(parameters[2]);
      option3.setText(parameters[3]);
      option4.setText(parameters[4]);
      if (option == null)
        option5.setSelected(true);
      else switch (option) {
      case A:
        option1.setSelected(true);
        break;
      case B:
        option2.setSelected(true);
        break;
      case C:
        option3.setSelected(true);
        break;
      case D:
        option4.setSelected(true);
        break;
      }
      break;
    case LISTENING:
      shortInstructionsLabel.setText(parameters[0]);
      player.play();
      break;
    case SPEAKING:
      shortInstructionsLabel.setText(parameters[0]);
      recorder.beginRecord();
    }
  }

  void setOption(Option option) {
    this.option = option;
  }

  String saveString() {
    switch (type) {
    case INSTRUCTIONS:
      return "N/A";
    case SINGLE_QUESTION:
      if (option == null)
        return "No answer selected.";
      return option.toString();
    case LISTENING:
      return "N/A";
    case SPEAKING:
      return file;
    default: 
      return null;
    }
  }

  public String toString() {
    return type.toString() + " " + Arrays.toString(parameters) + " " + time + " " + previous + " " + next + " " + option;
  }
}

enum Option { 
  A, B, C, D
}
