import UIKit

protocol AddItemViewControllerDelegate: AnyObject {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)

    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    weak var delegate: AddItemViewControllerDelegate?
    
    //MARK: Overrided methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    //MARK: @IBActions methods
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }

    @IBAction func done() {
        let item = ChecklistItem()
        item.text = textField.text!

        delegate?.addItemViewController(self, didFinishAdding: item)
    }

    //MARK: Instance methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)

        doneBarButton.isEnabled = !newText.isEmpty

        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }

}
