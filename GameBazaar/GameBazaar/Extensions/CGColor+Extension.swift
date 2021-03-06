//
//  CGColorExtension.swift
//  GameBazaar
//
//  Created by bahadir on 26.05.2021.
//

import CoreGraphics

extension CGColor {
  
    static func fromHexCode(_ code: String) -> CGColor {
        
        if (code.count == 7 && code.hasPrefix("#")) {
            let r = code.index(code.startIndex, offsetBy: 1)
            let g = code.index(code.startIndex, offsetBy: 3)
            let b = code.index(code.startIndex, offsetBy: 5)
            
            if let rHex = Int(code[r..<g], radix: 16),
                let gHex = Int(code[g..<b], radix: 16),
                let bHex = Int(code[b...], radix: 16) {
                
                return CGColor(red: CGFloat(rHex) / 0xff,
                               green: CGFloat(gHex) / 0xff,
                               blue: CGFloat(bHex) / 0xff,
                               alpha: 1.0)
            }
        }
        
        return CGColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0) //grey
    }
    
    static let red = CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    static let green = CGColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    static let blue = CGColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    
    static let ligthGrayApp = CGColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
    
    static let cantaloupe = fromHexCode("#ffce6e")
    static let honeydew = fromHexCode("#cefa6e")
    static let spindrift = fromHexCode("#68fbd0")
    static let sky = fromHexCode("#6acfff")
    static let lavender = fromHexCode("#d278ff")
    static let carnation = fromHexCode("#ff7fd3")
    static let licorice = fromHexCode("#000000")
    static let snow = fromHexCode("#ffffff")
    static let salmon = fromHexCode("#ff726e")
    static let banana = fromHexCode("#fffb6d")
    static let flora = fromHexCode("#68f96e")
    static let ice = fromHexCode("#68fdff")
    static let orchid = fromHexCode("#6e76ff")
    static let bubblegum = fromHexCode("#ff7aff")
    static let lead = fromHexCode("#1e1e1e")
    static let mercury = fromHexCode("#e8e8e8")
    static let tangerine = fromHexCode("#ff8802")
    static let lime = fromHexCode("#83f902")
    static let aqua = fromHexCode("#008cff")
    static let grape = fromHexCode("#8931ff")
    static let strawberry = fromHexCode("#ff2987")
    static let tungsten = fromHexCode("#3a3a3a")
    static let silver = fromHexCode("#d0d0d0")
    static let maraschino = fromHexCode("#ff2101")
    static let mandarin = fromHexCode("#ff9900")
    static let lemon = fromHexCode("#fffa03")
    static let spring = fromHexCode("#05f802")
    static let turquoise = fromHexCode("#00fdff")
    static let blueberry = fromHexCode("#002eff")
    static let magenta = fromHexCode("#ff39ff")
    static let iron = fromHexCode("#545453")
    static let magnesium = fromHexCode("#b8b8b8")
    static let mocha = fromHexCode("#894800")
    static let fern = fromHexCode("#458401")
    static let moss = fromHexCode("#018448")
    static let ocean = fromHexCode("#004a88")
    static let eggplant = fromHexCode("#491a88")
    static let maroon = fromHexCode("#891648")
    static let steel = fromHexCode("#6e6e6e")
    static let aluminum = fromHexCode("#a09fa0")
    static let cayenne = fromHexCode("#891100")
    static let aspargus = fromHexCode("#888501")
    static let clover = fromHexCode("#028401")
    static let teal = fromHexCode("#008688")
    static let midnight = fromHexCode("#001888")
    static let plum = fromHexCode("#891e88")
    static let tin = fromHexCode("#878687")
    static let nickel = fromHexCode("#888787")
}
