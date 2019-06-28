import java.io.File; //<>//

Table test;
ArrayList<Action> actions;
Action currentAction = null;
int currentActionIndex;

void loadTest() {
  new File(dataPath("save/")).mkdirs();
  try {
    new ZipFile(fileFlag).extractAll(dataPath(""));
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
  test = loadTable("input/long.tsv", "header");
  actions = new ArrayList<Action>();
  for (TableRow row : test.rows())
    actions.add(new Action(row));
  for (Action action : actions)
    println(action);
  goToIndex(0);
}

void updateTime() {
  if (!ready)
    return;
  if (currentAction.isTimed()) {
    float remainingTime = currentAction.remainingTime();
    if (remainingTime < 0) {
      next();
    }
    timeLabel.setText(formatTime(int(remainingTime)));
  }
  if (currentAction.type == ActionType.LISTENING) {
    if (currentAction.player != null) {
      if (!currentAction.player.isPlaying()) {
        next();
      } else {
        PGraphics v = progressBar.getGraphics();
        v.beginDraw();
        v.background(200);
        v.noStroke();
        v.fill(127);
        v.rect(0, 0, map(currentAction.player.position(), 0, currentAction.player.length(), 0, v.width), v.height);
        v.endDraw();
      }
    }
  }
  if (currentAction.type == ActionType.SPEAKING) {
    if (currentAction.recorder != null) {
      PGraphics v = progressBar.getGraphics();
      v.beginDraw();
      v.background(200);
      v.noStroke();
      v.fill(127);
      v.rect(0, 0, 
        map(millis() / 1000., currentAction.endTime - currentAction.time, currentAction.endTime, 0, v.width), v.height);
      v.endDraw();
    }
  }
}

String formatTime(int seconds) {
  return padInt(seconds / 60) + ":" + padInt(seconds % 60);
}

String padInt(int number) {
  return number < 10 ? "0" + number : str(number);
}

void goToIndex(int index) {
  if (index >= 0 && index < actions.size()) {
    currentActionIndex = index;
    currentAction = actions.get(currentActionIndex);
    updateAllDisplayStates(currentAction);
    currentAction.setupGUI();
    statusLabel.setText("Screen " + (currentActionIndex + 1) + " of " + actions.size());
  }
  if (index == actions.size()) {
    selectFolder("Select Output Directory", "folderSelected");
  }
}

void folderSelected(File selection) {
  if (selection != null) {
    fileFlag = selection.getAbsolutePath();
    endTest();
  }
}

void next() {
  if (currentAction.type == ActionType.LISTENING)
    currentAction.player.pause();
  if (currentAction.type == ActionType.SPEAKING) {
    currentAction.recorder.endRecord();
    currentAction.recorder.save();
  }
  goToIndex(currentActionIndex + 1);
}

void previous() {
  goToIndex(currentActionIndex - 1);
}

void optionSelected(Option option) {
  currentAction.setOption(option);
}

void deleteDataFolder(String f) {
  File folder = new File(dataPath(f));
  String[] entries = folder.list();
  for (String s : entries) {
    new File(folder.getAbsolutePath(), s).delete();
  }
  folder.delete();
}

void endTest() {
  String[] save = new String[actions.size()];
  for (int i = 0; i < actions.size(); i++) {
    save[i] = actions.get(i).saveString();
  }
  saveStrings("data/save/result.txt", save);

  try {
    File f = new File(fileFlag + "/save.zip");
    if (f.exists())
      f.delete();
    new ZipFile(fileFlag + "/save.zip").addFolder(new File(dataPath("save/")), new ZipParameters());
  } 
  catch (Exception e) {
    e.printStackTrace();
  }

  deleteDataFolder("input");
  deleteDataFolder("save");

  exit();
}
