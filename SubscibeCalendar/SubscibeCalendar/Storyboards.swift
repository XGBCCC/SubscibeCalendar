//
// Autogenerated by Natalie - Storyboard Generator Script.
// http://blog.krzyzanowskim.com
//

import UIKit

//MARK: - Storyboards

extension UIStoryboard {
    func instantiateViewController<T: UIViewController where T: IdentifiableProtocol>(type: T.Type) -> T? {
        let instance = type.init()
        if let identifier = instance.storyboardIdentifier {
            return self.instantiateViewControllerWithIdentifier(identifier) as? T
        }
        return nil
    }

}

protocol Storyboard {
    static var storyboard: UIStoryboard { get }
    static var identifier: String { get }
}

struct Storyboards {

    struct LaunchScreen: Storyboard {

        static let identifier = "LaunchScreen"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }

        static func instantiateInitialViewController() -> UIViewController {
            return self.storyboard.instantiateInitialViewController()!
        }

        static func instantiateViewControllerWithIdentifier(identifier: String) -> UIViewController {
            return self.storyboard.instantiateViewControllerWithIdentifier(identifier)
        }

        static func instantiateViewController<T: UIViewController where T: IdentifiableProtocol>(type: T.Type) -> T? {
            return self.storyboard.instantiateViewController(type)
        }
    }

    struct Main: Storyboard {

        static let identifier = "Main"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }

        static func instantiateInitialViewController() -> UINavigationController {
            return self.storyboard.instantiateInitialViewController() as! UINavigationController
        }

        static func instantiateViewControllerWithIdentifier(identifier: String) -> UIViewController {
            return self.storyboard.instantiateViewControllerWithIdentifier(identifier)
        }

        static func instantiateViewController<T: UIViewController where T: IdentifiableProtocol>(type: T.Type) -> T? {
            return self.storyboard.instantiateViewController(type)
        }

        static func instantiateSCCalendarViewController() -> SCCalendarViewController {
            return self.storyboard.instantiateViewControllerWithIdentifier("SCCalendarViewController") as! SCCalendarViewController
        }

        static func instantiateSCCalendarEventInfoViewController() -> SCCalendarEventInfoViewController {
            return self.storyboard.instantiateViewControllerWithIdentifier("SCCalendarEventInfoViewController") as! SCCalendarEventInfoViewController
        }

        static func instantiateSCSettingViewController() -> UINavigationController {
            return self.storyboard.instantiateViewControllerWithIdentifier("SCSettingViewController") as! UINavigationController
        }

        static func instantiateSCCalendarListViewController() -> SCCalendarListViewController {
            return self.storyboard.instantiateViewControllerWithIdentifier("SCCalendarListViewController") as! SCCalendarListViewController
        }

        static func instantiateSCCalendarDetailViewController() -> SCCalendarDetailViewController {
            return self.storyboard.instantiateViewControllerWithIdentifier("SCCalendarDetailViewController") as! SCCalendarDetailViewController
        }
    }
}

//MARK: - ReusableKind
enum ReusableKind: String, CustomStringConvertible {
    case TableViewCell = "tableViewCell"
    case CollectionViewCell = "collectionViewCell"

    var description: String { return self.rawValue }
}

//MARK: - SegueKind
enum SegueKind: String, CustomStringConvertible {    
    case Relationship = "relationship" 
    case Show = "show"                 
    case Presentation = "presentation" 
    case Embed = "embed"               
    case Unwind = "unwind"             
    case Push = "push"                 
    case Modal = "modal"               
    case Popover = "popover"           
    case Replace = "replace"           
    case Custom = "custom"             

    var description: String { return self.rawValue } 
}

//MARK: - IdentifiableProtocol

public protocol IdentifiableProtocol: Equatable {
    var storyboardIdentifier: String? { get }
}

//MARK: - SegueProtocol

public protocol SegueProtocol {
    var identifier: String? { get }
}

public func ==<T: SegueProtocol, U: SegueProtocol>(lhs: T, rhs: U) -> Bool {
    return lhs.identifier == rhs.identifier
}

public func ~=<T: SegueProtocol, U: SegueProtocol>(lhs: T, rhs: U) -> Bool {
    return lhs.identifier == rhs.identifier
}

