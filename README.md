# EcoRangers

EcoRangers is an interactive augmented reality game that uses machine learning and your device's camera to detect trash in real time, challenge you to "pick" up items, and deliver eye-opening, disturbing facts about waste and its environmental impact. By merging cutting-edge technology with environmental education, EcoRangers transforms everyday surroundings into an engaging learning experience.

---
![IMG_0669](https://github.com/user-attachments/assets/8b6b0a43-0ecf-422b-adce-8ece89e20dd6) ![IMG_0668](https://github.com/user-attachments/assets/c726ac3d-5e6f-43f5-944f-164375e08f42)

![IMG_0671](https://github.com/user-attachments/assets/4fedeaf9-d2c0-43f0-bf1b-4f5da235d1e4)
![IMG_0670](https://github.com/user-attachments/assets/a6f4b025-1357-494a-b521-e68f02c2aa48)


## Inspiration

EcoRangers was born from a passion for environmental stewardship and the desire to make learning about waste both fun and impactful. The idea came from recognizing the power of interactive technologies to raise awareness about recycling and sustainability, inspiring users to be more mindful of their environment.

---

## What It Does

EcoRangers uses your device’s camera along with machine learning to identify trash items in real time. When a trash item is detected, players have the opportunity to "pick" the item, triggering the app to overlay a disturbing environmental fact on a snapshot of the scene. This not only educates players on the consequences of waste but also rewards them with a scoring system that tracks their progress throughout the game.

---

## How We Built It

We built EcoRangers by combining several key iOS frameworks and technologies:
- **Vision & Core ML:** For real-time object detection, we integrated Apple's Vision framework with a YOLOv3 Core ML model to accurately detect trash items.
- **UIKit & SwiftUI:** The core camera and game logic is implemented in a UIKit-based `CameraViewController` that handles real-time video capture and processing. This controller is then wrapped in a SwiftUI view using `UIViewControllerRepresentable` for a modern, reactive interface.
- **Augmented Reality Overlays:** When a player picks a detected trash item, the app captures a screenshot of the current view, overlays a randomly selected disturbing fact from a pre-defined list, and displays the annotated image as a full-screen overlay.
- **Networking (Future Integration):** Although the current version uses a local dictionary of facts, the architecture is designed to support future integration with external APIs for dynamic content updates.

---

## Challenges We Ran Into

During development, we encountered several technical challenges:
- **Real-Time Object Detection:** Ensuring that the YOLOv3 model performed accurately and efficiently on a range of devices was challenging, particularly in diverse lighting conditions.
- **UI and Performance Optimization:** Integrating live video feed processing with smooth UI updates required careful optimization to avoid lag and ensure a seamless user experience.
- **Overlay Accuracy:** Positioning and rendering the text overlay on the live camera feed, without obstructing important details, was a nuanced task that involved fine-tuning the graphics rendering process.
- **Framework Integration:** Bridging the gap between UIKit and SwiftUI, especially when passing data and maintaining a responsive interface, involved thoughtful architectural decisions.

---

## Accomplishments That We're Proud Of

- **Seamless Integration:** Successfully merged real-time machine learning detection with a modern SwiftUI interface, creating a smooth and engaging augmented reality experience.
- **Educational Impact:** Developed a unique approach to environmental education by pairing interactive gameplay with impactful environmental facts.
- **Robust Performance:** Overcame performance hurdles to deliver an app that works efficiently across a variety of iOS devices, ensuring real-time responsiveness and smooth visual overlays.
- **User Engagement:** Designed an intuitive and fun user interface that not only entertains but also educates, promoting awareness of environmental issues.

---

## What We Learned

Through building EcoRangers, we deepened our understanding of:
- **Machine Learning on Mobile:** Integrating Core ML models and optimizing them for real-time object detection.
- **UI Framework Integration:** Seamlessly combining UIKit and SwiftUI, learning the best practices for data sharing and performance tuning between the two.
- **Augmented Reality Design:** Implementing dynamic overlays on live video feeds and ensuring that such overlays are both visually appealing and non-intrusive.
- **Problem-Solving:** Tackling real-world challenges such as low-light conditions, variable object sizes, and performance constraints on mobile devices.

---

## What's Next for EcoRangers

Our roadmap for future updates includes:
- **Expanded Fact Database:** Integrating a broader range of disturbing facts for each trash type, possibly through dynamic content pulled from an external API.
- **Enhanced Object Detection:** Upgrading our model and refining detection algorithms to improve accuracy and expand the variety of trash items recognized.
- **Multiplayer and Social Features:** Introducing competitive and cooperative game modes to boost engagement and promote community involvement in environmental efforts.
- **Additional Gamification Elements:** Incorporating new levels, rewards, and challenges to enrich the gaming experience and further motivate players to act sustainably.

---

## Getting Started

### Prerequisites

- **Xcode 12 or later**: Ensure you have the latest version of Xcode installed.
- **iOS 14 or later**: The app is built for modern iOS devices.
- **A physical iOS device**: For camera functionality and real-time object detection, testing on a real device is recommended.

### Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/EcoRangers.git
   cd EcoRangers
Open the Project in Xcode:

bash
Copy
open EcoRangers.xcodeproj
Build and Run:

Select your target device or simulator (a physical device is recommended for full functionality).

Click on the Run button in Xcode or press Cmd + R.

Project Structure
CameraViewController.swift: Contains the UIKit-based camera view controller that handles video capture, object detection with Vision and Core ML, and the overlay display of disturbing facts.

ContentView.swift: Implements the SwiftUI interface that integrates the camera view controller using UIViewControllerRepresentable, and displays game-related information such as score and detected trash items.

Assets & Resources: Include the necessary assets, such as icons and UI elements, required for the app interface.

License
Distributed under the MIT License. See LICENSE for more information.

Acknowledgements
Apple Developer Documentation: For comprehensive guides on Vision, Core ML, UIKit, and SwiftUI.

Community Contributions: Thanks to the open source community for sample projects, tutorials, and valuable discussions that helped shape EcoRangers.

Environmental Organizations: Inspiration and ongoing commitment to promoting sustainability and environmental awareness.

vbnet
Copy

This detailed README can be directly copied into your project repository to provide an in-depth overview and setup instructions for EcoRangers.
