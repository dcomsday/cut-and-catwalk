import AppKit
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let imageDirectory = root.appendingPathComponent("img")
let fontDirectory = root.appendingPathComponent("fonts")
try FileManager.default.createDirectory(at: imageDirectory, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: fontDirectory, withIntermediateDirectories: true)

let ink = NSColor(calibratedRed: 0.09, green: 0.09, blue: 0.07, alpha: 1)
let paper = NSColor(calibratedRed: 0.96, green: 0.95, blue: 0.91, alpha: 1)
let lime = NSColor(calibratedRed: 0.85, green: 1, blue: 0.24, alpha: 1)
let pink = NSColor(calibratedRed: 1, green: 0.36, blue: 0.64, alpha: 1)
let purple = NSColor(calibratedRed: 0.49, green: 0.30, blue: 1, alpha: 1)
let blue = NSColor(calibratedRed: 0.56, green: 0.75, blue: 1, alpha: 1)
let orange = NSColor(calibratedRed: 1, green: 0.72, blue: 0.31, alpha: 1)

func rect(_ c: CGContext, _ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ color: NSColor) {
    c.setFillColor(color.cgColor); c.fill(CGRect(x: x, y: y, width: w, height: h))
}
func ellipse(_ c: CGContext, _ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ color: NSColor) {
    c.setFillColor(color.cgColor); c.fillEllipse(in: CGRect(x: x, y: y, width: w, height: h))
}
func line(_ c: CGContext, _ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, _ color: NSColor, _ width: CGFloat = 2) {
    c.setStrokeColor(color.cgColor); c.setLineWidth(width); c.move(to: CGPoint(x: x1, y: y1)); c.addLine(to: CGPoint(x: x2, y: y2)); c.strokePath()
}
func text(_ c: CGContext, _ value: String, _ x: CGFloat, _ y: CGFloat, _ size: CGFloat, _ color: NSColor, _ weight: NSFont.Weight = .bold) {
    let font = NSFont.systemFont(ofSize: size, weight: weight)
    let attr = NSAttributedString(string: value, attributes: [.font: font, .foregroundColor: color])
    let line = CTLineCreateWithAttributedString(attr)
    c.textPosition = CGPoint(x: x, y: y); CTLineDraw(line, c)
}

