//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Roger Villarreal on 4/16/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
// import Audio and Video library
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder? // nil if there is no value
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder() {
        do {
            // Create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            // Create a URL for the audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            // Create settings for the audio recorder
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
            // Create AudioRecorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            // Stop the recording
            audioRecorder?.stop()
            playButton.isEnabled = true
            
            // Change button title to Record
            recordButton.setTitle("Record", for: .normal)
            
            // Hide Add button until the recording is complete
            addButton.isEnabled = true
            
        } else {
            // Start recording
            audioRecorder?.record()
            // Change button title to stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        } catch {}
    }
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        
        sound.name = nameTextField.text
        sound.audioFile = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController?.popViewController(animated: true)
    }
}

