//
//  UIView+WSBoom.swift
//
//
//  Created by yuhanle on 15/10/1.
//  Copyright (c) 2015年 yuhanle. All rights reserved.
//

import UIKit
extension UIView{
    
    private struct AssociatedKeys {
        static var BoomCellsName = "WSBoomCells"
        static var ScaleSnapshotName = "WSBoomScaleSnapshot"
    }
    //MARK: - 私有方法
    private var boomCells:[CALayer]?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.BoomCellsName) as? [CALayer]
        }
        set{
            if let newValue = newValue{
                willChangeValueForKey(AssociatedKeys.BoomCellsName)
                objc_setAssociatedObject(self, &AssociatedKeys.BoomCellsName, newValue as [CALayer], .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                didChangeValueForKey(AssociatedKeys.BoomCellsName)
            }
        }
    }
    //截图
    private var scaleSnapshot:UIImage?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.ScaleSnapshotName) as? UIImage
        }
        set{
            if let newValue = newValue{
                willChangeValueForKey(AssociatedKeys.ScaleSnapshotName)
                objc_setAssociatedObject(self, &AssociatedKeys.ScaleSnapshotName, newValue as UIImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                didChangeValueForKey(AssociatedKeys.ScaleSnapshotName)
            }
        }
    }
    
    //view的缩放和透明度动画
    @objc private func scaleOpacityAnimations(){
        //缩放
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 0.01
        scaleAnimation.duration = 0.15
        scaleAnimation.fillMode = kCAFillModeForwards
        
        //透明度
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.15
        opacityAnimation.fillMode = kCAFillModeForwards
        
        layer.addAnimation(scaleAnimation, forKey: "lscale")
        layer.addAnimation(opacityAnimation, forKey: "lopacity")
        layer.opacity = 0
    }
    
    //粒子动画
    @objc private func cellAnimations(){
        for shape in boomCells!{
            shape.position = center
            shape.opacity = 1
            //路径
            let moveAnimation = CAKeyframeAnimation(keyPath: "position")
            moveAnimation.path = makeRandomPath(shape).CGPath
            moveAnimation.removedOnCompletion = false
            moveAnimation.fillMode = kCAFillModeForwards
            moveAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.240000, 0.590000, 0.506667, 0.026667)
            moveAnimation.duration = NSTimeInterval(random()%10) * 0.05 + 0.3
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.toValue = makeScaleValue()
            scaleAnimation.duration = moveAnimation.duration
            scaleAnimation.removedOnCompletion = false
            scaleAnimation.fillMode = kCAFillModeForwards
            
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = moveAnimation.duration
            opacityAnimation.delegate = false
            opacityAnimation.removedOnCompletion = true
            opacityAnimation.fillMode = kCAFillModeForwards
            opacityAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.380000, 0.033333, 0.963333, 0.260000)
            
            shape.opacity = 0
            shape.addAnimation(scaleAnimation, forKey: "scaleAnimation")
            shape.addAnimation(moveAnimation, forKey: "moveAnimation")
            shape.addAnimation(opacityAnimation, forKey: "opacityAnimation")
        }
    }
    
    //随机产生震动值
    private func makeShakeValue(p:CGFloat) -> CGFloat{
        let basicOrigin = -CGFloat(10)
        let maxOffset = -2 * basicOrigin
        return basicOrigin + maxOffset * (CGFloat(random()%101)/CGFloat(100)) + p
    }
    
    //随机产生缩放数值
    private func makeScaleValue() -> CGFloat{
        return 1 - 0.7 * (CGFloat(random()%101 - 50)/CGFloat(50))
    }
    
    //随机产生粒子路径
    private func makeRandomPath(aLayer:CALayer) -> UIBezierPath{
        let particlePath = UIBezierPath()
        particlePath.moveToPoint(layer.position)
        let basicLeft = -CGFloat(1.3 * layer.frame.size.width)
        let maxOffset = 2 * abs(basicLeft)
        let randomNumber = random()%101
        let endPointX = basicLeft + maxOffset * (CGFloat(randomNumber)/CGFloat(100)) + aLayer.position.x
        let controlPointOffSetX = (endPointX - aLayer.position.x)/2  + aLayer.position.x
        let controlPointOffSetY = layer.position.y - 0.2 * layer.frame.size.height - CGFloat(random()%Int(1.2 * layer.frame.size.height))
        let endPointY = layer.position.y + layer.frame.size.height/2 + CGFloat(random()%Int(layer.frame.size.height/2))
        particlePath.addQuadCurveToPoint(CGPointMake(endPointX, endPointY), controlPoint: CGPointMake(controlPointOffSetX, controlPointOffSetY))
        return particlePath
    }
    
    private func colorWithPoint(x:Int,y:Int,image:UIImage) -> UIColor{
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(image.size.width) * y) + x) * 4
        
        let a = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let r = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    //移除粒子
    private func removeBoomCells(){
        if boomCells == nil {
            return
        }
        for item in boomCells!{
            item.removeFromSuperlayer()
        }
        boomCells?.removeAll(keepCapacity: false)
        boomCells = nil
    }
    
    //MARK: - 公开方法
    //从layer获取View的截图
    func snapshot() -> UIImage{
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func boom(){
        //摇摆~ 摇摆~ 震动~ 震动~
        let shakeXAnimation = CAKeyframeAnimation(keyPath: "position.x")
        shakeXAnimation.duration = 0.2
        shakeXAnimation.values = [makeShakeValue(layer.position.x),makeShakeValue(layer.position.x),makeShakeValue(layer.position.x),makeShakeValue(layer.position.x),makeShakeValue(layer.position.x)]
        let shakeYAnimation = CAKeyframeAnimation(keyPath: "position.y")
        shakeYAnimation.duration = shakeXAnimation.duration
        shakeYAnimation.values = [makeShakeValue(layer.position.y),makeShakeValue(layer.position.y),makeShakeValue(layer.position.y),makeShakeValue(layer.position.y),makeShakeValue(layer.position.y)]
        
        
        layer.addAnimation(shakeXAnimation, forKey: "shakeXAnimation")
        layer.addAnimation(shakeYAnimation, forKey: "shakeYAnimation")
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "scaleOpacityAnimations", userInfo: nil, repeats: false)
        
        if boomCells == nil{
            boomCells = [CALayer]()
            for i in 0...16{
                for j in 0...16{
                    if scaleSnapshot == nil{
                        scaleSnapshot = snapshot().scaleImageToSize(CGSizeMake(34, 34))
                    }
                    let pWidth = min(frame.size.width,frame.size.height)/17
                    let color = scaleSnapshot!.getPixelColorAtLocation(CGPointMake(CGFloat(i * 2), CGFloat(j * 2)))
                    let shape = CALayer()
                    shape.backgroundColor = color.CGColor
                    shape.opacity = 0
                    shape.cornerRadius = pWidth/2
                    shape.frame = CGRectMake(CGFloat(i) * pWidth, CGFloat(j) * pWidth, pWidth, pWidth)
                    layer.superlayer?.addSublayer(shape)
                    boomCells?.append(shape)
                }
            }
        }
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: "cellAnimations", userInfo: nil, repeats: false)
    }
    
    //重置状态
    func reset(){
        layer.opacity = 1
    }
    
    //MARK: - 生命周期相关，在从父View移除的时候释放粒子
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            let originalSelector = Selector("willMoveToSuperview:")
            let swizzledSelector = Selector("WS_willMoveToSuperview:")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }
    
    func WS_willMoveToSuperview(newSuperView:UIView){
        removeBoomCells()
        WS_willMoveToSuperview(newSuperView)
    }
    
    
}
extension UIImage{
    
