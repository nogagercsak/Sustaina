//
//  ScannerView.swift
//  Sustaina
//
//  Created by Noga Gercsak on 1/22/25.
//

import SwiftUI
import AVFoundation

struct ScannerView: View {
    @StateObject private var viewModel = ScannerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                CameraPreview(session: viewModel.session)
                    .frame(height: 400)
                    .cornerRadius(12)
                    .padding()
                
                if let classification = viewModel.classification {
                    RecyclingGuideView(classification: classification)
                } else {
                    Text("Point the camera at an item to identify its recyclability.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Button(action: viewModel.captureImage) {
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.green)
                }
                .padding(.top, 20)
            }
            .navigationTitle("AI Waste Scanner")
            .onAppear {
                viewModel.startSession()
            }
            .onDisappear {
                viewModel.stopSession()
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            return AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    let session: AVCaptureSession

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {}
}

class ScannerViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session: AVCaptureSession = AVCaptureSession()
    @Published var classification: WasteClassification?
    private let captureOutput = AVCapturePhotoOutput()
    private let queue = DispatchQueue(label: "camera-queue")

    override init() {
        super.init()
        setupCamera()
    }

    func setupCamera() {
        session.beginConfiguration()

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Unable to access back camera!")
            session.commitConfiguration()
            return
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
        } catch {
            print("Error setting up video input: \(error)")
        }

        if session.canAddOutput(captureOutput) {
            session.addOutput(captureOutput)
        }

        session.commitConfiguration()
    }

    func startSession() {
        queue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    func stopSession() {
        queue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    func captureImage() {
        let settings = AVCapturePhotoSettings()
        captureOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Unable to process photo data")
            return
        }

        classifyImage(image)
    }

    private func classifyImage(_ image: UIImage) {
        // Placeholder for AI-based image classification logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.classification = WasteClassification(type: .recyclable, details: "Plastic Bottle")
        }
    }
}
