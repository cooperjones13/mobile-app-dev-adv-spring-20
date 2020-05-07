//
//  SecondViewController.swift
//  lab-01-tabs-and-pickers
//
//  Created by Cooper Jones on 2/5/20.
//  Copyright © 2020 Cooper Jones. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController, AVAudioPlayerDelegate,
AVAudioRecorderDelegate{

	@IBOutlet weak var record: UIButton!
	@IBOutlet weak var stop: UIButton!
	@IBOutlet weak var play: UIButton!
	
	
	let session = AVAudioSession.sharedInstance()
	var player:AVAudioPlayer?
	var recorder:AVAudioRecorder?
	
	let filename = "audio.m4a"
	
	
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		play.isEnabled = false
		stop.isEnabled = false
		
		let dirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let docDir = dirPath[0]
		let audioURL = docDir.appendingPathComponent(filename)
		print(audioURL)
		
		do{
			try session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .init(rawValue: 1))
		}catch{
			print("Audio Session Error: \(error.localizedDescription)")
		}
		let settings = [
			AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
			AVSampleRateKey: 1200,
			AVNumberOfChannelsKey: 1,
			AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
		]
		
		do{
			recorder = try AVAudioRecorder(url: audioURL, settings: settings)
			recorder?.prepareToRecord()
			print("Recorder Ready!")
		} catch{
			print("Recorder Error: \(error.localizedDescription)")
		}
    }
	
	
	
	
	@IBAction func recordAudio(_ sender: Any) {
		if let rec = recorder{
			if rec.isRecording == false{
				play.isEnabled = false
				stop.isEnabled = true
				rec.delegate = self
				rec.record()
			}
			
		}else{
			print("No audio recorder instance")
		}
		
	}
	
	@IBAction func stopAudio(_ sender: Any) {
		play.isEnabled = true
		stop.isEnabled = false
		record.isEnabled = true
		
		if recorder?.isRecording == true {
			recorder?.stop()
		} else{
			player?.stop()
			do{
				try session.setCategory(AVAudioSession.Category.playAndRecord)
			}catch{
				print("Stop Error: \(error.localizedDescription)")
			}
		}
		
	}
	
	
	@IBAction func playAudio(_ sender: Any) {
		
		if recorder?.isRecording == false{
			stop.isEnabled = true
			record.isEnabled = false
			
			do{
				try player = AVAudioPlayer(contentsOf: (recorder?.url)!)
				try session.setCategory(AVAudioSession.Category.playback)
				player!.delegate = self
				player!.prepareToPlay()
				player!.play()
			}catch{
				print("Player Error: \(error.localizedDescription)")
			}
		}
	}
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		record.isEnabled = true
		stop.isEnabled = false
		play.isEnabled = false
		do{
			try session.setCategory(AVAudioSession.Category.playAndRecord)
		}catch{
			print(error.localizedDescription)
		}
	}
	

}