public func ==<T: SegueProtocol>(lhs: T, rhs: String) -> Bool {
    return lhs.identifier == rhs
}

public func ~=<T: SegueProtocol>(lhs: T, rhs: String) -> Bool {
    return lhs.identifier == rhs
}

public func ==<T: SegueProtocol>(lhs: String, rhs: T) -> Bool {
    return lhs == rhs.identifier
}

public func ~=<T: SegueProtocol>(lhs: String, rhs: T) -> Bool {
    return lhs == rhs.identifier
}

//MARK: - ReusableViewProtocol
public protocol ReusableViewProtocol: IdentifiableProtocol {
    var viewType: UIView.Type? { get }
}

public func ==<T: ReusableViewProtocol, U: ReusableViewProtocol>(lhs: T, rhs: U) -> Bool {
    return lhs.storyboardIdentifier == rhs.storyboardIdentifier
}

//MARK: - Protocol Implementation
extension UIStoryboardSegue: SegueProtocol {
}

extension UICollectionReusableView: ReusableViewProtocol {
    public var viewType: UIView.Type? { return self.dynamicType }
    public var storyboardIdentifier: String? { return self.reuseIdentifier }
}

extension UITableViewCell: ReusableViewProtocol {
    public var viewType: UIView.Type? { return self.dynamicType }
    public var storyboardIdentifier: String? { return self.reuseIdentifier }
}

//MARK: - UIViewController extension
extension UIViewController {
    func performSegue<T: SegueProtocol>(segue: T, sender: AnyObject?) {
        if let identifier = segue.identifier {
            performSegueWithIdentifier(identifier, sender: sender)
        }
    }

    func performSegue<T: SegueProtocol>(segue: T) {
        performSegue(segue, sender: nil)
    }
}

//MARK: - UICollectionView

extension UICollectionView {

    func dequeueReusableCell<T: ReusableViewProtocol>(reusable: T, forIndexPath: NSIndexPath!) -> UICollectionViewCell? {
        if let identifier = reusable.storyboardIdentifier {
            return dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: forIndexPath)
        }
        return nil
    }

    func registerReusableCell<T: ReusableViewProtocol>(reusable: T) {
        if let type = reusable.viewType, identifier = reusable.storyboardIdentifier {
            registerClass(type, forCellWithReuseIdentifier: identifier)
        }
    }

    func dequeueReusableSupplementaryViewOfKind<T: ReusableViewProtocol>(elementKind: String, withReusable reusable: T, forIndexPath: NSIndexPath!) -> UICollectionReusableView? {
        if let identifier = reusable.storyboardIdentifier {
            return dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: identifier, forIndexPath: forIndexPath)
        }
        return nil
    }

    func registerReusable<T: ReusableViewProtocol>(reusable: T, forSupplementaryViewOfKind elementKind: String) {
        if let type = reusable.viewType, identifier = reusable.storyboardIdentifier {
            registerClass(type, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        }
    }
}
//MARK: - UITableView

extension UITableView {

    func dequeueReusableCell<T: ReusableViewProtocol>(reusable: T, forIndexPath: NSIndexPath!) -> UITableViewCell? {
        if let identifier = reusable.storyboardIdentifier {
            return dequeueReusableCellWithIdentifier(identifier, forIndexPath: forIndexPath)
        }
        return nil
    }

    func registerReusableCell<T: ReusableViewProtocol>(reusable: T) {
        if let type = reusable.viewType, identifier = reusable.storyboardIdentifier {
            registerClass(type, forCellReuseIdentifier: identifier)
        }
    }

    func dequeueReusableHeaderFooter<T: ReusableViewProtocol>(reusable: T) -> UITableViewHeaderFooterView? {
        if let identifier = reusable.storyboardIdentifier {
            return dequeueReusableHeaderFooterViewWithIdentifier(identifier)
        }
        return nil
    }

