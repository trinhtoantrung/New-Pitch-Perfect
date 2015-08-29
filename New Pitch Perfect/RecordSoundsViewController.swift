//
//  RecordSoundsViewController.swift
//  New Pitch Perfect
//
//  Created by  Trung Trinh on 8/17/15.
//  Copyright (c) 2015 Trung Trinh. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var timer: NSTimer!
    let tabToRecordString = "Tab to Record"
    let recordingString = "Recording"
    let resumeString = "Resume"

    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "recording", userInfo: nil, repeats: true);
    }
    
    func recording() {
        if recordingLabel.text == recordingString {
            recordingButton.highlighted = !recordingButton.highlighted
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // hide the stop button
        stopButton.hidden = true
    }

    @IBAction func record(sender: UIButton) {
        // TODO: Record the user's voice
        // show the stop button
        
        // Tab to record
        if recordingLabel.text == tabToRecordString {
            println("in recording audio")
            recordingLabel.text = recordingString
            stopButton.hidden = false
        
            // record audio
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
            let recordingName = "my_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } else if recordingLabel.text == recordingString {
            println("pause recoring")
            pauseRecording()
        } else if recordingLabel.text == resumeString {
            println("resume recording")
            resumeRecording()
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        println("stop recording")
        recordingLabel.text = tabToRecordString
        
        // stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            // save recorded audio
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathUrl: recorder.url)
            
            // move to the next scence
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)

        } else {
            println("recording was not successful")
            //recordingButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func pauseRecording() {
        audioRecorder.pause()
        recordingLabel.text = resumeString
    }
    
    func resumeRecording() {
        audioRecorder.record()
        recordingLabel.text = recordingString
    }
}

