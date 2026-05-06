import UIKit

class CustomButton: UIButton {
    
    // MARK: - Properties
    var action: (() -> Void)?
    
    // MARK: - Init
    init(title: String, titleColor: UIColor = .white, backgroundColor: UIColor = .systemBlue, action: (() -> Void)? = nil) {
        super.init(frame: .zero)
        
        self.action = action
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        
        layer.cornerRadius = 10
        clipsToBounds = true
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        translatesAutoresizingMaskIntoConstraints = false
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        action?()
    }
}
