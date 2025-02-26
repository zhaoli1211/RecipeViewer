### Summary: 
Recipe Viewer:
![Simulator Screenshot - iPhone 16 - 2025-02-25 at 15 33 58](https://github.com/user-attachments/assets/6a1007e9-1c0d-4999-ac87-3d987d6de4df)

Empty Data:
![Simulator Screenshot - iOS 16 pro - 2025-02-25 at 09 53 40](https://github.com/user-attachments/assets/f26c5c50-be53-4321-9da6-c53edf49cc9d)

Malformed Data:
![Simulator Screenshot - iOS 16 pro - 2025-02-25 at 09 53 58](https://github.com/user-attachments/assets/ceb16dd0-e410-480d-8e67-8e86248fc311)


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I focused on image loading area of this project

Network Efficiency:

Small image URLs and optimized image sizes reduce the amount of data transferred over the network, which is especially important for users on limited or slow connections.

Efficient image loading minimizes latency, ensuring a smoother user experience.

Reduced Redundant Downloads:

Caching images in memory (RAM) and on disk prevents the need to repeatedly download the same image, saving bandwidth and reducing load times for frequently accessed content.

Improved Responsiveness:

By loading images asynchronously and caching them, the app remains responsive, even when dealing with large or numerous images.

Battery and Resource Optimization:

Reducing network requests and CPU usage for image decoding contributes to better battery life and overall device performance, particularly on mobile devices.

User Experience:

Fast image loading and seamless transitions between screens enhance user satisfaction and engagement, which are critical for app retention and success.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
Total: ~5 hours

ListView: ~ 1 hour

NetWork Service: ~ 1 hour

Image Loading Service: ~ 2 hours

Unit tests: 1.5 hours


### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

I didn't spent too much time to design the network fetching service

Hardcoding URLs and tightly coupling the decoder allowed me to focus on core features (e.g., image loading and caching) without getting bogged down by infrastructure concerns.
I prioritized the core features (image loading and caching) that directly impact user experience and app performance.

### Weakest Part of the Project: What do you think is the weakest part of your project?
Network fetching:
Missing:
Abstract the Network Layer:

A reusable NetworkService class that handles all network requests, error handling, and caching.

Decouple URLs and Decoders:

Store URLs in a configuration file and move decoding logic into separate functions or classes.

Add Error Handling and Logging:

Implement centralized error handling and logging to improve reliability and make debugging easier.

Introduce Caching:

In-memory and disk caching to reduce redundant network requests and improve performance.
