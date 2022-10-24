import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }

    @IBOutlet var textFiled: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet var iconImage: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?

    var checklistToEdit: Checklist?
    var iconName = "Folder"

    override func viewDidLoad() {
        super.viewDidLoad()

        if let checklist = checklistToEdit {
            title = "Checklist to edit"
            textFiled.text = checklist.name
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
        }
        iconImage.image = UIImage(named: iconName)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFiled.becomeFirstResponder()
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textFiled.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }

    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textFiled.text!
            checklist.iconName = iconName

            delegate?.listDetailViewController(self, didFinishAditing: checklist)
        } else {
            let checklist = Checklist(name: textFiled.text!, iconName: iconName)

            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
}
