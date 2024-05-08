//
//  SwiftUIView.swift
//
//
//  Created by Jo on 2022/9/5.
//

import SwiftUI

#if os(macOS)
/// 将view中重写的方法通过协议的方式传递到 Coordinator 中
private protocol _TrackableViewProtocol: NSObjectProtocol {
    func trackingView(_ trackingView: _TrackableNSView, mouseDownWith event: NSEvent)
    func trackingView(_ trackingView: _TrackableNSView, rightMouseDownWith event: NSEvent)
    func trackingView(_ trackingView: _TrackableNSView, mouseUpWith event: NSEvent)
    func trackingView(_ trackingView: _TrackableNSView, rightMouseUpWith event: NSEvent)
    func trackingView(_ trackingView: _TrackableNSView, mouseMovedWith event: NSEvent)
    func trackingView(_ trackingView: _TrackableNSView, mouseDraggedWith event: NSEvent)
    func trackingView(_ trackingView: _TrackableNSView, mouseEnteredWith event: NSEvent)
    func trackingView(_ trackingView: _TrackableNSView, mouseExitedWith event: NSEvent)
}

/// 包装的用来获取鼠标事件的视图类
private class _TrackableNSView: NSView {
    /// 是否需要翻转坐标系
    private var flippedValue: Bool = true
    /// 鼠标跟踪区域
    private var trackingArea: NSTrackingArea?
    /// 鼠标跟踪类型
    private var trackingOptions: NSTrackingArea.Options = [.activeAlways, .mouseMoved, .mouseEnteredAndExited]
    /// 代理
    weak var delegate: _TrackableViewProtocol?

    /// 初始化方法
    /// - Parameters:
    ///   - delegate: 代理
    ///   - flipped: 是否翻转坐标系
    init(delegate: _TrackableViewProtocol?, flipped: Bool = true) {
        super.init(frame: NSMakeRect(0, 0, 300, 200))

        self.delegate = delegate
        flippedValue = flipped
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        if let trackingArea = trackingArea {
            removeTrackingArea(trackingArea)
        }

        addTrackingArea(NSTrackingArea(rect: bounds, options: trackingOptions, owner: self, userInfo: nil))
    }

    override var isFlipped: Bool {
        return self.flippedValue
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        delegate?.trackingView(self, mouseDownWith: event)
    }

    override func rightMouseDown(with event: NSEvent) {
        super.rightMouseDown(with: event)
        delegate?.trackingView(self, rightMouseDownWith: event)
    }

    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        delegate?.trackingView(self, mouseUpWith: event)
    }

    override func rightMouseUp(with event: NSEvent) {
        super.rightMouseUp(with: event)
        delegate?.trackingView(self, rightMouseUpWith: event)
    }

    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        delegate?.trackingView(self, mouseMovedWith: event)
    }

    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        delegate?.trackingView(self, mouseDraggedWith: event)
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        delegate?.trackingView(self, mouseEnteredWith: event)
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        delegate?.trackingView(self, mouseExitedWith: event)
    }
}

private struct _TrackingHolder {
    var onMouseDownAction: ((NSEvent, CGRect, CGPoint) -> Void)?
    var onRightMouseDownAction: ((NSEvent, CGRect, CGPoint) -> Void)?
    var onMouseUpAction: ((NSEvent, CGRect, CGPoint) -> Void)?
    var onRightMouseUpAction: ((NSEvent, CGRect, CGPoint) -> Void)?
    var onMouseMovedAction: ((NSEvent, CGRect, CGPoint) -> Void)?
    var onMouseDraggedAction: ((NSEvent, CGRect, CGPoint) -> Void)?
    var onMouseEnteredAction: ((NSEvent, CGRect, CGPoint) -> Void)?
    var onMouseExitedAction: ((NSEvent, CGRect, CGPoint) -> Void)?

    var mouseDownPointBinder: OptionalBinder<CGPoint>?
    var rightMouseDownPointBinder: OptionalBinder<CGPoint>?
    var mouseUpPointBinder: OptionalBinder<CGPoint>?
    var rightMouseUpPointBinder: OptionalBinder<CGPoint>?
    var mouseMovedPointBinder: OptionalBinder<CGPoint>?
    var mouseDraggedPointBinder: OptionalBinder<CGPoint>?
    var mouseEnteredBinder: OptionalBinder<Bool>?
    var mouseExitedBinder: OptionalBinder<Bool>?
}

