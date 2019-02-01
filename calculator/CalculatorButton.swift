import UIKit

class CalculatorButton: UIButton {
    var color: UIColor?;
    var newColor: UIColor?;
    
    override open var isHighlighted: Bool {
        didSet {
            if let title = titleLabel {
                title.alpha = 1.0;
            }
            if isHighlighted {
                UIView.animate(withDuration: 0.4) {
                    self.backgroundColor = self.newColor;
                }
            } else {
                UIView.animate(withDuration: 0.4) {
                    self.backgroundColor = self.color;
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        color = self.backgroundColor;
        if color != nil {
            newColor = color?.modified(withAdditionalHue: 0.0, additionalSaturation: 0.0, additionalBrightness: 0.3);
        }
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.clipsToBounds = true;
        let ratioConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        self.addConstraints([ratioConstraint]);
        self.layer.cornerRadius = self.bounds.size.height * 0.5;
    }
}

// https://stackoverflow.com/questions/15428422/how-can-i-modify-a-uicolors-hue-brightness-and-saturation
extension UIColor {
    func modified(withAdditionalHue hue: CGFloat, additionalSaturation: CGFloat, additionalBrightness: CGFloat) -> UIColor {

        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha){
            return UIColor(hue: currentHue + hue,
                    saturation: currentSaturation + additionalSaturation,
                    brightness: currentBrigthness + additionalBrightness,
                    alpha: currentAlpha)
        } else {
            return self
        }
    }
}
