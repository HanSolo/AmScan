//
//  Recognizer.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 23.05.22.
//

import AVFoundation
import Foundation
import Speech
import SwiftUI


class Recognizer: ObservableObject {
    let audioEngine     : AVAudioEngine                         = AVAudioEngine()
    let speechReconizer : SFSpeechRecognizer?                   = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    let request         : SFSpeechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var task            : SFSpeechRecognitionTask!
    var isStart         : Bool                                  = false
    var transcript      : String                                = ""
    
    
    func startSpeechRecognization(){
        self.transcript = ""
        self.speechReconizer?.defaultTaskHint = .dictation
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch let error {
            self.transcript = "Error comes here for starting the audio listner =\(error.localizedDescription)"
        }
        
        guard let myRecognization = SFSpeechRecognizer() else {
            self.transcript =  "Recognization is not allow on your local"
            return
        }
        
        if !myRecognization.isAvailable {
            self.transcript = "Recognization is free right now, Please try again after some time."
        }
        
        task = speechReconizer?.recognitionTask(with: request, resultHandler: { (response, error) in
            guard let response = response else {
                if error != nil {
                    self.transcript = error.debugDescription
                }else {
                    self.transcript = "Problem in giving the response"
                }
                return
            }
            
            let message = response.bestTranscription.formattedString
            
            self.transcript = message
        })
    }
    
    func cancelSpeechRecognization() {
        task.finish()
        task.cancel()
        task = nil
        
        request.endAudio()
        audioEngine.stop()
        //audioEngine.inputNode.removeTap(onBus: 0)
        
        //MARK: UPDATED
        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
    }
}
