//
//     /||\
//    / || \
//   /  )(  \
//  /__/  \__\
//

import UIKit
import QuickLook

// MARK: - Label

@IBDesignable class StyledLabel: CustomLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    private func setupLabel() {
        textColor = .primaryText
        fontName = Keys.Font.body
    }
    
}


// MARK: - Text field

@IBDesignable class StyledTextField: CustomTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        textColor = .primaryText
        tintColor = .primaryAction
        fontName = Keys.Font.body
        borderColor = .borderStroke
        borderWidth = 1
        cornerRadius = 4
    }
    
}


// MARK: - Text view

@IBDesignable class StyledTextView: CustomTextView {
    
    override func setupViews() {
        super.setupViews()
        textColor = .primaryText
        tintColor = .primaryAction
        fontName = Keys.Font.body
    }
    
}

@IBDesignable class StyledLabelTextView: CustomLabelTextView {
    
    override func setupViews() {
        super.setupViews()
        textColor = .primaryText
        tintColor = .primaryAction
        fontName = Keys.Font.body
    }
    
}


// MARK: - Button

@IBDesignable class StyledButton: CustomButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        setTitleColor(.primaryAction, for: .normal)
        fontName = Keys.Font.button
        cornerRadius = 4
    }
    
}

@IBDesignable class StyledFillingButton: CustomButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        setTitleColor(.primaryAction, for: .normal)
        fontName = Keys.Font.button
        cornerRadius = 4
        borderWidth = 1
        titleColorName = Keys.Color.lightText
        disabledTitleColorName = Keys.Color.primaryActionLight
        backgroundColorName = Keys.Color.primaryAction
        disabledBackgroundColorName = Keys.Color.lightBackground
        borderColorName = Keys.Color.primaryAction
        disabledBorderColorName = Keys.Color.primaryActionLight
    }
    
}

@IBDesignable class StyledOutlineButton: CustomButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        setTitleColor(.primaryAction, for: .normal)
        fontName = Keys.Font.button
        cornerRadius = 4
        borderWidth = 1
        titleColorName = Keys.Color.primaryAction
        disabledTitleColorName = Keys.Color.primaryActionLight
        backgroundColorName = Keys.Color.lightBackground
        disabledBackgroundColorName = Keys.Color.lightBackground
        borderColorName = Keys.Color.primaryAction
        disabledBorderColorName = Keys.Color.primaryActionLight
    }
    
}

// MARK: - ImageView

@IBDesignable class StyledImageView: CustomImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
        setupViews()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        tintColorName = Keys.Color.icon
    }
    
}


// MARK: - View

@IBDesignable class StyledView: CustomView { }


//// MARK: - Avatar
//
//@IBDesignable class StyledAvatar: AvatarView, BackgroundColorNameable, BorderColorNameable {
//
//    @IBInspectable var textColorName: String? {
//        didSet {
//            guard let color = UIColor(named: textColorName) else { return }
//            textColor = color
//        }
//    }
//
//    @IBInspectable var backgroundColorName: String? {
//        didSet {
//            guard let color = UIColor(named: backgroundColorName) else { return }
//            innerColor = color
//        }
//    }
//
//    @IBInspectable var borderColorName: String? {
//        didSet {
//            applyBorderColorName()
//        }
//    }
//
//    init() {
//        super.init(frame: .zero)
//        setupViews()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupViews()
//    }
//
//    fileprivate func setupViews() {
//        fontName = "ProximaNova-Light"
//        textColor = .primaryText
//        innerColor = .avatarBackground
//    }
//
//}
//
//
//// MARK: - Avatar header
//
//@IBDesignable class StyledAvatarHeader: AvatarHeader, BackgroundColorNameable {
//
//    @IBInspectable var textColorName: String? {
//        didSet {
//            guard let color = UIColor(named: textColorName) else { return }
//            avatar.textColor = color
//            textColor = color
//        }
//    }
//
//    @IBInspectable var backgroundColorName: String? {
//        didSet {
//            guard let color = UIColor(named: backgroundColorName) else { return }
//            backgroundColor = color
//        }
//    }
//
//    @IBInspectable var avatarBackgroundColorName: String? {
//        didSet {
//            guard let color = UIColor(named: avatarBackgroundColorName) else { return }
//            avatar.innerColor = color
//        }
//    }
//
//    @IBInspectable var borderColorName: String? {
//        didSet {
//            guard let color = UIColor(named: borderColorName) else { return }
//            borderColor = color
//        }
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupViews()
//    }
//
//    fileprivate func setupViews() {
//        avatarFontName = "ProximaNova-Regular"
//        fontName = "ProximaNova-Regular"
//        textColor = .primaryText
//        avatar.textColor = .primaryText
//        avatar.innerColor = .borderStroke
//        borderColor = .borderStroke
//        backgroundColor = .backgroundFill
//    }
//
//}