func drawArtwork(_ name: String, _ c: CGContext, _ w: CGFloat, _ h: CGFloat, _ phase: Int = 0, _ alpha: Bool = false) {
    let colors = [lime, pink, purple, blue, orange]
    let idx = name.utf8.reduce(0) { ($0 + Int($1)) % colors.count }
    if !alpha { rect(c, 0, 0, w, h, paper) }

    switch name {
    case "model-cutout.png", "upcycling-patch.png":
        if name == "model-cutout.png" {
            let garment = colors[(idx + 1) % colors.count]
            // A graphic, deliberately abstract runway portrait on transparent canvas.
            ellipse(c, w * 0.39, h * 0.78, w * 0.24, h * 0.17, orange)
            rect(c, w * 0.485, h * 0.70, w * 0.05, h * 0.10, orange)
            c.setFillColor(garment.cgColor)
            c.move(to: CGPoint(x: w * 0.30, y: h * 0.05)); c.addLine(to: CGPoint(x: w * 0.72, y: h * 0.05))
            c.addLine(to: CGPoint(x: w * 0.65, y: h * 0.56)); c.addLine(to: CGPoint(x: w * 0.79, y: h * 0.67))
            c.addLine(to: CGPoint(x: w * 0.24, y: h * 0.67)); c.addLine(to: CGPoint(x: w * 0.38, y: h * 0.55)); c.closePath(); c.fillPath()
            line(c, w * 0.39, h * 0.56, w * 0.27, h * 0.18, ink, w * 0.035)
            line(c, w * 0.63, h * 0.56, w * 0.76, h * 0.17, ink, w * 0.035)
            line(c, w * 0.43, h * 0.07, w * 0.38, h * 0.01, ink, w * 0.025)
            line(c, w * 0.60, h * 0.07, w * 0.64, h * 0.01, ink, w * 0.025)
            for i in 0..<4 { ellipse(c, w * (0.41 + CGFloat(i % 2) * 0.12), h * (0.30 + CGFloat(i / 2) * 0.13), w * 0.045, w * 0.045, i % 2 == 0 ? lime : pink) }
            ellipse(c, w * 0.43, h * 0.85, w * 0.16, h * 0.15, orange)
        } else {
            c.setFillColor(lime.cgColor); c.move(to: CGPoint(x: w*0.12,y:h*0.25)); c.addLine(to: CGPoint(x:w*0.82,y:h*0.15)); c.addLine(to: CGPoint(x:w*0.9,y:h*0.77)); c.addLine(to: CGPoint(x:w*0.2,y:h*0.87)); c.closePath(); c.fillPath()
            for i in 0..<6 { line(c, w*0.18, h*(0.32+CGFloat(i)*0.08), w*0.83, h*(0.23+CGFloat(i)*0.08), ink, 3) }
            text(c, "REPAIR!", w*0.28, h*0.49, w*0.15, pink)
            ellipse(c, w*0.66, h*0.55, w*0.14, w*0.14, purple)
        }
        return
    default: break
    }

    let base = colors[idx]
    rect(c, 0, 0, w, h, base)
    if name.contains("hero") || name.contains("og-image") || name.contains("zine") {
        for i in 0..<8 {
            let x = CGFloat(i) * w / 8
            rect(c, x, 0, w/16, h, i % 2 == 0 ? ink : paper)
        }
        ellipse(c, w * 0.15, h * 0.17, w * 0.70, h * 0.74, colors[(idx + 2) % colors.count])
        text(c, "CUT", w * 0.08, h * 0.79, h * 0.22, lime)
        text(c, "& CATWALK", w * 0.08, h * 0.62, h * 0.12, paper)
        // Dressed-up figures, graphic texture and cut-out geometry.
        for i in 0..<3 {
            let x = w * (0.36 + CGFloat(i) * 0.19)
            ellipse(c, x, h * 0.55, w * 0.095, w * 0.095, orange)
            rect(c, x + w * 0.015, h * 0.27, w * 0.065, h * 0.3, i == 1 ? lime : paper)
            line(c, x + w * 0.035, h * 0.29, x - w * 0.01, h * 0.05, ink, w * 0.025)
            line(c, x + w * 0.06, h * 0.29, x + w * 0.14, h * 0.05, ink, w * 0.025)
        }
    } else if name.contains("runway") || name.contains("backstage") {
        rect(c, 0, h * 0.62, w, h * 0.38, ink)
        for i in 0..<7 {
            let x = CGFloat(i) * w / 6
            line(c, x, h, w * 0.42 + (x - w * 0.42) * 0.22, h * 0.55, colors[(i + 2) % colors.count], 3)
            ellipse(c, x - w * 0.025, h * 0.72, w * 0.06, h * 0.06, orange)
        }
        text(c, "YOUR LOOK. YOUR RULES.", w * 0.06, h * 0.9, h * 0.08, ink)
        for i in 0..<3 {
            let x = w * (0.4 + CGFloat(i) * 0.18)
            ellipse(c, x, h * 0.48, w * 0.075, w * 0.075, orange)
            rect(c, x + w * 0.01, h * 0.22, w * 0.055, h * 0.28, colors[(i+1)%colors.count])
            line(c, x + w * 0.02, h * 0.25, x - w * 0.01, h * 0.04, paper, 5)
            line(c, x + w * 0.055, h * 0.25, x + w * 0.1, h * 0.04, paper, 5)
        }
    } else if name.contains("crowd") || name.contains("designer") {
        rect(c, 0, 0, w, h, ink)
        for i in 0..<15 {
            let x = CGFloat(i) * w / 14
            let y = h * (0.14 + CGFloat((i * 13 + phase * 7) % 17) / 100)
            ellipse(c, x - w*0.027, y, w*0.055, w*0.055, colors[i % colors.count])
            c.setFillColor(colors[(i+2)%colors.count].cgColor)
            c.fill(CGRect(x: x-w*0.045, y: y-h*0.45, width: w*0.09, height: h*0.43))
        }
        text(c, "EVERY BODY", w * 0.07, h * 0.88, h * 0.11, lime)
        text(c, "IS A FRONT ROW.", w * 0.07, h * 0.78, h * 0.08, paper)
    } else if name.contains("sneaker") {
        rect(c, 0, 0, w, h, paper)
        c.setFillColor(pink.cgColor)
        c.move(to: CGPoint(x:w*0.08,y:h*0.3)); c.addLine(to: CGPoint(x:w*0.3,y:h*0.48)); c.addLine(to: CGPoint(x:w*0.6,y:h*0.5)); c.addLine(to: CGPoint(x:w*0.78,y:h*0.4)); c.addLine(to: CGPoint(x:w*0.93,y:h*0.31)); c.addLine(to: CGPoint(x:w*0.88,y:h*0.18)); c.addLine(to: CGPoint(x:w*0.18,y:h*0.18)); c.closePath(); c.fillPath()
        line(c,w*0.16,h*0.2,w*0.9,h*0.2,ink,8)
        for i in 0..<4 { line(c,w*(0.33+CGFloat(i)*0.07),h*0.43,w*(0.46+CGFloat(i)*0.06),h*0.32,ink,3) }
        text(c,"WORN WITH LOVE",w*0.07,h*0.83,h*0.08,ink)
    } else {
        rect(c, 0, 0, w, h, base)
        for i in 0..<8 {
            let x = CGFloat(i) * w / 8
            ellipse(c, x, h * CGFloat((i * 17 + 13) % 60) / 100, w * 0.22, w * 0.22, colors[(i + idx) % colors.count])
        }
        text(c, "MAKE IT YOURS", w*0.08, h*0.14, h*0.12, ink)
    }

    if name.contains("gif") {
        let shift = CGFloat(phase % 4) * w * 0.035
        rect(c, 0, h*0.08, w, h*0.12, paper)
        rect(c, 0, h*0.79, w, h*0.1, paper)
        text(c, "CATWALK / \(String(format: "%02d", phase + 1))", w*0.08, h*0.82, h*0.065, ink)
        rect(c, w*0.34+shift, h*0.25, w*0.32, h*0.5, phase % 2 == 0 ? lime : pink)
        ellipse(c, w*0.43+shift, h*0.65, w*0.14, w*0.14, orange)
        line(c,w*0.41+shift,h*0.28,w*0.32+shift,h*0.05,ink,5)
        line(c,w*0.57+shift,h*0.28,w*0.69+shift,h*0.05,ink,5)
        rect(c, w*CGFloat((phase*7)%11)/11, 0, w*0.025, h, phase % 2 == 0 ? pink : blue)
    }
}

