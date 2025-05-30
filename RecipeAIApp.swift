import SwiftUI
import Vision
import CoreML
import Foundation

class IngredientRecognizer: ObservableObject {
    @Published var recognizedIngredients: [String] = []

    func recognizeIngredients(from image: UIImage) {
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else { return }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            DispatchQueue.main.async {
                self.recognizedIngredients = results.prefix(5).map { $0.identifier }
            }
        }

        guard let cgImage = image.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}

class RecipeFetcher: ObservableObject {
    @Published var recipes: [String] = []

    func fetchRecipes(ingredients: [String]) {
        let ingredientsList = ingredients.joined(separator: ",")
        guard let url = URL(string: "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(ingredientsList)&number=5&apiKey=YOUR_SPOONACULAR_API_KEY") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            if let result = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                DispatchQueue.main.async {
                    self.recipes = result.compactMap { $0["title"] as? String }
                }
            }
        }.resume()
    }
}

struct ContentView: View {
    @StateObject private var recognizer = IngredientRecognizer()
    @StateObject private var fetcher = RecipeFetcher()
    @State private var image: UIImage?
    @State private var isPickerPresented = false

    var body: some View {
        VStack(spacing: 20) {
            Text("🍳 AI-Powered Recipe App").font(.largeTitle)

            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }

            Button("Select Ingredient Photo") {
                isPickerPresented = true
            }

            if !recognizer.recognizedIngredients.isEmpty {
                Text("Recognized Ingredients:")
                ForEach(recognizer.recognizedIngredients, id: \.self) { ingredient in
                    Text("• \(ingredient)")
                }
            }

            Button("Get Recipes") {
                fetcher.fetchRecipes(ingredients: recognizer.recognizedIngredients)
            }

            if !fetcher.recipes.isEmpty {
                Text("Suggested Recipes:")
                ForEach(fetcher.recipes, id: \.self) { recipe in
                    Text("✅ \(recipe)")
                }
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(image: $image, onImagePicked: { img in
                recognizer.recognizeIngredients(from: img)
            })
        }
        .padding()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onImagePicked: (UIImage) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.onImagePicked(uiImage)
            }
            picker.dismiss(animated: true)
        }
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

@main
struct RecipeAIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