    private struct AssociatedKeys {
        static var aRGBBitmapContextName = "aRGBBitmapContext"
    }
    
    private var aRGBBitmapContext:CGContextRef?{
        get{
            return (objc_getAssociatedObject(self, &AssociatedKeys.aRGBBitmapContextName) as! CGContextRef?)
        }
        set{
            if let newValue = newValue{
                willChangeValueForKey(AssociatedKeys.aRGBBitmapContextName)
                objc_setAssociatedObject(self, &AssociatedKeys.aRGBBitmapContextName, newValue as CGContextRef, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                didChangeValueForKey(AssociatedKeys.aRGBBitmapContextName)
            }
        }
    }
    
    func createARGBBitmapContextFromImage() -> CGContextRef{
        if aRGBBitmapContext != nil{
            return aRGBBitmapContext!
        }else{
            let pixelsWidth = CGImageGetWidth(self.CGImage)
            let pixelsHeitht = CGImageGetHeight(self.CGImage)
            let bitmapBytesPerRow = pixelsWidth * 4
            let bitmapByteCount = bitmapBytesPerRow * pixelsHeitht
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapData = UnsafeMutablePointer<Void>.alloc(bitmapByteCount)
            let context = CGBitmapContextCreate(bitmapData,pixelsWidth,pixelsHeitht,8,bitmapBytesPerRow,colorSpace!, CGBitmapInfo.ByteOrderDefault.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue)!
            aRGBBitmapContext = context
            return context
        }
    }
    
    func getPixelColorAtLocation(point:CGPoint) -> UIColor{
        let inImage = self.CGImage
        let cgctx = createARGBBitmapContextFromImage()
        let w = CGFloat(CGImageGetWidth(inImage))
        let h = CGFloat(CGImageGetHeight(inImage))
        let rect = CGRectMake(0, 0, w, h)
        CGContextDrawImage(cgctx, rect, inImage)
        let resData = UnsafePointer<UInt8>(CGBitmapContextGetData(cgctx))
        let pixelInfo: Int = 4*((Int(w*round(point.y)))+Int(round(point.x)))
        
        let a = CGFloat(resData[pixelInfo]) / CGFloat(255.0)
        let r = CGFloat(resData[pixelInfo+1]) / CGFloat(255.0)
        let g = CGFloat(resData[pixelInfo+2]) / CGFloat(255.0)
        let b = CGFloat(resData[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    //缩放图片
    func scaleImageToSize(size:CGSize) -> UIImage{
        UIGraphicsBeginImageContext(size)
        drawInRect(CGRectMake(0, 0, size.width, size.height))
        let res = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return res
    }
    
}
