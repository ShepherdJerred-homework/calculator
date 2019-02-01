import UIKit

class ViewController: UIViewController {

    let model = Calculator();
    @IBOutlet weak var Display: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func updateDisplay() {
        print(model.state);
        let display = self.model.state.display;
        if display.isInt {
            self.Display.text = String(Int(display));
        } else {
            self.Display.text = String(display);
        }
    }

    @IBAction func handleEnter(_ sender: Any) {
        model.enterEqual();
        updateDisplay();
    }

    @IBAction func handlePoint(_ sender: Any) {
        model.enterPoint();
        updateDisplay();
    }

    @IBAction func handleClear(_ sender: Any) {
        model.clear();
        updateDisplay();
    }

    @IBAction func handleOperator(_ sender: UIButton) {
        if let label = sender.titleLabel {
            if let text = label.text {
                switch (text) {
                case "÷":
                    model.enterOperation(operation: .DIVIDE);
                case "×":
                    model.enterOperation(operation: .MULTIPLY);
                case "−":
                    model.enterOperation(operation: .SUBTRACT);
                case "+":
                    model.enterOperation(operation: .ADD);
                default:
                    return;
                }
                updateDisplay();

            }
        }
    }

    @IBAction func handleNumber(_ sender: UIButton) {
        if let label = sender.titleLabel {
            if let text = label.text {
                if let num = Int(text) {
                    model.enterDigit(digit: num);
                }
            }
        }
        updateDisplay();
    }
}
