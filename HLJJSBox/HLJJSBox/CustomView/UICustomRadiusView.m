//
//  UICustomRadiusView.m
//  UICustomRadiusView
//
//  Created by Ye Keyon on 2020/2/26.
//  Copyright © 2020 Ye Keyon. All rights reserved.
//

#import "UICustomRadiusView.h"

typedef struct {
     CGFloat topLeft;
     CGFloat topRight;
     CGFloat bottomLeft;
     CGFloat bottomRight;
} CornerRadii;

@implementation UICustomRadiusView

CornerRadii CornerRadiiMake(CGFloat topLeft,CGFloat topRight,CGFloat bottomLeft,CGFloat bottomRight){
     return (CornerRadii){
          topLeft,
          topRight,
          bottomLeft,
          bottomRight,
     };
}

//切圆角函数
CGPathRef CYPathCreateWithRoundedRect(CGRect bounds,
                                      CornerRadii cornerRadii)
{
     const CGFloat minX = CGRectGetMinX(bounds);
     const CGFloat minY = CGRectGetMinY(bounds);
     const CGFloat maxX = CGRectGetMaxX(bounds);
     const CGFloat maxY = CGRectGetMaxY(bounds);
     
     const CGFloat topLeftCenterX = minX +  cornerRadii.topLeft;
     const CGFloat topLeftCenterY = minY + cornerRadii.topLeft;
     
     const CGFloat topRightCenterX = maxX - cornerRadii.topRight;
     const CGFloat topRightCenterY = minY + cornerRadii.topRight;
     
     const CGFloat bottomLeftCenterX = minX +  cornerRadii.bottomLeft;
     const CGFloat bottomLeftCenterY = maxY - cornerRadii.bottomLeft;
     
     const CGFloat bottomRightCenterX = maxX -  cornerRadii.bottomRight;
     const CGFloat bottomRightCenterY = maxY - cornerRadii.bottomRight;
     /*
      path : 路径
      m : 变换
      x  y : 画圆的圆心点
      radius : 圆的半径
      startAngle : 起始角度
      endAngle ： 结束角度
      clockwise : 是否是顺时针
      void CGPathAddArc(CGMutablePathRef cg_nullable path,
      const CGAffineTransform * __nullable m,
      CGFloat x, CGFloat y, CGFloat radius, CGFloat startAngle, CGFloat endAngle,
      bool clockwise)
      */
     //虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
     
     CGMutablePathRef path = CGPathCreateMutable();
     //顶 左
     CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY,cornerRadii.topLeft, M_PI, 3 * M_PI_2, NO);
     //顶 右
     CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, cornerRadii.topRight, 3 * M_PI_2, 0, NO);
     //底 右
     CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, cornerRadii.bottomRight,0, M_PI_2, NO);
     //底 左
     CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, cornerRadii.bottomLeft, M_PI_2,M_PI, NO);
     CGPathCloseSubpath(path);
     return path;
}

- (void)setBorderRadius:(CGFloat)borderRadius
{
    _borderRadius = borderRadius;
    self.borderTopLeftRadius = borderRadius;
    self.borderTopRightRadius = borderRadius;
    self.borderBottomLeftRadius = borderRadius;
    self.borderBottomRightRadius = borderRadius;
}

- (void)drawRect:(CGRect)rect {
    //切圆角
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CornerRadii cornerRadii = CornerRadiiMake(self.borderTopLeftRadius, self.borderTopRightRadius, self.borderBottomLeftRadius, self.borderBottomRightRadius);
    CGPathRef path = CYPathCreateWithRoundedRect(self.bounds,cornerRadii);
    shapeLayer.path = path;
    CGPathRelease(path);
    self.layer.mask = shapeLayer;
}

@end