func render(_ name: String, width: Int, height: Int, alpha: Bool = false, phase: Int = 0) throws -> CGImage {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmap = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    guard let ctx = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmap.rawValue) else { fatalError("Could not create image context") }
    if alpha { ctx.clear(CGRect(x: 0, y: 0, width: width, height: height)) }
    drawArtwork(name, ctx, CGFloat(width), CGFloat(height), phase, alpha)
    guard let image = ctx.makeImage() else { fatalError("Could not render \(name)") }
    return image
}

func save(_ name: String, width: Int, height: Int, alpha: Bool = false, phase: Int = 0) throws -> CGImage {
    let image = try render(name, width: width, height: height, alpha: alpha, phase: phase)
    let url = imageDirectory.appendingPathComponent(name)
    if name.hasSuffix(".webp") {
        let pngURL = imageDirectory.appendingPathComponent(".asset-source.png")
        guard let dest = CGImageDestinationCreateWithURL(pngURL as CFURL, UTType.png.identifier as CFString, 1, nil) else { throw NSError(domain: "Asset", code: 1) }
        CGImageDestinationAddImage(dest, image, nil)
        guard CGImageDestinationFinalize(dest) else { throw NSError(domain: "Asset", code: 2) }
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["cwebp", "-q", "88", pngURL.path, "-o", url.path]
        try process.run()
        process.waitUntilExit()
        try FileManager.default.removeItem(at: pngURL)
        guard process.terminationStatus == 0 else { throw NSError(domain: "Asset", code: Int(process.terminationStatus)) }
    } else if name.hasSuffix(".jpg") || name.hasSuffix(".jpeg") {
        guard let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.jpeg.identifier as CFString, 1, nil) else { throw NSError(domain: "Asset", code: 3) }
        CGImageDestinationAddImage(dest, image, [kCGImageDestinationLossyCompressionQuality: 0.88] as CFDictionary)
        guard CGImageDestinationFinalize(dest) else { throw NSError(domain: "Asset", code: 4) }
    } else {
        guard let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else { throw NSError(domain: "Asset", code: 5) }
        CGImageDestinationAddImage(dest, image, nil)
        guard CGImageDestinationFinalize(dest) else { throw NSError(domain: "Asset", code: 6) }
    }
    return image
}