//// MARK: - Gradient view
//
//@IBDesignable class StyledGradient: GradientView {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupViews()
//    }
//
//    fileprivate func setupViews() {
//        startColor = .blue3
//        endColor = .blue1
//        direction = Direction.diagonalDown.rawValue
//    }
//}


// MARK: - Table view cell

@IBDesignable class StyledTableCell: CustomTableCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    func setupViews() {
        fontName = Keys.Font.cellTitle
        textColorName = Keys.Color.primaryText
        detailFontName = Keys.Font.cellSubtitle
        detailTextLabel?.textColor = .secondaryText
    }

}


// MARK: - Collection view

@IBDesignable class StyledCollectionView: CustomCollectionView { }


// MARK: - Table view

@IBDesignable class StyledTableView: CustomTableView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColorName = Keys.Color.backgroundFill
    }
 
}


// MARK: - Collection view cell

@IBDesignable class StyledCollectionCell: CustomCollectionCell, ShadowableCell {
    
    static let defaultSeparatorInset: CGFloat = 16
    
    @IBInspectable var separatorInset: CGFloat = StyledCollectionCell.defaultSeparatorInset {
        didSet {
            leadingConstraint?.constant = separatorInset
        }
    }
    
    var separator = UIView()
    
    fileprivate var leadingConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    func setUpViews() {
        backgroundColor = .lightBackground
        separator.backgroundColor = .borderStroke
        separator.isHidden = true
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        leadingConstraint = separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: separatorInset)
        leadingConstraint?.isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeShadow()
        separator.isHidden = true
        separatorInset = StyledCollectionCell.defaultSeparatorInset
    }
    
}

// MARK: - Tab bar

@IBDesignable class StyledTabBar: CustomBasicTabBar {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        tintColorName = Keys.Color.primaryAction
        unselectedItemTintColorName = Keys.Color.icon
    }
    
}


// MARK: - Switch

@IBDesignable class StyledSwitch: CustomSwitch {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        onTintColorName = Keys.Color.primaryAction
    }
    
}

@IBDesignable class RadioButton: UIButton {
    
    @IBInspectable var selectedImage: UIImage? {
        didSet {
            setUpViews()
        }
    }
    
    @IBInspectable var tintColorName: String? {
        didSet {
            setUpViews()
        }
    }
    
    @IBInspectable var selectedTintColorName: String? {
        didSet {
            setUpViews()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    private func setUpViews() {
        setImage(selectedImage, for: .selected)
        tintColor = isSelected ? UIColor(named: selectedTintColorName) : UIColor(named: tintColorName)
    }
    
    public var isOn: Bool {
        get {
            return isSelected
        }
        set {
            isSelected = isOn
        }
    }
    
    override var isSelected: Bool {
        didSet {
            setUpViews()
        }
    }
    
}


@IBDesignable class CheckRadioButton: RadioButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        selectedImage = #imageLiteral(resourceName: "checkBox-checked")
        setImage(#imageLiteral(resourceName: "checkBox-unchecked"), for: .normal)
        tintColorName = Keys.Color.disabledText
        selectedTintColorName = Keys.Color.primaryAction
    }
    
}


// MARK: - Segmented control

@IBDesignable class StyledSegmentedControl: CustomSegmentedControl { }


// MARK: - Activity indicator

@IBDesignable class StyledActivityIndicator: CustomActivityIndicator { }


// MARK: - Alert controller

class StyledAlertController: UIAlertController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var name = "Alert"
        if let title = title {
            name += ": \(title)"
        }
//        App.core.fire(event: ViewShown(viewName: name))
    }
    
}


// MARK: - Visual effect view

@IBDesignable class StyledVisualEffectView: CustomVisualEffectView { }


//// MARK: - Slider
//
//@IBDesignable class StyledSlider: CustomSlider {
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        steps = Presentation.TextSize.steps - 1
//        stepColor = .borderStroke
//    }
//
//}


// MARK: - Light status bar image picker

final class StyledImagePickerController: UIImagePickerController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


// MARK: - Light status bar document picker

final class StyledDocumentPickerController: UIDocumentPickerViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


// MARK: - Light status bar quick look preview controller

final class StyledQuickLookPreviewController: QLPreviewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}
//
//
//// MARK: - Date chooser view controller
//
//extension DateChooserViewController: StoryboardInitializable {
//
//    public static var storyboardName: String {
//        return "DateChooser"
//    }
//    
//}


//// MARK: - Pane view controller
//
//class StyledPaneViewController: PaneViewController {
//
//    override init(primaryViewController: UIViewController, secondaryViewController: UIViewController) {
//        super.init(primaryViewController: primaryViewController, secondaryViewController: secondaryViewController)
//        shouldBlurWhenSideBySideResizes = false
//        modalShadowColor = .modalBackground
//        modalOpenGap = 44.0
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}


// MARK: - Search bar

class StyledSearchBar: CustomSearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        barTintColor = .primaryAction
        tintColor = .lightText
    }

}
