import AVFoundation
import CoreImage
import Photos
import UIKit

final class CameraModel: NSObject, ObservableObject {
    @Published private(set) var preview: CGImage?
    @Published private(set) var lastShot: UIImage?
    @Published private(set) var frameCount = 0
    @Published private(set) var permissionDenied = false
    @Published var film: FilmStock = .chrome {
        didSet { let film = film; videoQueue.async { self.activeFilm = film } }
    }

    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "retrocam.session")
    private let videoQueue = DispatchQueue(label: "retrocam.video")
    private let ciContext = CIContext()
    private var activeFilm: FilmStock = .chrome

    func start() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else {
                DispatchQueue.main.async { self.permissionDenied = true }
                return
            }
            self.sessionQueue.async { self.configureAndRun() }
        }
    }

    func shoot() {
        sessionQueue.async {
            guard self.session.isRunning else { return }
            if let connection = self.photoOutput.connection(with: .video), connection.isVideoRotationAngleSupported(90) {
                connection.videoRotationAngle = 90
            }
            self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }

    private func configureAndRun() {
        if session.inputs.isEmpty {
            session.beginConfiguration()
            session.sessionPreset = .photo
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: device),
                  session.canAddInput(input),
                  session.canAddOutput(photoOutput),
                  session.canAddOutput(videoOutput)
            else {
                session.commitConfiguration()
                return
            }
            session.addInput(input)
            session.addOutput(photoOutput)
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
            session.addOutput(videoOutput)
            if let connection = videoOutput.connection(with: .video), connection.isVideoRotationAngleSupported(90) {
                connection.videoRotationAngle = 90
            }
            session.commitConfiguration()
        }
        session.startRunning()
    }

    private func saveToPhotos(_ jpeg: Data) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else { return }
            PHPhotoLibrary.shared().performChanges {
                PHAssetCreationRequest.forAsset().addResource(with: .photo, data: jpeg, options: nil)
            }
        }
    }
}

extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let frame = CIImage(cvPixelBuffer: buffer)
        let scale = min(1, 1080 / frame.extent.width)
        let developed = activeFilm.develop(frame.transformed(by: CGAffineTransform(scaleX: scale, y: scale)))
        guard let image = ciContext.createCGImage(developed, from: developed.extent) else { return }
        DispatchQueue.main.async { self.preview = image }
    }
}

extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let negative = CIImage(data: data, options: [.applyOrientationProperty: true]),
              let sRGB = CGColorSpace(name: CGColorSpace.sRGB)
        else { return }
        let film = videoQueue.sync { activeFilm }
        guard let jpeg = ciContext.jpegRepresentation(of: film.develop(negative), colorSpace: sRGB) else { return }
        saveToPhotos(jpeg)
        DispatchQueue.main.async {
            self.frameCount += 1
            self.lastShot = UIImage(data: jpeg)
        }
    }
}
