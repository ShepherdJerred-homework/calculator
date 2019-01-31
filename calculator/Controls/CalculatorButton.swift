import UIKit

class CalculatorButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.clipsToBounds = true;
        let ratioConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        self.addConstraints([ratioConstraint]);
        self.layer.cornerRadius = self.bounds.size.height * 0.5;
    }
}
