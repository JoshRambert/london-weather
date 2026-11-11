import SwiftUI

struct HomeHostingView: View {
    @State private var viewModel: HomeViewModel

    init(store: Store, weatherService: any WeatherService) {
        _viewModel = State(initialValue: HomeViewModel(store: store, weatherService: weatherService))
    }

    var body: some View {
        HomeView(viewModel: viewModel)
    }
}

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                loadingState
            case .loaded(let resolvedAddress, let currentConditions):
                loadedState(resolvedAddress: resolvedAddress, currentConditions: currentConditions)
            case .error:
                EmptyView()
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            await viewModel.loadCurrentWeather()
        }
    }

    private var loadingState: some View {
        VStack(spacing: 12) {
            ProgressView()
                .controlSize(.large)
            Text("Loading")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }

    private func loadedState(
        resolvedAddress: String,
        currentConditions: CurrentConditionsDetails
    ) -> some View {
        VStack(spacing: 28) {
            Text(resolvedAddress)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            currentConditionsContainer(currentConditions)
        }
    }

    private func currentConditionsContainer(_ currentConditions: CurrentConditionsDetails) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            conditionLine(label: "Temperature", value: currentConditions.temperature, prominent: true)
            conditionLine(label: "Feels like", value: currentConditions.feelsLikeTemperature)
            conditionLine(label: "Conditions", value: currentConditions.conditions)
            conditionLine(label: "Wind", value: currentConditions.windSpeed)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        }
    }

    private func conditionLine(label: String, value: String, prominent: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(prominent ? .title.weight(.semibold) : .body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    let store = Store(route: .homeView)
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(
                store: store,
                weatherService: LiveWeatherService()
            )
        )
    }
}
