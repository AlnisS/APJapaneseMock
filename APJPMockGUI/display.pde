void updateAllDisplayStates(Action action) {
  updateAllDisplayStates(action.type, action.isTimed(), action.previous, action.next);
}

void updateAllDisplayStates(ActionType actionType, boolean time, boolean previous, boolean next) {

  topBarVisible(true, true, time, previous, next);

  switch (actionType) {
  case INSTRUCTIONS:
    questionVisible(false);
    progressBarVisible(false);
    largeImageVisible(false);
    instructionsLabelVisible(true);
    shortInstructionsLabelVisible(false);
    break;
  case SINGLE_QUESTION:
    questionVisible(true);
    progressBarVisible(false);
    largeImageVisible(false);
    instructionsLabelVisible(false);
    shortInstructionsLabelVisible(false);
    break;
  case LISTENING:
    questionVisible(false);
    progressBarVisible(true);
    largeImageVisible(true);
    instructionsLabelVisible(false);
    shortInstructionsLabelVisible(true);
    break;
  case SPEAKING:
    questionVisible(false);
    progressBarVisible(true);
    largeImageVisible(true);
    instructionsLabelVisible(false);
    shortInstructionsLabelVisible(true);
    break;
  default:
    break;
  }
}

void topBarVisible(boolean title, boolean status, boolean time, boolean previous, boolean next) {
  titleLabel.setVisible(title);
  statusLabel.setVisible(status);
  timeLabel.setVisible(time);
  previousButton.setVisible(previous);
  nextButton.setVisible(next);
}

void questionVisible(boolean b) {
  questionLabel.setVisible(b);
  option1.setVisible(b);
  option2.setVisible(b);
  option3.setVisible(b);
  option4.setVisible(b);
}

void progressBarVisible(boolean b) {
  progressBar.setVisible(b);
}

void largeImageVisible(boolean b) {
  largeImage.setVisible(b);
}

void instructionsLabelVisible(boolean b) {
  instructionsLabel.setVisible(b);
}

void shortInstructionsLabelVisible(boolean b) {
  shortInstructionsLabel.setVisible(b);
}

enum ActionType {
  INSTRUCTIONS, SINGLE_QUESTION, LISTENING, SPEAKING
}

//ARTICLE_QUESTIONS,
//ARTICLE_ONLY,
//QUESTIONS_ONLY,
//TYPING
