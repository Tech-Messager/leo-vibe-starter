import SwiftUI

struct ContentView: View {
    @StateObject private var camera = CameraModel()
    @State private var shutterClosed = false

    var body: some View {
        ZStack {
            Theme.vulcanite.ignoresSafeArea()
            VStack(spacing: 0) {
                TopPlate(frameCount: camera.frameCount)
                Viewfinder(image: camera.preview, permissionDenied: camera.permissionDenied, shutterClosed: shutterClosed)
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                Spacer(minLength: 16)
                FilmDial(selection: $camera.film)
                Spacer(minLength: 16)
                HStack {
                    LastShot(image: camera.lastShot)
                    Spacer()
                    ShutterButton(action: fire)
                    Spacer()
                    RedDot(size: 56)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            }
        }
        .onAppear { camera.start() }
    }

    private func fire() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        camera.shoot()
        shutterClosed = true
        withAnimation(.easeOut(duration: 0.25).delay(0.05)) { shutterClosed = false }
    }
}

private struct TopPlate: View {
    let frameCount: Int

    var body: some View {
        HStack {
            Text("RETROCAM")
                .font(.system(size: 18, weight: .semibold, design: .serif))
                .tracking(6)
                .foregroundStyle(.black.opacity(0.75))
            Spacer()
            Text(String(format: "%02d", frameCount))
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .foregroundStyle(Theme.engraving)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Capsule().fill(.black))
        }
        .padding(.horizontal, 24)
        .frame(height: 64)
        .background(Theme.chrome.ignoresSafeArea(edges: .top))
        .overlay(alignment: .bottom) { Rectangle().fill(.black.opacity(0.4)).frame(height: 1) }
    }
}

private struct Viewfinder: View {
    let image: CGImage?
    let permissionDenied: Bool
    let shutterClosed: Bool

    var body: some View {
        ZStack {
            Color.black
            if let image {
                Image(decorative: image, scale: 1)
                    .resizable()
                    .scaledToFill()
            }
            if permissionDenied {
                Text("请在“设置”中允许 RetroCam 使用相机")
                    .font(.footnote)
                    .foregroundStyle(Theme.engraving)
            }
            BrightFrame()
                .stroke(Theme.brightFrame.opacity(0.85), lineWidth: 1.5)
                .padding(18)
            Color.black.opacity(shutterClosed ? 1 : 0)
        }
        .aspectRatio(3 / 4, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Theme.chrome, lineWidth: 3))
    }
}

private struct BrightFrame: Shape {
    func path(in rect: CGRect) -> Path {
        let arm = min(rect.width, rect.height) * 0.08
        var path = Path()
        for (corner, dx, dy) in [
            (CGPoint(x: rect.minX, y: rect.minY), arm, arm),
            (CGPoint(x: rect.maxX, y: rect.minY), -arm, arm),
            (CGPoint(x: rect.minX, y: rect.maxY), arm, -arm),
            (CGPoint(x: rect.maxX, y: rect.maxY), -arm, -arm),
        ] {
            path.move(to: CGPoint(x: corner.x + dx, y: corner.y))
            path.addLine(to: corner)
            path.addLine(to: CGPoint(x: corner.x, y: corner.y + dy))
        }
        return path
    }
}

private struct FilmDial: View {
    @Binding var selection: FilmStock

    var body: some View {
        HStack(spacing: 10) {
            ForEach(FilmStock.allCases) { film in
                Button {
                    UISelectionFeedbackGenerator().selectionChanged()
                    selection = film
                } label: {
                    Text(film.rawValue)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .tracking(2)
                        .foregroundStyle(selection == film ? .black : Theme.engraving)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background {
                            if selection == film {
                                Capsule().fill(Theme.chrome)
                            } else {
                                Capsule().stroke(Theme.engraving.opacity(0.4))
                            }
                        }
                }
            }
        }
    }
}

private struct ShutterButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(Theme.chrome)
                Circle().stroke(.black.opacity(0.5), lineWidth: 1).padding(8)
                Circle().fill(Theme.chrome).rotationEffect(.degrees(180)).padding(16)
            }
            .frame(width: 84, height: 84)
            .shadow(color: .black.opacity(0.6), radius: 6, y: 3)
        }
        .buttonStyle(PressStyle())
    }
}

private struct PressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.92 : 1)
    }
}

private struct LastShot: View {
    let image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image).resizable().scaledToFill()
            } else {
                Color.black
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Theme.chrome, lineWidth: 2))
    }
}

private struct RedDot: View {
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(Theme.red)
            .overlay(
                Text("R")
                    .font(.system(size: size * 0.5, weight: .bold, design: .serif))
                    .italic()
                    .foregroundStyle(.white)
            )
            .frame(width: size, height: size)
    }
}
