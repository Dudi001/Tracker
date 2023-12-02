//
//  UIColor+Extension.swift
//  Tracker
//
//  Created by Dmitry Medvedev on 24.05.2023.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    
    //MARK: backgroundColors
    static var ypBackground: UIColor { UIColor(named: "ypBackground") ?? .systemGray}
    static var ypBlack: UIColor { UIColor(named: "ypBlack") ?? .black}
    static var ypBlue: UIColor { UIColor(named: "ypBlue") ?? .blue}
    static var ypGray: UIColor { UIColor(named: "ypGray") ?? .gray}
    static var ypLightGray: UIColor { UIColor(named: "ypLightGray") ?? .lightGray}
    static var ypRed: UIColor { UIColor(named: "ypRed") ?? .red}
    static var ypWhite: UIColor { UIColor(named: "ypWhite") ?? .white}
    
    //MARK: selectionColors
    static let colorSection1 = UIColor(hexString: "#FD4C49")
    static let colorSection2 = UIColor(hexString: "#FF881E")
    static let colorSection3 = UIColor(hexString: "#007BFA")
    static let colorSection4 = UIColor(hexString: "#6E44FE")
    static let colorSection5 = UIColor(hexString: "#33CF69")
    static let colorSection6 = UIColor(hexString: "#E66DD4")
    static let colorSection7 = UIColor(hexString: "#F9D4D4")
    static let colorSection8 = UIColor(hexString: "#34A7FE")
    static let colorSection9 = UIColor(hexString: "#46E69D")
    static let colorSection10 = UIColor(hexString: "#35347C")
    static let colorSection11 = UIColor(hexString: "#FF674D")
    static let colorSection12 = UIColor(hexString: "#FF99CC")
    static let colorSection13 = UIColor(hexString: "#F6C48B")
    static let colorSection14 = UIColor(hexString: "#7994F5")
    static let colorSection15 = UIColor(hexString: "#832CF1")
    static let colorSection16 = UIColor(hexString: "#AD56DA")
    static let colorSection17 = UIColor(hexString: "#8D72E6")
    static let colorSection18 = UIColor(hexString: "#2FD058")

}


