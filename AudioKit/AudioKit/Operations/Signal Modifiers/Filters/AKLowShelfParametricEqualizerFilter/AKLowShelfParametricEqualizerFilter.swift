//
//  AKLowShelfParametricEqualizerFilter.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import AVFoundation

public class AKLowShelfParametricEqualizerFilter: AKOperation {

    var internalAU: AKLowShelfParametricEqualizerFilterAudioUnit?
    var token: AUParameterObserverToken?

    var cornerFrequencyParameter: AUParameter?
    var gainParameter:            AUParameter?
    var qParameter:               AUParameter?

    public var cornerFrequency: Float = 1000 {
        didSet {
            cornerFrequencyParameter?.setValue(cornerFrequency, originator: token!)
        }
    }
    public var gain: Float = 1.0 {
        didSet {
            gainParameter?.setValue(gain, originator: token!)
        }
    }
    public var q: Float = 0.707 {
        didSet {
            qParameter?.setValue(q, originator: token!)
        }
    }

    public init(_ input: AKOperation) {
        super.init()

        var description = AudioComponentDescription()
        description.componentType         = kAudioUnitType_Effect
        description.componentSubType      = 0x70657131 /*'peq1'*/
        description.componentManufacturer = 0x41754b74 /*'AuKt'*/
        description.componentFlags        = 0
        description.componentFlagsMask    = 0

        AUAudioUnit.registerSubclass(
            AKLowShelfParametricEqualizerFilterAudioUnit.self,
            asComponentDescription: description,
            name: "Local AKLowShelfParametricEqualizerFilter",
            version: UInt32.max)

        AVAudioUnit.instantiateWithComponentDescription(description, options: []) {
            avAudioUnit, error in

            guard let avAudioUnitEffect = avAudioUnit else { return }

            self.output = avAudioUnitEffect
            self.internalAU = avAudioUnitEffect.AUAudioUnit as? AKLowShelfParametricEqualizerFilterAudioUnit
            AKManager.sharedInstance.engine.attachNode(self.output!)
            AKManager.sharedInstance.engine.connect(input.output!, to: self.output!, format: nil)
        }

        guard let tree = internalAU?.parameterTree else { return }

        cornerFrequencyParameter = tree.valueForKey("cornerFrequency") as? AUParameter
        gainParameter            = tree.valueForKey("gain")            as? AUParameter
        qParameter               = tree.valueForKey("q")               as? AUParameter

        token = tree.tokenByAddingParameterObserver {
            address, value in

            dispatch_async(dispatch_get_main_queue()) {
                if address == self.cornerFrequencyParameter!.address {
                    self.cornerFrequency = value
                }
                else if address == self.gainParameter!.address {
                    self.gain = value
                }
                else if address == self.qParameter!.address {
                    self.q = value
                }
            }
        }

    }
}