/// 用来追踪鼠标事件的视图，需要注意的是，尽量不要过度的包装，否则会造成视图层级过多
public struct TrackableView: NSViewRepresentable {
    public typealias NSViewType = NSView

    private var flipped: Bool = true
    private var trackingOptions: NSTrackingArea.Options = [.activeAlways, .mouseMoved, .mouseEnteredAndExited]

    private var trackingHolder = _TrackingHolder()
    
    public class Coordinator: NSObject, _TrackableViewProtocol {
        fileprivate var trackingHolder = _TrackingHolder()
        
        fileprivate func trackingView(_ trackingView: _TrackableNSView, mouseDownWith event: NSEvent) {
            _callback(trackingView, event: event, action: trackingHolder.onMouseDownAction)
            trackingHolder.mouseDownPointBinder?.value = _pointOf(trackingView, event: event)
        }

        fileprivate func trackingView(_ trackingView: _TrackableNSView, rightMouseDownWith event: NSEvent) {
            _callback(trackingView, event: event, action: trackingHolder.onRightMouseDownAction)
            trackingHolder.rightMouseDownPointBinder?.value = _pointOf(trackingView, event: event)
        }

        fileprivate func trackingView(_ trackingView: _TrackableNSView, mouseUpWith event: NSEvent) {
            _callback(trackingView, event: event, action: trackingHolder.onMouseUpAction)
            trackingHolder.mouseUpPointBinder?.value = _pointOf(trackingView, event: event)
        }

        fileprivate func trackingView(_ trackingView: _TrackableNSView, rightMouseUpWith event: NSEvent) {
            _callback(trackingView, event: event, action: trackingHolder.onRightMouseUpAction)
            trackingHolder.rightMouseUpPointBinder?.value = _pointOf(trackingView, event: event)
        }

        fileprivate func trackingView(_ trackingView: _TrackableNSView, mouseMovedWith event: NSEvent) {
            _callback(trackingView, event: event, action: trackingHolder.onMouseMovedAction)
            trackingHolder.mouseMovedPointBinder?.value = _pointOf(trackingView, event: event)
        }

        fileprivate func trackingView(_ trackingView: _TrackableNSView, mouseDraggedWith event: NSEvent) {
            _callback(trackingView, event: event, action: trackingHolder.onMouseDraggedAction)
            trackingHolder.mouseDraggedPointBinder?.value = _pointOf(trackingView, event: event)
        }

        fileprivate func trackingView(_ trackingView: _TrackableNSView, mouseEnteredWith event: NSEvent) {
            _callback(trackingView, event: event, action: trackingHolder.onMouseEnteredAction)
            trackingHolder.mouseEnteredBinder?.value = true
            trackingHolder.mouseExitedBinder?.value = false
        }

        fileprivate func trackingView(_ trackingView: _TrackableNSView, mouseExitedWith event: NSEvent) {
            _callback(trackingView, event: event, action: trackingHolder.onMouseExitedAction)
            trackingHolder.mouseExitedBinder?.value = true
            trackingHolder.mouseEnteredBinder?.value = false
        }

        private func _pointOf(_ trackingView: _TrackableNSView, event: NSEvent) -> CGPoint {
            trackingView.convert(event.locationInWindow, from: nil)
        }

        private func _callback(_ trackingView: _TrackableNSView, event: NSEvent, action: ((NSEvent, CGRect, CGPoint) -> Void)?) {
            guard let action = action else { return }

            let trackingPoint = _pointOf(trackingView, event: event)
            let targetPoint = CGPoint(x: min(max(0, trackingPoint.x), trackingView.frame.width),
                                      y: min(max(0, trackingPoint.y), trackingView.frame.height))
            action(event, trackingView.frame, targetPoint)
        }
    }

    public init(flipped: Bool = true, trackingOptions: NSTrackingArea.Options = [.activeAlways, .mouseMoved, .mouseEnteredAndExited]) {
        self.flipped = flipped
        self.trackingOptions = trackingOptions
    }

