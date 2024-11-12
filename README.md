# Image Capture and Upload App - Approach and Methodology

## Overview
This app enables users to capture images, store them locally, and upload them with real-time progress tracking. Key features include capturing images from a live camera feed, storing image metadata in a local database, tracking upload progress, and notifying users when uploads complete. The app architecture is designed to be modular, user-friendly, and responsive.

## Architecture

### 1. Camera Integration:
- **Purpose**: Captures images from the device camera, storing them temporarily before saving them to a local database.
- **Approach**: Utilizes a central controller to manage permissions, session setup, and capture functions. The camera feed is displayed live in the app, allowing users to preview before capture.

### 2. Local Database:
- **Purpose**: Provides persistent storage of captured image metadata, including image name, capture date, and upload status.
- **Approach**: Stores images locally and efficiently handles metadata, allowing users to see an organized list of images with their capture and upload details.

### 3. Upload Management:
- **Purpose**: Manages the uploading of images to a server, tracking and updating the upload status in real time.
- **Approach**: Supports background uploads so the app remains responsive. Upload progress and completion status are updated dynamically, even allowing users to resume interrupted uploads.

### 4. User Interface (UI):
- **Purpose**: Displays the camera feed, captured images, and upload status with a user-friendly interface.
- **Approach**: Uses a simple and clear design to show images in a list format, with each entry displaying a thumbnail, progress bar, and upload status.

### 5. User Notifications:
- **Purpose**: Provides feedback to users, keeping them informed about upload status and completion.
- **Approach**: Sends local notifications upon upload completion to keep users engaged and updated, even if they’re not actively using the app.

## Tools Used
- **Realm**: A local database solution for storing image metadata and tracking upload progress.
- **URLSession**: Manages image uploads in the background, ensuring the app remains responsive during uploads.
- **AVFoundation**: Captures images from the device camera, allowing users to view a live camera feed.
- **SwiftUI**: Creates a reactive, user-friendly interface that responds to real-time data updates.
- **UserNotifications**: Sends notifications to users when uploads complete, enhancing user experience.

## Challenges Faced

### 1. Managing Multiple Camera Sessions:
- Ensuring only one active camera session was crucial to avoid conflicts that could cause the app to crash or behave unexpectedly. A centralized controller approach was implemented to manage the session efficiently.

### 2. Camera Feed Visibility:
- There were issues with displaying the camera feed reliably. Additional configuration and debugging of the live preview layer were necessary to ensure that the feed rendered correctly on different devices.

### 3. Handling Color Space Warnings:
- Encountered warnings related to unsupported color spaces on certain devices. These warnings were handled by adjusting configurations where possible and confirming they didn’t impact functionality.

### 4. Maintaining Upload Progress in Real-Time:
- Achieving real-time feedback for upload progress required careful coordination between the local database, background upload management, and the UI.

### 5. Resuming Failed Uploads:
- Implemented logic to allow users to retry uploads for images that failed due to connectivity or other issues. This ensured a smoother experience by allowing uploads to resume automatically or with minimal user intervention.

## Key Design Decisions
- **Centralized Camera Controller**: Using a single controller to manage camera sessions prevented conflicts and ensured reliable session handling.
- **Background Uploads for Responsiveness**: Background upload management allowed the app to handle large files without blocking the main interface, providing a seamless experience.
- **Real-Time UI Feedback**: Dynamic UI updates allowed users to see progress and receive notifications, making the app engaging and responsive.

## Conclusion
This app combines camera capture, local storage, upload management, and user notifications in a cohesive solution. By addressing key challenges in camera session management, upload progress tracking, and user feedback, the app provides an efficient and user-friendly experience. The modular architecture also makes it adaptable.
