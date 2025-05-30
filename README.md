# 🍽️ AI-Powered Recipe App from Photos

Snap a photo of your ingredients and get smart recipe suggestions powered by image recognition and AI. It’s your personal kitchen assistant that turns your fridge contents into gourmet meals.

## 📘 Project Description

This iOS app uses Vision and CoreML to identify ingredients from a photo, then calls the Spoonacular API to fetch recipes based on the recognized ingredients. Future updates plan to include GPT-powered cooking tips.

## 🧰 Tech Stack

- Swift
- SwiftUI
- CoreML (MobileNetV2)
- Vision Framework
- Spoonacular REST API
- OpenAI GPT API (planned)
- UIKit (ImagePicker integration)

## 🚀 Features

- Identify ingredients from a photo using CoreML
- Fetch relevant recipes from Spoonacular
- Beautiful SwiftUI interface
- Option to integrate ChatGPT cooking assistant

## 🧑‍💻 How to Run

1. **Requirements:**
   - Xcode 14 or higher
   - iOS 15+
   - Real iPhone for camera access

2. **Steps:**
   - Clone this repo:
     ```bash
     git clone https://github.com/yourusername/ai-recipe-app-from-photos-swift.git
     ```
   - Open in Xcode and insert your Spoonacular API key.
   - Add `MobileNetV2.mlmodel` to your Xcode project.
   - Build and run on a real device.

3. **Usage:**
   - Select a photo of ingredients using the app.
   - Wait for recognition and tap “Get Recipes.”
   - Browse recipes and enjoy cooking!

## ✅ Sample Output

- Ingredients detected: Tomato, Onion, Garlic
- Recipes suggested: Tomato Soup, Garlic Pasta, Spicy Onion Rings