    public func makeNSView(context: Context) -> NSView {
        _TrackableNSView(delegate: context.coordinator, flipped: flipped)
    }

    public func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            context.coordinator.trackingHolder = trackingHolder
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}

public extension TrackableView {
    func on(
        mouseDown: ((NSEvent, CGRect, CGPoint) -> Void)? = nil,
        rightMouseDown: ((NSEvent, CGRect, CGPoint) -> Void)? = nil,
        mouseUp: ((NSEvent, CGRect, CGPoint) -> Void)? = nil,
        rightMouseUp: ((NSEvent, CGRect, CGPoint) -> Void)? = nil,
        mouseMoved: ((NSEvent, CGRect, CGPoint) -> Void)? = nil,
        mouseDragged: ((NSEvent, CGRect, CGPoint) -> Void)? = nil,
        mouseEntered: ((NSEvent, CGRect, CGPoint) -> Void)? = nil,
        mouseExited: ((NSEvent, CGRect, CGPoint) -> Void)? = nil
    ) -> Self {
        returnMutableSelf {
            var trackingHolder = trackingHolder
            
            if let mouseDown = mouseDown {
                trackingHolder.onMouseDownAction = mouseDown
            }
            
            if let rightMouseDown = rightMouseDown {
                trackingHolder.onRightMouseDownAction = rightMouseDown
            }
            
            if let mouseUp = mouseUp {
                trackingHolder.onMouseUpAction = mouseUp
            }
            
            if let rightMouseUp = rightMouseUp {
                trackingHolder.onRightMouseUpAction = rightMouseUp
            }
            
            if let mouseMoved = mouseMoved {
                trackingHolder.onMouseMovedAction = mouseMoved
            }
            
            if let mouseDragged = mouseDragged {
                trackingHolder.onMouseDraggedAction = mouseDragged
            }
            
            if let mouseEntered = mouseEntered {
                trackingHolder.onMouseEnteredAction = mouseEntered
            }
            
            if let mouseExited = mouseExited {
                trackingHolder.onMouseExitedAction = mouseExited
            }
            
            
            $0.trackingHolder = trackingHolder
        }
    }

    func tracking(
        mouseDownPoint: Binding<CGPoint>? = nil,
        rightMouseDownPoint: Binding<CGPoint>? = nil,
        mouseUpPoint: Binding<CGPoint>? = nil,
        rightMouseUpPoint: Binding<CGPoint>? = nil,
        mouseMovedPoint: Binding<CGPoint>? = nil,
        mouseDraggedPoint: Binding<CGPoint>? = nil,
        mouseEntered: Binding<Bool>? = nil,
        mouseExited: Binding<Bool>? = nil
    ) -> Self {
        returnMutableSelf {
            var trackingHolder = trackingHolder
            
            if let mouseDownPoint = mouseDownPoint {
                trackingHolder.mouseDownPointBinder = OptionalBinder(mouseDownPoint)
            }
            
            if let rightMouseDownPoint = rightMouseDownPoint {
                trackingHolder.rightMouseDownPointBinder = OptionalBinder(rightMouseDownPoint)
            }
            
            if let mouseUpPoint = mouseUpPoint {
                trackingHolder.mouseUpPointBinder = OptionalBinder(mouseUpPoint)
            }
            
            if let rightMouseUpPoint = rightMouseUpPoint {
                trackingHolder.rightMouseUpPointBinder = OptionalBinder(rightMouseUpPoint)
            }
            
            if let mouseMovedPoint = mouseMovedPoint {
                trackingHolder.mouseMovedPointBinder = OptionalBinder(mouseMovedPoint)
            }
            
            if let mouseDraggedPoint = mouseDraggedPoint {
                trackingHolder.mouseDraggedPointBinder = OptionalBinder(mouseDraggedPoint)
            }
            
            if let mouseEntered = mouseEntered {
                trackingHolder.mouseEnteredBinder = OptionalBinder(mouseEntered)
            }
            
            if let mouseExited = mouseExited {
                trackingHolder.mouseExitedBinder = OptionalBinder(mouseExited)
            }
            
            $0.trackingHolder = trackingHolder
        }
    }
}

#endif
