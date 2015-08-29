//
//  PlaySoundsViewController.swift
//  New Pitch Perfect
//
//  Created by  Trung Trinh on 8/17/15.
//  Copyright (c) 2015 Trung Trinh. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    // refactor: stop play, engine and reset all audios
    func stopAllAudios(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithPitch(pitch:Float){
        stopAllAudios()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var pitchEffectNode = AVAudioUnitTimePitch()
        pitchEffectNode.pitch = pitch
        audioEngine.attachNode(pitchEffectNode)
        
        audioEngine.connect(audioPlayerNode, to: pitchEffectNode, format: nil)
        audioEngine.connect(pitchEffectNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    // refactor
    func playAudioWithRate(rate:Float){
        stopAllAudios()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    @IBAction func playSoundsSlowEffect(sender: UIButton) {
        playAudioWithRate(0.5)
    }

    @IBAction func playSoundsFastEffect(sender: UIButton) {
        playAudioWithRate(1.5)
    }
    
    @IBAction func playSoundsChipMunkEffect(sender: UIButton) {
        playAudioWithPitch(1000)
    }
    
    @IBAction func playSoundsDarthVaderEffect(sender: UIButton) {
        playAudioWithPitch(-1000)
    }
    
    @IBAction func stop(sender: UIButton) {
        stopAllAudios()
    }
}
