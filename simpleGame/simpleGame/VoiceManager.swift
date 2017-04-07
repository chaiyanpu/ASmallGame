//
//  VoiceManager.swift
//  simpleGame
//
//  Created by Yang on 2017/4/6.
//  Copyright © 2017年 Yang. All rights reserved.
//

import Foundation
import AVFoundation

class VoiceManager{
    
    private var audioPlayer:AVAudioPlayer?
    var isPlaying = true
    
    init() {
        let path = Bundle.main.url(forResource:"inMatch", withExtension: "mp3")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: path!)
        }catch{
            print(error)
            return
        }
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.volume = 5
        audioPlayer?.play()
    }
    
    func changePlay(){
        if isPlaying {
            audioPlayer?.stop()
            isPlaying = false
        } else {
            audioPlayer?.play()
            isPlaying = true
        }
    }
    
}
