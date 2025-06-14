import SwiftUI

struct OnboardingView: View {
    @StateObject private var coordinator = OnboardingCoordinator()

    var body: some View {
        VStack {
            switch coordinator.step {
            case .age:
                AgeStepView(coordinator: coordinator)
                    .transition(.slide)
            case .gender:
                GenderStepView(coordinator: coordinator)
                    .transition(.slide)
            case .height:
                HeightStepView(coordinator: coordinator)
                    .transition(.slide)
            case .weight:
                WeightStepView(coordinator: coordinator)
                    .transition(.slide)
            case .goal:
                GoalStepView(coordinator: coordinator)
                    .transition(.slide)
            case .activity:
                ActivityStepView(coordinator: coordinator)
                    .transition(.slide)
            case .dietaryPrefs:
                DietaryStepView(coordinator: coordinator)
                    .transition(.slide)
            case .glp1:
                GLP1StepView(coordinator: coordinator)
                    .transition(.slide)
            case .coachPersonality:
                CoachPersonalityStepView(coordinator: coordinator)
                    .transition(.slide)
            case .healthKit:
                HealthKitStepView(coordinator: coordinator)
                    .transition(.slide)
            }
        }
        .animation(.easeInOut, value: coordinator.step)
        .padding()
    }
}

private struct AgeStepView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    var body: some View {
        VStack(spacing: 20) {
            Text("What's your age?")
                .font(.title)
            TextField("Age", text: $coordinator.age)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            if let error = coordinator.error {
                Text(error).foregroundColor(.red)
            }
            HStack {
                Spacer()
                Button("Next") { coordinator.next() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

private struct GenderStepView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    var body: some View {
        VStack(spacing: 20) {
            Text("Select your gender")
                .font(.title)
            Picker("Gender", selection: $coordinator.gender) {
                Text("Male").tag("Male")
                Text("Female").tag("Female")
                Text("Other").tag("Other")
            }
            .pickerStyle(.segmented)
            if let error = coordinator.error {
                Text(error).foregroundColor(.red)
            }
            HStack {
                Button("Back") { coordinator.back() }
                Spacer()
                Button("Next") { coordinator.next() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

private struct HeightStepView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter your height (cm)")
                .font(.title)
            TextField("Height", text: $coordinator.height)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            if let error = coordinator.error {
                Text(error).foregroundColor(.red)
            }
            HStack {
                Button("Back") { coordinator.back() }
                Spacer()
                Button("Next") { coordinator.next() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

private struct WeightStepView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter your weight (kg)")
                .font(.title)
            TextField("Weight", text: $coordinator.weight)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            if let error = coordinator.error {
                Text(error).foregroundColor(.red)
            }
            HStack {
                Button("Back") { coordinator.back() }
                Spacer()
                Button("Next") { coordinator.next() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

private struct GoalStepView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    var body: some View {
        VStack(spacing: 20) {
            Text("What's your primary goal?")
                .font(.title)
            TextField("Goal", text: $coordinator.goal)
                .textFieldStyle(.roundedBorder)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            if let error = coordinator.error {
                Text(error).foregroundColor(.red)
            }
            HStack {
                Button("Back") { coordinator.back() }
                Spacer()
                Button("Next") { coordinator.next() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

private struct ActivityStepView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    var body: some View {
        VStack(spacing: 20) {
            Text("Describe your activity level")
                .font(.title)
            TextField("Activity Level", text: $coordinator.activityLevel)
                .textFieldStyle(.roundedBorder)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            if let error = coordinator.error {
                Text(error).foregroundColor(.red)
            }
            HStack {
                Button("Back") { coordinator.back() }
                Spacer()
                Button("Next") { coordinator.next() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

private struct DietaryStepView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    var body: some View {
        VStack(spacing: 20) {
            Text("Dietary preferences")
                .font(.title)
            TextField("Dietary Preferences", text: $coordinator.dietaryPrefs)
                .textFieldStyle(.roundedBorder)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            if let error = coordinator.error {
                Text(error).foregroundColor(.red)
            }
            HStack {
                Button("Back") { coordinator.back() }
                Spacer()
                Button("Next") { coordinator.next() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

private struct GLP1StepView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    var body: some View {
        VStack(spacing: 20) {
            Toggle("Are you using GLP-1 medication?", isOn: $coordinator.usesGLP1)
                .toggleStyle(.switch)
            if let error = coordinator.error {
                Text(error).foregroundColor(.red)
            }
            HStack {
                Button("Back") { coordinator.back() }
                Spacer()
                Button("Next") { coordinator.next() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

private struct CoachPersonalityStepView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    var body: some View {
        VStack(spacing: 20) {
            Text("Preferred coach personality")
                .font(.title)
            Picker("Coach Style", selection: $coordinator.coachPersonality) {
                Text("Encouraging").tag("Encouraging")
                Text("Tough Love").tag("ToughLove")
                Text("Balanced").tag("Balanced")
            }
            .pickerStyle(.segmented)
            if let error = coordinator.error {
                Text(error).foregroundColor(.red)
            }
            HStack {
                Button("Back") { coordinator.back() }
                Spacer()
                Button("Finish") { coordinator.next() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

private struct HealthKitStepView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    var body: some View {
        VStack(spacing: 20) {
            Text("Sync with HealthKit?")
                .font(.title)
            Text("Apex uses your step, workout, sleep and hydration data to personalize your plan.")
                .multilineTextAlignment(.center)
            Toggle("Enable HealthKit Sync", isOn: $coordinator.enableHealthKit)
            Button("Continue") {
                if coordinator.enableHealthKit {
                    HealthKitService.shared.requestAuthorization()
                }
                coordinator.next()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    OnboardingView()
        .environment(\.managedObjectContext, CoreDataStack.shared.context)
}
