import UIKit
import AVFoundation
import Vision
import CoreML

// Delegate protocol passes detected trash items and debug info.
protocol CameraViewControllerDelegate: AnyObject {
    func cameraViewController(_ controller: CameraViewController,
                              didDetectTrashItems items: [String],
                              debugInfo: String)
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    weak var delegate: CameraViewControllerDelegate?
    
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var visionRequest: VNCoreMLRequest?
    private var visionModel: VNCoreMLModel?
    
    // List of valid trash items the app can detect.
    private let validTrashLabels = [
        "bottle",
        "wine glass",
        "cup",
        "can",
        "fork",
        "knife",
        "spoon",
        "bowl",
        "wrapper",
        "plastic bag",
        "paper",
        "straw",
        "aluminum foil",
        "banana",
        "apple",
        "sandwich",
        "orange",
        "broccoli",
        "carrot",
        "hot dog",
        "pizza",
        "donut",
        "cake"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    // MARK: - Setup Model
    private func setupModel() {
        // Load the YOLOv3 model.
        guard let yoloModel = try? YOLOv3(configuration: MLModelConfiguration()).model,
              let visionModel = try? VNCoreMLModel(for: yoloModel) else {
            fatalError("Failed to load YOLOv3 model")
        }
        self.visionModel = visionModel
        
        visionRequest = VNCoreMLRequest(model: visionModel, completionHandler: { [weak self] request, error in
            self?.processDetections(for: request, error: error)
        })
        visionRequest?.imageCropAndScaleOption = .scaleFill
    }
    
    // MARK: - Setup Camera
    private func setupCamera() {
        captureSession.sessionPreset = .high
        
        // Configure camera input.
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("Failed to get video device")
            return
        }
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        // Configure video output.
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        // Setup preview layer.
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Start the camera session on a background thread.
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    // MARK: - Process Detections
    private func processDetections(for request: VNRequest, error: Error?) {
        var debugInfo = ""
        var detectedTrashSet = Set<String>()
        
        guard let results = request.results as? [VNRecognizedObjectObservation] else {
            debugInfo = "No results. Error: \(error?.localizedDescription ?? "Unknown error")"
            delegate?.cameraViewController(self, didDetectTrashItems: [], debugInfo: debugInfo)
            return
        }
        
        for observation in results {
            if let topLabel = observation.labels.first, topLabel.confidence > 0.2 {
                let identifier = topLabel.identifier.lowercased()
                // Check if the identifier matches one of the valid trash labels.
                for trash in validTrashLabels {
                    if identifier.contains(trash) {
                        detectedTrashSet.insert(trash)
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.delegate?.cameraViewController(self,
                                               didDetectTrashItems: Array(detectedTrashSet),
                                               debugInfo: "Detection running")
        }
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let visionRequest = visionRequest,
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
        do {
            try handler.perform([visionRequest])
        } catch {
            print("Vision error: \(error)")
        }
    }
}
