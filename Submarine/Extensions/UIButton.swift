
import UIKit

extension UIButton {
    func roundCorners(radius: CGFloat = 15) {
        self.layer.cornerRadius = radius
    }
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 50
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}

