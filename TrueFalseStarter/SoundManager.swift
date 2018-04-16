//
//  SoundManager.swift
//  TrueFalseStarter
//
//  Created by Michele Mola on 16/04/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundManager {
  let fileName: String
  let fileType: String
  var idSound: SystemSoundID
  
  init(fileName: String, fileType: String, idSound: SystemSoundID) {
    self.fileName = fileName
    self.fileType = fileType
    self.idSound = idSound
  }
  
  func load() {
    let pathToSoundFile = Bundle.main.path(forResource: self.fileName, ofType: self.fileType)
    let soundURL = URL(fileURLWithPath: pathToSoundFile!)
    AudioServicesCreateSystemSoundID(soundURL as CFURL, &idSound)
  }
  
  func play() {
    AudioServicesPlaySystemSound(idSound)
  }
  
}
