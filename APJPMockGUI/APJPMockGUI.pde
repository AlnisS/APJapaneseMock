import net.lingala.zip4j.crypto.*;
import net.lingala.zip4j.crypto.PBKDF2.*;
import net.lingala.zip4j.crypto.engine.*;
import net.lingala.zip4j.core.*;
import net.lingala.zip4j.progress.*;
import net.lingala.zip4j.util.*;
import net.lingala.zip4j.unzip.*;
import net.lingala.zip4j.io.*;
import net.lingala.zip4j.zip.*;
import net.lingala.zip4j.model.*;
import net.lingala.zip4j.exception.*;

import g4p_controls.*;
import peasy.*;

import ddf.minim.*;
Minim minim;

boolean ready = false;
String fileFlag = null;

public void setup() {
  size(640, 480, JAVA2D);
  selectInput("Select the input zip:", "fileSelected");
}

public void draw() {
  background(255);
  updateTime();
}

void fileSelected(File selection) {
  if (selection != null) {
    fileFlag = selection.getAbsolutePath();
    createGUI();
    customGUI();
    minim = new Minim(this);
    loadTest();
    ready = true;
  } else {
    exit();
  }
}

public void customGUI() {
}