let staticAssets: [(String, Int, Int, Bool)] = [
    ("hero-collage.webp", 1400, 1100, false), ("model-cutout.png", 700, 1200, true),
    ("runway-stage.jpg", 1200, 850, false), ("backstage-1.webp", 1100, 820, false),
    ("backstage-2.jpg", 1100, 850, false), ("upcycling-patch.png", 700, 600, true),
    ("designer-team.jpg", 1100, 900, false), ("zine-spread.webp", 1100, 850, false),
    ("sneaker-detail.jpg", 1000, 800, false), ("crowd-vibe.webp", 1200, 850, false),
    ("og-image.jpg", 1200, 630, false), ("favicon.png", 32, 32, false),
    ("apple-touch-icon.png", 180, 180, false)
]
for (name, width, height, alpha) in staticAssets {
    let outputURL = imageDirectory.appendingPathComponent(name)
    guard !FileManager.default.fileExists(atPath: outputURL.path) else { continue }
    _ = try save(name, width: width, height: height, alpha: alpha)
}

func createTransparentModelCutout() throws {
    let sourceURL = imageDirectory.appendingPathComponent("model-cutout.JPG")
    guard FileManager.default.fileExists(atPath: sourceURL.path) else { return }
    guard let source = CGImageSourceCreateWithURL(sourceURL as CFURL, nil),
          let original = CGImageSourceCreateImageAtIndex(source, 0, nil),
          let context = CGContext(
            data: nil,
            width: original.width,
            height: original.height,
            bitsPerComponent: 8,
            bytesPerRow: original.width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
          ),
          let pixels = context.data?.assumingMemoryBound(to: UInt8.self) else {
        throw NSError(domain: "Asset", code: 7, userInfo: [NSLocalizedDescriptionKey: "Could not read the supplied model cutout"])
    }

    context.draw(original, in: CGRect(x: 0, y: 0, width: original.width, height: original.height))
    for y in 0..<original.height {
        for x in 0..<original.width {
            let offset = (y * original.width + x) * 4
            let red = Int(pixels[offset])
            let green = Int(pixels[offset + 1])
            let blue = Int(pixels[offset + 2])
            let lightest = min(red, green, blue)
            let darkest = max(red, green, blue)
            let spread = darkest - lightest
            var alpha = 255
            if lightest >= 247 && spread <= 24 {
                alpha = 0
            } else if lightest >= 229 && spread <= 28 {
                alpha = max(0, min(255, (247 - lightest) * 255 / 18))
            }
            pixels[offset] = UInt8(red * alpha / 255)
            pixels[offset + 1] = UInt8(green * alpha / 255)
            pixels[offset + 2] = UInt8(blue * alpha / 255)
            pixels[offset + 3] = UInt8(alpha)
        }
    }

    guard let cutout = context.makeImage() else {
        throw NSError(domain: "Asset", code: 8, userInfo: [NSLocalizedDescriptionKey: "Could not create the transparent model cutout"])
    }
    let outputURL = imageDirectory.appendingPathComponent("model-cutout.png")
    guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, UTType.png.identifier as CFString, 1, nil) else {
        throw NSError(domain: "Asset", code: 9, userInfo: [NSLocalizedDescriptionKey: "Could not write the transparent model cutout"])
    }
    CGImageDestinationAddImage(destination, cutout, nil)
    guard CGImageDestinationFinalize(destination) else {
        throw NSError(domain: "Asset", code: 10, userInfo: [NSLocalizedDescriptionKey: "Could not finish the transparent model cutout"])
    }
}
try createTransparentModelCutout()