    func registerReusableHeaderFooter<T: ReusableViewProtocol>(reusable: T) {
        if let type = reusable.viewType, identifier = reusable.storyboardIdentifier {
             registerClass(type, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
}


//MARK: - SCCalendarViewController
extension SCCalendarViewController: IdentifiableProtocol { 
    var storyboardIdentifier: String? { return "SCCalendarViewController" }
    static var storyboardIdentifier: String? { return "SCCalendarViewController" }
}

extension SCCalendarViewController { 

    enum Reusable: String, CustomStringConvertible, ReusableViewProtocol {
        case SCCalendarEventHeaderCell_ = "SCCalendarEventHeaderCell"
        case SCCalendarEventCell_ = "SCCalendarEventCell"

        var kind: ReusableKind? {
            switch (self) {
            case SCCalendarEventHeaderCell_:
                return ReusableKind(rawValue: "tableViewCell")
            case SCCalendarEventCell_:
                return ReusableKind(rawValue: "tableViewCell")
            }
        }

        var viewType: UIView.Type? {
            switch (self) {
            case SCCalendarEventHeaderCell_:
                return SCCalendarEventHeaderCell.self
            case SCCalendarEventCell_:
                return SCCalendarEventCell.self
            }
        }

        var storyboardIdentifier: String? { return self.description } 
        var description: String { return self.rawValue }
    }

}


//MARK: - SCCalendarEventInfoViewController
extension SCCalendarEventInfoViewController: IdentifiableProtocol { 
    var storyboardIdentifier: String? { return "SCCalendarEventInfoViewController" }
    static var storyboardIdentifier: String? { return "SCCalendarEventInfoViewController" }
}

extension SCCalendarEventInfoViewController { 

    enum Reusable: String, CustomStringConvertible, ReusableViewProtocol {
        case SCCalendarEventTitleCell_ = "SCCalendarEventTitleCell"
        case SCCalendarEventTimeCell_ = "SCCalendarEventTimeCell"

        var kind: ReusableKind? {
            switch (self) {
            case SCCalendarEventTitleCell_:
                return ReusableKind(rawValue: "tableViewCell")
            case SCCalendarEventTimeCell_:
                return ReusableKind(rawValue: "tableViewCell")
            }
        }

        var viewType: UIView.Type? {
            switch (self) {
            case SCCalendarEventTitleCell_:
                return SCCalendarEventTitleCell.self
            case SCCalendarEventTimeCell_:
                return SCCalendarEventTimeCell.self
            }
        }

        var storyboardIdentifier: String? { return self.description } 
        var description: String { return self.rawValue }
    }

}


//MARK: - SCCalendarListViewController
extension SCCalendarListViewController: IdentifiableProtocol { 
    var storyboardIdentifier: String? { return "SCCalendarListViewController" }
    static var storyboardIdentifier: String? { return "SCCalendarListViewController" }
}

extension SCCalendarListViewController { 

    enum Reusable: String, CustomStringConvertible, ReusableViewProtocol {
        case SCCalendarListCell_ = "SCCalendarListCell"

        var kind: ReusableKind? {
            switch (self) {
            case SCCalendarListCell_:
                return ReusableKind(rawValue: "tableViewCell")
            }
        }

        var viewType: UIView.Type? {
            switch (self) {
            case SCCalendarListCell_:
                return SCCalendarListCell.self
            }
        }

        var storyboardIdentifier: String? { return self.description } 
        var description: String { return self.rawValue }
    }

}


//MARK: - SCCalendarDetailViewController
extension SCCalendarDetailViewController: IdentifiableProtocol { 
    var storyboardIdentifier: String? { return "SCCalendarDetailViewController" }
    static var storyboardIdentifier: String? { return "SCCalendarDetailViewController" }
}


//MARK: - SCSettingViewController
extension SCSettingViewController { 

    enum Reusable: String, CustomStringConvertible, ReusableViewProtocol {
        case SCSettingUserCell_ = "SCSettingUserCell"
        case SCSettingDefaultCell = "SCSettingDefaultCell"

        var kind: ReusableKind? {
            switch (self) {
            case SCSettingUserCell_:
                return ReusableKind(rawValue: "tableViewCell")
            case SCSettingDefaultCell:
                return ReusableKind(rawValue: "tableViewCell")
            }
        }

        var viewType: UIView.Type? {
            switch (self) {
            case SCSettingUserCell_:
                return SCSettingUserCell.self
            default:
                return nil
            }
        }

        var storyboardIdentifier: String? { return self.description } 
        var description: String { return self.rawValue }
    }

}

