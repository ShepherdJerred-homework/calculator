import UIKit


class ViewController: UIViewController {

    let model = CalculatorModel();
    
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func handleClear(_ sender: Any) {
        model.clear();
    }
    
    @IBAction func handleOperator(_ sender: Any) {
    }
    
    @IBAction func handleNumber(_ sender: Any) {
    }
}
