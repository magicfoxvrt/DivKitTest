import UIKit
import DivKit
import Serialization
import LayoutKit

final class DivHostViewController: UIViewController {
    private var divHostView = DivContaineer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divHostView
        addContainer()
        previewData()
    }
    
    func addContainer() {
        view.addSubview(divHostView)
        view.backgroundColor = .red
        divHostView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divHostView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divHostView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divHostView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -16),
            divHostView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func previewData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            do {
                var (cards, templates) = try DivJson1.loadCards()
                var divData = DivData.resolve(card: cards, templates: templates)
                self.divHostView.updateWith(data: divData.value)
            } catch {
                print("Error")
            }
        }
    }
}