let gifURL = imageDirectory.appendingPathComponent("glitch-catwalk.gif")
if !FileManager.default.fileExists(atPath: gifURL.path) {
    guard let gifDest = CGImageDestinationCreateWithURL(gifURL as CFURL, UTType.gif.identifier as CFString, 8, nil) else { fatalError("Could not create GIF") }
    for frame in 0..<8 {
        guard let image = try? render("glitch-catwalk.gif", width: 720, height: 520, phase: frame) else { fatalError("Could not draw GIF frame") }
        CGImageDestinationAddImage(gifDest, image, [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: 0.16]] as CFDictionary)
    }
    guard CGImageDestinationFinalize(gifDest) else { fatalError("Could not finish GIF") }
}

func createLogbook() throws {
    let url = root.appendingPathComponent("logbuch.pdf")
    var media = CGRect(x: 0, y: 0, width: 595, height: 842)
    guard let context = CGContext(url as CFURL, mediaBox: &media, nil) else { fatalError("Could not create PDF") }
    context.beginPDFPage(nil)
    rect(context, 0, 0, 595, 842, paper)
    rect(context, 0, 590, 595, 252, lime)
    text(context, "CUT & CATWALK / STUDIENPROJEKT", 42, 778, 17, ink)
    text(context, "KI-LOGBUCH", 42, 677, 48, ink)
    text(context, "Fiktives Eventkonzept, Gestaltung und Umsetzung", 44, 644, 12, ink, .medium)
    text(context, "Projektstand: 24. November 2026", 44, 612, 10, ink, .medium)
    let sections: [(String, [String])] = [
        ("01 / AUFTRAG", ["Mehrseitige Website als fiktives Studienprojekt für CUT & CATWALK", "2027: ein Konzept für Teenager-Streetwear, Upcycling und Runway."]),
        ("02 / EVENTKONZEPT", ["Die Angaben 19. Juni 2027, 16:00–22:00 Uhr, Hamburg und", "Kulturwerkstatt Altona-Nord sind fiktive Projektdaten.", "Ticketpreise sind Entwurfsinhalte; es gibt keinen Verkauf."]),
        ("03 / UMSETZUNG", ["Startseite, Programm, Story, Tickets, Infos und 404-Seite erstellt.", "Responsive CSS, Social-Metadaten, Event-Schema, Sprungmarken,", "Navigation, favicon und Apple Touch Icon ergänzt."]),
        ("04 / ASSETS", ["SVG-Logo und Icons sowie lokale PNG-, JPEG-, WebP- und GIF-Assets.", "Der freigestellte Model-Cutout basiert auf der bereitgestellten JPG-Datei.", "Bestehende Bilddateien bleiben bei erneuter Generierung erhalten."]),
        ("05 / HINWEIS", ["Keine reale Veranstaltung und kein Ticketverkauf.", "Inhalte und Veranstaltungsangaben sind Teil des Studienprojekts.", "Externe Bildquellen sind im Bildnachweis zu ergänzen."])
    ]
    var y: CGFloat = 548
    for (heading, lines) in sections {
        text(context, heading, 44, y, 12, purple); y -= 25
        for value in lines { text(context, value, 44, y, 10, ink, .regular); y -= 17 }
        y -= 18
    }
    rect(context, 0, 0, 595, 34, ink)
    text(context, "CUT & CATWALK  /  KI-LOGBUCH", 44, 13, 8, paper, .medium)
    context.endPDFPage()
    context.closePDF()
}
try createLogbook()
