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
    var audioPlayer2:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    // refactor: stop play, engine and reset all audios
    func stopAllAudios(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer2.stop()
    }
    
    func playAudioWithEcho(){
        stopAllAudios()
        audioPlayer.currentTime = 0
        audioPlayer.play()
        
        let delay:NSTimeInterval = 0.2//100ms
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
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
    
    
    func playAudioWithReverb(blend:Float){
        stopAllAudios()
        
        // create instance AVAudioPlayerNode and be attached by AVAudioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // create instance of AVAudioUnitReverb, load and set value to this node, attach this node to AVAudioEngine instace
        var reverbEffectNode = AVAudioUnitReverb()
        reverbEffectNode.loadFactoryPreset(AVAudioUnitReverbPreset.LargeRoom)
        reverbEffectNode.wetDryMix = blend
        audioEngine.attachNode(reverbEffectNode)
        
        // connect the instance of AVAudioPlayerNode to the instance of AVAudioUnitReverb
        // connect the instance of AVAudioUnitReverb to the output of the AVAudioEngine's instance
        audioEngine.connect(audioPlayerNode, to: reverbEffectNode, format: nil)
        audioEngine.connect(reverbEffectNode, to: audioEngine.outputNode, format: nil)
        
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
        println("play with slow effect")
        playAudioWithRate(0.5)
    }

    @IBAction func playSoundsFastEffect(sender: UIButton) {
        println("play with fast effect")
        playAudioWithRate(1.5)
    }
    
    @IBAction func playSoundsChipMunkEffect(sender: UIButton) {
        println("play with chipmunk effect")
        playAudioWithPitch(1000)
    }
    
    @IBAction func playSoundsDarthVaderEffect(sender: UIButton) {
        println("play with darthvader effect")
        playAudioWithPitch(-1000)
    }
    
    @IBAction func stop(sender: UIButton) {
        println("stop playing")
        stopAllAudios()
    }
    
    @IBAction func playSoundsReverbEffect(sender: UIButton) {
        println("play with reverb effect")
        playAudioWithReverb(50)
    }
    
    @IBAction func playSoundsWithEchoEffect(sender: UIButton) {
        println("play with echo effect")
        playAudioWithEcho()
    }
}
