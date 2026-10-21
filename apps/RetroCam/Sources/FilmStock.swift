import CoreImage

enum FilmStock: String, CaseIterable, Identifiable {
    case chrome = "CHROME"
    case portra = "PORTRA"
    case trix = "TRI-X"

    var id: String { rawValue }

    private var effectName: String {
        switch self {
        case .chrome: "CIPhotoEffectChrome"
        case .portra: "CIPhotoEffectTransfer"
        case .trix: "CIPhotoEffectNoir"
        }
    }

    func develop(_ image: CIImage) -> CIImage {
        image
            .applyingFilter(effectName)
            .applyingFilter("CIVignette", parameters: [kCIInputIntensityKey: 0.9, kCIInputRadiusKey: 1.5])
            .cropped(to: image.extent)
    }
}
