/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

@IBDesignable class CustomButton: UIButton, CircularView, DisabledBackgroundColorNameable, DisabledTintColorNameable, DisabledBorderColorNameable, ShadowColorNameable, FontNameable {
    
    // MARK: - Inspectable properties

    @IBInspectable open var titleColorName: String? {
        didSet {
            updateTitleColor()
        }
    }
    
    @IBInspectable open var disabledTitleColorName: String? {
        didSet {
            updateDisabledTitleColor()
        }
    }
    
    @IBInspectable open var backgroundColorName: String? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    @IBInspectable open var disabledBackgroundColorName: String? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    @IBInspectable open var tintColorName: String? {
        didSet {
            updateTintColor()
        }
    }
    
    @IBInspectable open var disabledTintColorName: String? {
        didSet {
            updateTintColor()
        }
    }
    
    @IBInspectable open var borderColorName: String? {
        didSet {
            updateBorderColor()
        }
    }
    
    @IBInspectable open var disabledBorderColorName: String? {
        didSet {
            updateBorderColor()
        }
    }
    
    @IBInspectable open var progressColorName: String? {
        didSet {
            guard let color = UIColor(withName: progressColorName) else { return }
            progressColor = color
        }
    }

    @IBInspectable open var shadowColorName: String? {
        didSet {
            applyShadowColorName()
        }
    }
    
    @IBInspectable open var fontName: String? {
        didSet {
            applyFontName()
        }
    }
    
    @IBInspectable open var progress: Double = 0.0 {
        didSet {
            progressLayer.strokeEnd = CGFloat(progress)
        }
    }
    
    @IBInspectable open var progressColor: UIColor = #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)  {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    @IBInspectable open var circular: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    private var originalTitle: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        originalTitle = titleLabel?.text
    }
    
    @IBInspectable open var isLoading: Bool = false {
        didSet {
            if isLoading {
                spinner.color = titleColor(for: UIControlState.normal)
                spinner.startAnimating()
                setTitle(nil, for: UIControlState.normal)
                accessibilityLabel = NSLocalizedString("Loading", comment: "Label for button while isLoading")
            } else {
                spinner.stopAnimating()
                setTitle(originalTitle, for: UIControlState.normal)
                accessibilityLabel = nil
            }
        }
    }
    
    
    // MARK: - Overrides
    
    override var isEnabled: Bool {
        didSet {
            updateColors()
        }
    }
    
    
    // MARK: - Computed properties
    
    open var displayFont: UIFont? {
        get {
            return titleLabel?.font
        }
        set {
            titleLabel?.font = newValue
        }
    }
    
    
    // MARK: - Private properties
    
    fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    fileprivate let progressLayer = CAShapeLayer()

    
    // MARK: - Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        registerForNotifications()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        registerForNotifications()
    }
    
    
    // MARK: - Lifecycle overrides
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        applyCircularStyleIfNeeded()
        
        progressLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        let rotation = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        let translate = CATransform3DMakeTranslation(0, bounds.height, 0)
        progressLayer.transform = CATransform3DConcat(rotation, translate)
        progressLayer.lineWidth = bounds.height
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyFontName()
    }

    
    // MARK: - Functions
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: Notification.Name.AppearanceColorsUpdated, object: nil)
    }
    
    @objc func updateColors() {
        updateTitleColor()
        updateDisabledTitleColor()
        updateBackgroundColor()
        updateTintColor()
        updateBorderColor()
        applyShadowColorName()
    }
    
    func updateTitleColor() {
        setTitleColor(UIColor(withName: titleColorName), for: .normal)
    }
    
    func updateDisabledTitleColor() {
        setTitleColor(UIColor(withName: disabledTitleColorName), for: .disabled)
    }

}


// MARK: - Private properties

private extension CustomButton {
    
    func setupViews() {
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.stopAnimating()
        
        layer.addSublayer(progressLayer)
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        progressLayer.strokeColor = progressColor.cgColor
    }
    
}
