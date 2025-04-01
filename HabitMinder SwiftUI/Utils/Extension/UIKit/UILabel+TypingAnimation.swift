//
//  UILabel+TypingAnimation.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 1/9/24.
//

import UIKit
import AudioToolbox

extension UILabel {
    func typingAnimation(audioSoundID: SystemSoundID = 1104, typingDelay: TimeInterval, completion: (() -> Void)? = nil) {
        guard let text = text else {
            completion?()
            return
        }
        self.text = ""
        let characters = Array(text)
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: typingDelay, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            if index < characters.count {
                self.text?.append(characters[index])
                AudioServicesPlaySystemSound(audioSoundID)
                index += 1
            } else {
                timer.invalidate()
                completion?()
            }
        }
    }
}
