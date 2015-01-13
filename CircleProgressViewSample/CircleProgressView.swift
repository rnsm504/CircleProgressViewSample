//
//  CircleProgressView.swift
//  CircleProgressView
//
//  Created by Kuze Masanori on 2014/12/27.
//  Copyright (c) 2014年 Kuze Masanori. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreGraphics

class CircleProgressLayer : CALayer {
    var progress : CGFloat = 0
    var lineWidth : CGFloat = 50
    var progressTintcolor : UIColor = UIColor(red: 0.39, green: 0.58, blue: 0.93, alpha: 1)
    var trackTintColor : UIColor = UIColor.grayColor()
    
    override init() {
        super.init()
    }
    
    override init(layer: AnyObject!) {
        if let layer = layer as? CircleProgressLayer {
            lineWidth = layer.lineWidth
            progressTintcolor = layer.progressTintcolor
            trackTintColor = layer.trackTintColor
        }
        super.init(layer: layer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func  needsDisplayForKey(key: String) -> Bool {
        if (key == "progress") {
            return true
        }
        return super.needsDisplayForKey(key)
    }
    
    
    override func drawInContext(ctx: CGContext!) {
        
        let rect : CGRect = self.bounds
        let centerPoint : CGPoint  = CGPointMake(rect.width/2, rect.height/2)
        let cx = centerPoint.x
        let cy = centerPoint.y
        let radius = min(rect.width, rect.height)/2
        
        let track : CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(track, nil, cx, cy, radius-(lineWidth/2), CGFloat(0), CGFloat(M_PI*2), false)
        CGContextSetStrokeColorWithColor(ctx, trackTintColor.CGColor)
        CGContextSetLineWidth(ctx, lineWidth)
        CGContextAddPath(ctx, track)
        
        if(lineWidth == 0){
            CGContextSetFillColorWithColor(ctx, trackTintColor.CGColor)
            CGContextDrawPath(ctx, kCGPathFill)
        } else {
            CGContextDrawPath(ctx, kCGPathStroke)
        }
        
        if(self.progress > 0){
            var s : Double = Double(self.progress)
            
            let startAngle : CGFloat = CGFloat(0*(M_PI/180)-(M_PI/2))
            let endAngle : CGFloat = CGFloat((s * 360 * (M_PI/180))-(M_PI/2))
            
            
            let path : CGMutablePathRef = CGPathCreateMutable()
            CGContextSetStrokeColorWithColor(ctx, progressTintcolor.CGColor)
            CGContextSetLineWidth(ctx, lineWidth)
            
            if(lineWidth == 0){
                CGPathMoveToPoint(path, nil, cx, cy)
                CGPathAddArc(path, nil, cx, cy, radius-(lineWidth/2), startAngle, endAngle, false)
                CGContextAddPath(ctx, path)
                CGContextSetFillColorWithColor(ctx, progressTintcolor.CGColor)
                CGContextDrawPath(ctx, kCGPathFill)
            } else {
                CGPathAddArc(path, nil, cx, cy, radius-(lineWidth/2), startAngle, endAngle, false)
                CGContextAddPath(ctx, path)
                CGContextDrawPath(ctx, kCGPathStroke)
                
            }
        }
    }
    
    
}


class CircleProgressView : UIView {
    
    private var canvas : UIImage? = nil
    private var _progress : CGFloat = 0
    private var _animate : Bool = false
    private var _trackTintColor = UIColor.grayColor()
    private var _progressTintcolor = UIColor(red: 0.39, green: 0.58, blue: 0.93, alpha: 1)
    private var _lineWidth : CGFloat = 50
    
    private var _layer : CircleProgressLayer{
        get {
            return self.layer as CircleProgressLayer
        }
    }
    
    var progress : CGFloat  {
        get {
            return _progress
        }
        set {
            setProgress(newValue, animated: false);
        }
    }
    
    //参照Only
    var animate : Bool{
        get {
            return _animate
        }
    }
    
    var trackTintColor : UIColor{
        get {
            return _trackTintColor
        }
        set {
            _trackTintColor = newValue
            _layer.trackTintColor = _trackTintColor
            _layer.setNeedsDisplay()
        }
    }
    
    var progressTintcolor : UIColor {
        get {
            return _progressTintcolor
        }
        set {
            _progressTintcolor = newValue
            _layer.progressTintcolor = _progressTintcolor
            _layer.setNeedsDisplay()
        }
    }
    
    var lineWidth : CGFloat {
        get {
            return _lineWidth
        }
        set {
            _lineWidth = newValue
            _layer.lineWidth = _lineWidth
            _layer.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        
    }
    
    override func didMoveToSuperview() {
        
        _layer.setNeedsDisplay()
    }
    
    override class func layerClass() -> AnyClass {
        return CircleProgressLayer.self
    }
    
    //進捗
    func setProgress(newValue : CGFloat, animated: Bool) {
        //アニメーション実行中は無効
        if(animate){
            return
        }
        
        var oldProgress = _progress
        _progress = newValue
        
        if(_progress > 0){
            
            if(_progress > 1){
                _progress = 1
            }
            if(oldProgress >= 1){
                oldProgress = 0
            }
            let startAngle : CGFloat = oldProgress*CGFloat(M_PI/180)-CGFloat(M_PI/2)
            let endAngle : CGFloat = (_progress * 360 * CGFloat(M_PI/180))-CGFloat(M_PI/2)
            drawChart(oldProgress, startAngle:startAngle, endAngle: endAngle ,animated: animated)
        } else {
            //初期化
            
        }
    }
    
    func drawChart(oldProgress:CGFloat, startAngle: CGFloat, endAngle: CGFloat, animated:Bool){
        
        //アニメーション
        if(animated){
            _animate = animated
            
            let duration = Double(_progress-oldProgress)*3
            let animateStrokeEnd = CABasicAnimation(keyPath: "progress")
            animateStrokeEnd.duration = duration
            animateStrokeEnd.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animateStrokeEnd.repeatCount = 1.0
            animateStrokeEnd.fromValue = NSNumber(float: Float(oldProgress))
            animateStrokeEnd.toValue = NSNumber(float: Float(_progress))
            //animateStrokeEnd.removedOnCompletion = false
            animateStrokeEnd.fillMode = kCAFillModeForwards
            animateStrokeEnd.beginTime = CACurrentMediaTime()
            animateStrokeEnd.delegate = self
            
            _layer.addAnimation(animateStrokeEnd, forKey: "progress")
            
        } else {
            _layer.progress = _progress
            _layer.setNeedsDisplay()
        }
    }
    
    
    override func animationDidStart(anim: CAAnimation!) {
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        _animate = false
        let pinnedProgress : CGFloat = anim.valueForKey("toValue") as CGFloat
        _layer.progress = pinnedProgress
        
    }
    
}