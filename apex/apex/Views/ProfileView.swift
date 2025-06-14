import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var formData = UserProfileModel()

    var body: some View {
        VStack(spacing: 20) {
            if let profile = viewModel.profile {
                Form {
                    Section("Basics") {
                        TextField("Name", text: $formData.name)
                            .textFieldStyle(.roundedBorder)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        TextField("Age", value: $formData.age, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        TextField("Gender", text: $formData.gender)
                            .textFieldStyle(.roundedBorder)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    Section("Metrics") {
                        TextField("Height", value: $formData.height, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                        TextField("Starting Weight", value: $formData.startingWeight, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                        TextField("Current Weight", value: $formData.currentWeight, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                        TextField("Goal Weight", value: $formData.goalWeight, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                        TextField("Body Fat %", value: $formData.bodyFatPercentage, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    }
                    Section("Preferences") {
                        TextField("Activity Level", text: $formData.activityLevel)
                        Toggle("Using GLP-1 Medication", isOn: $formData.usesGLP1)
                        TextField("Dietary Preferences", text: $formData.dietaryPreferences)
                        TextField("Coach Personality", text: $formData.coachType)
                    }
                }
                .onAppear {
                    formData = profile.toModel()
                }
                Button("Save") {
                    viewModel.updateProfile(with: formData)
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("No profile available")
            }
        }
        .padding()
    }
}

#Preview {
    ProfileView()
        .environment(\.managedObjectContext, CoreDataStack.shared.context)
}
