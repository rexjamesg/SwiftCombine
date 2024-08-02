//
//  InteractionSubscription.swift
//  HTTPRequestCombine
//
//  Created by Yu Li Lin on 2022/11/28.
//

import Combine
import UIKit

// MARK: - UIControlSubscription

/// A custom subscription to capture UIControl target events.
final class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

// MARK: - UIControlPublisher

struct UIControlPublisher<Control: UIControl>: Publisher {
    typealias Output = Control
    typealias Failure = Never

    let control: Control
    let controlEvents: UIControl.Event

    init(control: Control, events: UIControl.Event) {
        self.control = control
        controlEvents = events
    }

    func receive<S>(subscriber: S) where S: Subscriber, S.Failure == UIControlPublisher.Failure, S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - CombineCompatible

protocol CombineCompatible {}

// MARK: - UIControl + CombineCompatible

extension UIControl: CombineCompatible {}
extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<UIControl> {
        return UIControlPublisher(control: self, events: events)
    }
}

// extension UIControl {
//    class InteractionSubscription<S: Subscriber>: Subscription where S.Input == Void {
//        // 1
//        private let subscriber: S?
//        private let control: UIControl
//        private let event: UIControl.Event
//
//        // 2
//        init(subscriber: S,
//             control: UIControl,
//             event: UIControl.Event) {
//
//            self.subscriber = subscriber
//            self.control = control
//            self.event = event
//            self.control.addTarget(self, action: #selector(handleEvent), for: event)
//        }
//
//        // 2
//        @objc func handleEvent(_ sender: UIControl) {
//            _ = self.subscriber?.receive(())
//        }
//
//        // 3
//        func request(_ demand: Subscribers.Demand) {
//
//        }
//
//        func cancel() {}
//    }
//
//    struct InteractionPublisher: Publisher {
//        // 2
//        typealias Output = Void
//        typealias Failure = Never
//
//        // 3
//        private let control: UIControl
//        private let event: UIControl.Event
//
//        init(control: UIControl, event: UIControl.Event) {
//            self.control = control
//            self.event = event
//        }
//
//        // 4
//        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
//            // 1
//            let subscription = InteractionSubscription(subscriber: subscriber,
//                                                       control: control,
//                                                       event: event)
//            subscriber.receive(subscription: subscription)
//        }
//    }
//
//    func publisher(for event: UIControl.Event) -> UIControl.InteractionPublisher {
//        return InteractionPublisher(control: self, event: event)
//    }
// }
