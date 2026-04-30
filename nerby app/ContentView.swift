//
//  ContentView.swift
//  nerby app
//
//  Created by office on 28/04/2026.
//

import SwiftUI
import Combine

enum UserMode: String, CaseIterable, Identifiable {
    case seeker
    case provider

    var id: String { rawValue }

    var title: String {
        switch self {
        case .seeker: return "Hľadám pomoc"
        case .provider: return "Ponúkam služby"
        }
    }

    var icon: String {
        switch self {
        case .seeker: return "magnifyingglass"
        case .provider: return "wrench.and.screwdriver"
        }
    }
}

enum ServiceCategory: String, CaseIterable, Identifiable {
    case repairs = "Opravy"
    case it = "IT"
    case auto = "Auto"
    case home = "Domácnosť"
    case beauty = "Beauty"
    case other = "Iné"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .repairs: return "hammer"
        case .it: return "desktopcomputer"
        case .auto: return "car"
        case .home: return "house"
        case .beauty: return "sparkles"
        case .other: return "ellipsis.circle"
        }
    }
}

struct Provider: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let category: ServiceCategory
    let headline: String
    let bio: String
    let distance: String
    let responseTime: String
    let rating: String
    let reviewCount: Int
    let price: String
    let online: Bool
    let verified: Bool
    let services: [String]
    let gallery: [String]
}

struct ServiceRequest: Identifiable {
    let id = UUID()
    let title: String
    let category: ServiceCategory
    let distance: String
    let priority: String
    let detail: String
    let time: String
}

struct ChatThread: Identifiable {
    let id = UUID()
    let name: String
    let preview: String
    let time: String
    let unread: Bool
    let status: String
}

struct ActivityItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let status: String
    let icon: String
}

final class AppState: ObservableObject {
    @Published var onboarded = false
    @Published var loggedIn = false
    @Published var mode: UserMode = .seeker
    @Published var available = true
    @Published var selectedCategory: ServiceCategory = .repairs
    @Published var urgent = false
    @Published var problemText = ""
    @Published var serviceRadius = 5.0
    @Published var showOnlyWhenOnline = true

    let providers: [Provider] = [
        .init(
            name: "Marek Kováč",
            imageName: "profile-marek",
            category: .repairs,
            headline: "Hodinový majster a rýchle opravy",
            bio: "Pomáham s drobnými opravami v byte, montážou nábytku, batériami, dverami a urgentnými poruchami. Prídem s vlastným náradím.",
            distance: "650 m",
            responseTime: "odpoveď do 4 min",
            rating: "4,9",
            reviewCount: 128,
            price: "od 20 €",
            online: true,
            verified: true,
            services: ["Vodovodné batérie", "Montáž políc", "Oprava dverí", "Nábytok IKEA"],
            gallery: ["Kuchyňa", "Kúpeľňa", "Náradie"]
        ),
        .init(
            name: "Lucia Poláková",
            imageName: "profile-lucia",
            category: .it,
            headline: "IT pomoc pre Mac, iPhone a Wi-Fi",
            bio: "Riešim pomalé notebooky, nastavenie Wi-Fi, zálohy, tlačiarne a prenos dát. Vysvetľujem jednoducho a bez stresu.",
            distance: "1,2 km",
            responseTime: "odpoveď do 7 min",
            rating: "4,8",
            reviewCount: 92,
            price: "od 25 €",
            online: true,
            verified: true,
            services: ["Wi-Fi", "MacBook", "iPhone", "Tlačiarne"],
            gallery: ["Notebook", "Router", "Záloha"]
        ),
        .init(
            name: "Tomáš Varga",
            imageName: "profile-tomas",
            category: .auto,
            headline: "Auto pomoc v okolí",
            bio: "Pomôžem s defektom, batériou, výmenou žiaroviek a základnou diagnostikou. Dostupný najmä poobede a večer.",
            distance: "2,1 km",
            responseTime: "odpoveď do 12 min",
            rating: "4,7",
            reviewCount: 64,
            price: "od 30 €",
            online: false,
            verified: false,
            services: ["Defekt", "Batéria", "Diagnostika", "Žiarovky"],
            gallery: ["Servis", "Koleso", "Diagnostika"]
        )
    ]

    let nearbyRequests: [ServiceRequest] = [
        .init(title: "Tečie sifón pod umývadlom", category: .repairs, distance: "700 m", priority: "Urgentné", detail: "Potrebujem niekoho dnes, voda kvapká do skrinky.", time: "pred 2 min"),
        .init(title: "Notebook sa prehrieva", category: .it, distance: "1,1 km", priority: "Normálne", detail: "MacBook je pomalý a ventilátor beží stále.", time: "pred 9 min"),
        .init(title: "Defekt na parkovisku", category: .auto, distance: "1,8 km", priority: "Urgentné", detail: "Mám rezervu, potrebujem pomoc s výmenou.", time: "pred 14 min")
    ]

    let chats: [ChatThread] = [
        .init(name: "Marek Kováč", preview: "Viem prísť o 18:20, pošlite mi fotku sifónu.", time: "teraz", unread: true, status: "Dohadovanie"),
        .init(name: "Lucia Poláková", preview: "Najprv skúsime zálohu a potom diagnostiku.", time: "12:08", unread: false, status: "Aktívne"),
        .init(name: "Tomáš Varga", preview: "Som dnes offline, zajtra viem pomôcť.", time: "včera", unread: false, status: "Ukončené")
    ]

    let activities: [ActivityItem] = [
        .init(title: "Dopyt odoslaný", subtitle: "Tečie sifón pod umývadlom", status: "Čaká na odpoveď", icon: "paperplane"),
        .init(title: "Provider na ceste", subtitle: "Marek Kováč, približne 650 m", status: "Na ceste", icon: "figure.walk"),
        .init(title: "Stretnutie ukončené", subtitle: "IT pomoc pre Wi-Fi", status: "Ohodnotiť", icon: "checkmark.circle")
    ]
}

enum NerbyTheme {
    static let background = Color.white
    static let secondaryBackground = Color(red: 0.965, green: 0.965, blue: 0.965)
    static let surface = Color.white
    static let ink = Color.black
    static let muted = Color(red: 0.42, green: 0.42, blue: 0.42)
    static let line = Color(red: 0.88, green: 0.88, blue: 0.88)
    static let accent = Color.black
    static let accentPressed = Color(red: 0.12, green: 0.12, blue: 0.12)
    static let success = Color.black
    static let warm = Color(red: 0.32, green: 0.32, blue: 0.32)
    static let radius: CGFloat = 18
    static let compactRadius: CGFloat = 12
}

struct RootView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        Group {
            if !state.onboarded {
                OnboardingView()
            } else if !state.loggedIn {
                AuthView()
            } else {
                MainTabsView()
            }
        }
        .preferredColorScheme(.light)
    }
}

struct OnboardingView: View {
    @EnvironmentObject private var state: AppState
    @State private var page = 0

    private let pages: [(title: String, subtitle: String, icon: String)] = [
        ("Pomoc nablízku", "Zadaj problém a Nerby ti ukáže ľudí v okolí, ktorí ho vedia vyriešiť osobne.", "location.circle"),
        ("Rýchle spojenie", "Pozri si profil, hodnotenia a služby. Potom napíš alebo zavolaj priamo z appky.", "bubble.left.and.bubble.right"),
        ("Stretnutie tvárou v tvár", "Provider si zapne dostupnosť, keď je v meste. Ty vidíš len ľudí, ktorí dávajú zmysel pre tvoj problém.", "person.2")
    ]

    var body: some View {
        ZStack {
            NerbyTheme.background.ignoresSafeArea()
            VStack(spacing: 28) {
                HStack {
                    brandMark
                    Spacer()
                    Text("\(page + 1)/3")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(NerbyTheme.muted)
                }

                Spacer(minLength: 16)

                Image(systemName: pages[page].icon)
                    .font(.system(size: 76, weight: .light))
                    .foregroundStyle(NerbyTheme.accent)
                    .frame(width: 132, height: 132)
                    .background(NerbyTheme.surface)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.06), radius: 24, y: 12)

                VStack(spacing: 12) {
                    Text(pages[page].title)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(NerbyTheme.ink)
                        .multilineTextAlignment(.center)
                    Text(pages[page].subtitle)
                        .font(.body)
                        .lineSpacing(4)
                        .foregroundStyle(NerbyTheme.muted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }

                HStack(spacing: 7) {
                    ForEach(0..<3, id: \.self) { index in
                        Capsule()
                            .fill(index == page ? NerbyTheme.accent : NerbyTheme.line)
                            .frame(width: index == page ? 28 : 8, height: 8)
                    }
                }

                Spacer()

                Button {
                    if page < 2 {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            page += 1
                        }
                    } else {
                        state.onboarded = true
                    }
                } label: {
                    Label(page == 2 ? "Začať" : "Pokračovať", systemImage: page == 2 ? "arrow.right" : "chevron.right")
                        .labelStyle(.titleAndIcon)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
        }
    }

    private var brandMark: some View {
        HStack(spacing: 10) {
            Image(systemName: "point.3.connected.trianglepath.dotted")
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(NerbyTheme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            Text("Nerby")
                .font(.title3.weight(.bold))
                .foregroundStyle(NerbyTheme.ink)
        }
    }
}

struct AuthView: View {
    @EnvironmentObject private var state: AppState
    @State private var name = "Dávid"
    @State private var phone = "+421"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Vytvor si profil")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                        Text("Jeden účet môže hľadať pomoc aj ponúkať služby. Rolu vieš kedykoľvek prepnúť.")
                            .foregroundStyle(NerbyTheme.muted)
                            .lineSpacing(3)
                    }

                    VStack(spacing: 12) {
                        CleanTextField(title: "Meno", text: $name, icon: "person")
                        CleanTextField(title: "Telefón pre volanie", text: $phone, icon: "phone")
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ako chceš začať?")
                            .font(.headline)
                        ForEach(UserMode.allCases) { mode in
                            RoleRow(mode: mode, isSelected: state.mode == mode) {
                                state.mode = mode
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Label("Poloha sa použije len na nájdenie relevantnej pomoci v okolí.", systemImage: "location")
                        Label("Bluetooth a presnejšie párovanie pridáme až po potvrdení oboma stranami.", systemImage: "dot.radiowaves.left.and.right")
                    }
                    .font(.footnote)
                    .foregroundStyle(NerbyTheme.muted)
                    .padding(16)
                    .background(NerbyTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    Button {
                        state.loggedIn = true
                    } label: {
                        Label("Vstúpiť do Nerby", systemImage: "arrow.right")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(24)
            }
            .background(NerbyTheme.background)
        }
    }
}

struct MainTabsView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Domov", systemImage: "house") }
            MapViewScreen()
                .tabItem { Label("Mapa", systemImage: "map") }
            MessagesView()
                .tabItem { Label("Správy", systemImage: "bubble.left.and.bubble.right") }
            ActivityView()
                .tabItem { Label("Aktivita", systemImage: "clock") }
            ProfileView()
                .tabItem { Label("Profil", systemImage: "person") }
        }
        .tint(NerbyTheme.accent)
    }
}

struct HomeView: View {
    @EnvironmentObject private var state: AppState
    @State private var showingRequest = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    HomeHeader()

                    Picker("Režim", selection: $state.mode) {
                        ForEach(UserMode.allCases) { mode in
                            Label(mode.title, systemImage: mode.icon).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .controlSize(.large)

                    if state.mode == .seeker {
                        SeekerHome(showingRequest: $showingRequest)
                    } else {
                        ProviderHome()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
            .background(NerbyTheme.background)
            .navigationTitle("Nerby")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { } label: {
                        Image(systemName: "bell")
                    }
                    .accessibilityLabel("Notifikácie")
                }
            }
            .sheet(isPresented: $showingRequest) {
                RequestComposerView()
            }
        }
    }
}

struct SeekerHome: View {
    @EnvironmentObject private var state: AppState
    @Binding var showingRequest: Bool

    private var onlineProviders: [Provider] {
        state.providers.filter(\.online)
    }

    var body: some View {
        VStack(spacing: 18) {
            SeekerActionPanel(showingRequest: $showingRequest)

            ActiveRequestCard()

            VStack(alignment: .leading, spacing: 14) {
                SectionTitle(title: "Najbližšia pomoc", subtitle: "Overení ľudia, ktorých vieš osloviť hneď")
                ForEach(onlineProviders.prefix(2)) { provider in
                    NavigationLink {
                        ProviderDetailView(provider: provider)
                    } label: {
                        NearbyProviderRow(provider: provider)
                    }
                    .buttonStyle(.plain)
                }
            }
            .premiumSurface()

            VStack(alignment: .leading, spacing: 14) {
                SectionTitle(title: "Rýchly stav", subtitle: "To najdôležitejšie pre rozhodnutie")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    DashboardTile(value: "\(state.providers.count)", label: "profily v dosahu", icon: "person.2")
                    DashboardTile(value: onlineProviders.first?.distance ?? "-", label: "najbližší online", icon: "location")
                    DashboardTile(value: onlineProviders.first?.responseTime.replacingOccurrences(of: "odpoveď do ", with: "") ?? "-", label: "očak. odpoveď", icon: "clock")
                    DashboardTile(value: state.urgent ? "Dnes" : "Flexi", label: "priorita dopytu", icon: "bolt")
                }
                HStack(spacing: 10) {
                    DashboardChip(icon: "shield.checkered", text: "Overené profily")
                    DashboardChip(icon: "location.fill", text: "Do 5 km")
                }
            }
            .premiumSurface()

            VStack(alignment: .leading, spacing: 14) {
                SectionTitle(title: "Pred stretnutím")
                HomeStatusRow(icon: "photo", title: "Pridaj fotku problému", subtitle: "Provider rýchlejšie odhadne cenu aj náradie")
                Divider()
                HomeStatusRow(icon: "eurosign.circle", title: "Dohodni cenu vopred", subtitle: "V správe si potvrď rozsah a približnú sumu")
                Divider()
                HomeStatusRow(icon: "mappin.and.ellipse", title: "Zdieľaj miesto až po dohode", subtitle: "Presnú adresu pošli len vybranému providerovi")
            }
            .premiumSurface()
        }
    }
}

struct SeekerActionPanel: View {
    @EnvironmentObject private var state: AppState
    @Binding var showingRequest: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Čo potrebuješ vyriešiť?")
                    .font(.title2.weight(.bold))
                Text("Zadaj problém, pozri najbližších ľudí a dohodni cenu ešte pred stretnutím.")
                    .font(.subheadline)
                    .foregroundStyle(NerbyTheme.muted)
                    .lineSpacing(3)
            }

            NavigationLink {
                SearchResultsView()
            } label: {
                MinimalSearchBar(text: state.problemText.isEmpty ? "Oprava, Wi-Fi, auto..." : state.problemText)
            }
            .buttonStyle(.plain)

            HStack(spacing: 10) {
                Button {
                    showingRequest = true
                } label: {
                    Label("Nový dopyt", systemImage: "plus")
                }
                .buttonStyle(PrimaryButtonStyle())

                NavigationLink {
                    MapViewScreen()
                } label: {
                    Image(systemName: "map")
                        .frame(width: 52, height: 52)
                }
                .foregroundStyle(NerbyTheme.accent)
                .background(NerbyTheme.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .accessibilityLabel("Otvoriť mapu")
            }
        }
        .premiumSurface()
    }
}

struct ActiveRequestCard: View {
    @EnvironmentObject private var state: AppState

    private var activeTitle: String {
        state.problemText.isEmpty ? "Tečie sifón pod umývadlom" : state.problemText
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "paperplane.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(NerbyTheme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))

                VStack(alignment: .leading, spacing: 5) {
                    Text("Aktívny dopyt")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(NerbyTheme.muted)
                    Text(activeTitle)
                        .font(.headline)
                        .lineLimit(2)
                    Text("Marek odpovedal teraz, Lucia je online. Vyber človeka alebo doplň fotku.")
                        .font(.subheadline)
                        .foregroundStyle(NerbyTheme.muted)
                        .lineLimit(3)
                }
                Spacer()
            }

            HStack(spacing: 8) {
                TagLabel(icon: state.selectedCategory.icon, text: state.selectedCategory.rawValue)
                TagLabel(icon: "clock", text: state.urgent ? "urgentné" : "dnes")
                Spacer(minLength: 0)
                Button("Správy") { }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(NerbyTheme.accent)
            }
        }
        .premiumSurface()
    }
}

struct NearbyProviderRow: View {
    let provider: Provider

    var body: some View {
        HStack(spacing: 12) {
            ProviderPhotoView(name: provider.name, imageName: provider.imageName, size: 54)
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text(provider.name)
                        .font(.headline)
                        .lineLimit(1)
                    if provider.verified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(NerbyTheme.accent)
                    }
                }
                Text(provider.headline)
                    .font(.caption)
                    .foregroundStyle(NerbyTheme.muted)
                    .lineLimit(1)
                HStack(spacing: 8) {
                    Label(provider.distance, systemImage: "location")
                    Label(provider.rating, systemImage: "star.fill")
                    Text(provider.price)
                }
                .font(.caption2.weight(.semibold))
                .foregroundStyle(NerbyTheme.muted)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(NerbyTheme.muted)
        }
        .padding(12)
        .background(NerbyTheme.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: NerbyTheme.compactRadius, style: .continuous))
    }
}

struct DashboardChip: View {
    let icon: String
    let text: String

    var body: some View {
        Label(text, systemImage: icon)
            .font(.caption.weight(.semibold))
            .foregroundStyle(NerbyTheme.ink)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(NerbyTheme.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: NerbyTheme.compactRadius, style: .continuous))
    }
}

struct ProviderTaskRow: View {
    let icon: String
    let title: String
    let detail: String
    let action: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(NerbyTheme.accent)
                .frame(width: 34, height: 34)
                .background(NerbyTheme.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(NerbyTheme.muted)
                    .lineLimit(2)
            }
            Spacer()
            Button(action) { }
                .font(.caption.weight(.bold))
                .foregroundStyle(NerbyTheme.accent)
        }
    }
}

struct SearchResultsView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(NerbyTheme.muted)
                        TextField("Skús: oprava, Wi‑Fi, auto...", text: $state.problemText)
                            .font(.body)
                    }
                    .clipShape(Capsule())

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(ServiceCategory.allCases) { category in
                                Button {
                                    state.selectedCategory = category
                                } label: {
                                    Text(category.rawValue)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(state.selectedCategory == category ? .white : NerbyTheme.ink)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 9)
                                        .background(state.selectedCategory == category ? NerbyTheme.ink : NerbyTheme.secondaryBackground)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(NerbyTheme.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                SectionTitle(title: "Ponuky v okolí", subtitle: "Profily pripravené na kontakt")
                ForEach(state.providers) { provider in
                    NavigationLink {
                        ProviderDetailView(provider: provider)
                    } label: {
                        ProviderCard(provider: provider)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(NerbyTheme.background)
        .navigationTitle("Hľadať")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProviderHome: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        VStack(spacing: 22) {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(state.available ? "Si dostupný" : "Si offline")
                            .font(.title2.weight(.semibold))
                        Text(state.available ? "Ľudia v okruhu 5 km ťa môžu osloviť." : "Profil je skrytý pre nové dopyty.")
                            .font(.subheadline)
                            .foregroundStyle(NerbyTheme.muted)
                    }
                    Spacer()
                    Toggle("", isOn: $state.available)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: NerbyTheme.accent))
                }

                HStack(spacing: 12) {
                    StatPill(value: "12", label: "oslovení")
                    StatPill(value: "4,9", label: "rating")
                    StatPill(value: "5 min", label: "reakcia")
                }
            }
            .premiumSurface()

            VStack(alignment: .leading, spacing: 14) {
                SectionTitle(title: "Dnes treba riešiť", subtitle: "Najkratšia cesta k zákazke")
                ProviderTaskRow(icon: "bolt", title: "Urgentný dopyt 700 m", detail: "Tečie sifón, zákazník chce pomoc dnes", action: "Odpovedať")
                Divider()
                ProviderTaskRow(icon: "calendar.badge.clock", title: "Potvrď príchod", detail: "Marek Kováč -> 18:20 v správe čaká na potvrdenie", action: "Potvrdiť")
            }
            .premiumSurface()

            SectionTitle(title: "Nové dopyty v okolí", subtitle: "Rýchlo posúď vzdialenosť, prioritu a typ problému", action: "Mapa")
            ForEach(state.nearbyRequests) { request in
                RequestCard(request: request)
            }

            ProviderEditorPreview()
        }
    }
}

struct ProviderDetailView: View {
    let provider: Provider

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .top, spacing: 14) {
                        AvatarView(name: provider.name, imageName: provider.imageName, size: 72)
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Text(provider.name)
                                    .font(.title2.weight(.bold))
                                if provider.verified {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundStyle(NerbyTheme.accent)
                                }
                            }
                            Text(provider.headline)
                                .foregroundStyle(NerbyTheme.muted)
                            HStack {
                                Label(provider.rating, systemImage: "star.fill")
                                Text("(\(provider.reviewCount))")
                                Text(provider.distance)
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(NerbyTheme.muted)
                        }
                        Spacer()
                    }

                    HStack(spacing: 10) {
                        Button { } label: {
                            Label("Napísať", systemImage: "message")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        Button { } label: {
                            Image(systemName: "phone.fill")
                                .frame(width: 48, height: 48)
                        }
                        .foregroundStyle(NerbyTheme.accent)
                        .background(NerbyTheme.accent.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                .sectionCard()

                DetailSection(title: "Bio") {
                    Text(provider.bio)
                        .foregroundStyle(NerbyTheme.muted)
                        .lineSpacing(4)
                }

                DetailSection(title: "Služby") {
                    FlowLayout(items: provider.services)
                }

                DetailSection(title: "Galéria") {
                    HStack(spacing: 10) {
                        ForEach(provider.gallery, id: \.self) { item in
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.title2)
                                Text(item)
                                    .font(.caption.weight(.semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 92)
                            .foregroundStyle(NerbyTheme.muted)
                            .background(NerbyTheme.background)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                }

                DetailSection(title: "Dostupnosť a cena") {
                    VStack(spacing: 12) {
                        InfoRow(icon: "clock", title: "Reakčný čas", value: provider.responseTime)
                        InfoRow(icon: "eurosign.circle", title: "Cena", value: provider.price)
                        InfoRow(icon: "location", title: "Pôsobenie", value: "do 5 km od aktuálnej polohy")
                    }
                }

                DetailSection(title: "Recenzie") {
                    ReviewRow(name: "Jana", text: "Prišiel rýchlo, vysvetlil cenu dopredu a problém vyriešil na mieste.", rating: "5,0")
                    ReviewRow(name: "Peter", text: "Výborná komunikácia a čistá práca.", rating: "4,9")
                }
            }
            .padding(18)
        }
        .background(NerbyTheme.background)
        .navigationTitle("Provider")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RequestComposerView: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var detail = ""
    @State private var comesToMe = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    CleanTextField(title: "Názov problému", text: $state.problemText, icon: "exclamationmark.bubble")
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Detail")
                            .font(.subheadline.weight(.semibold))
                        TextField("Popíš, čo sa stalo a čo potrebuješ vyriešiť.", text: $detail, axis: .vertical)
                            .lineLimit(4...7)
                            .padding(14)
                            .background(NerbyTheme.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    Picker("Kategória", selection: $state.selectedCategory) {
                        ForEach(ServiceCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)

                    VStack(spacing: 12) {
                        Toggle("Provider príde ku mne", isOn: $comesToMe)
                        Toggle("Urgentné", isOn: $state.urgent)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: NerbyTheme.accent))
                    .padding(16)
                    .background(NerbyTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    Button {
                        dismiss()
                    } label: {
                        Label("Odoslať dopyt", systemImage: "paperplane.fill")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(18)
            }
            .background(NerbyTheme.background)
            .navigationTitle("Nový dopyt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Zavrieť") { dismiss() }
                }
            }
        }
    }
}

struct MapViewScreen: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MapMockView()
                    .ignoresSafeArea(edges: .top)

                VStack(spacing: 14) {
                    Capsule()
                        .fill(NerbyTheme.line)
                        .frame(width: 38, height: 5)
                        .padding(.top, 2)

                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Bratislava - okolie")
                                .font(.headline)
                            Text("3 provideri v dosahu")
                                .font(.caption)
                                .foregroundStyle(NerbyTheme.muted)
                        }
                        Spacer()
                        Button { } label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                        .buttonStyle(IconButtonStyle())
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(state.providers) { provider in
                                NavigationLink {
                                    ProviderDetailView(provider: provider)
                                } label: {
                                    MiniProviderCard(provider: provider)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
                .padding(18)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 22, y: 10)
                .padding(16)
            }
            .navigationTitle("Mapa")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MessagesView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Konverzácie")
                            .font(.largeTitle.weight(.bold))
                        Text("Dohody, fotky a príchody na stretnutie máš pokope.")
                            .font(.subheadline)
                            .foregroundStyle(NerbyTheme.muted)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)

                    ForEach(state.chats) { chat in
                        NavigationLink {
                            ChatDetailView(chat: chat)
                        } label: {
                            ChatRow(chat: chat)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .background(NerbyTheme.background)
            .navigationTitle("Správy")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ChatDetailView: View {
    let chat: ChatThread
    @State private var message = ""

    var body: some View {
        VStack(spacing: 0) {
            ChatTrustHeader(chat: chat)

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Dnes")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(NerbyTheme.muted)
                        .frame(maxWidth: .infinity)
                    ChatBubble(text: "Ahoj, vidím tvoj dopyt. Vieš poslať fotku problému?", incoming: true)
                    ChatBubble(text: "Áno, posielam. Potrebujem to vyriešiť dnes.", incoming: false)
                    ChatBubble(text: chat.preview, incoming: true)
                }
                .padding(18)
            }

            HStack(spacing: 10) {
                Button { } label: { Image(systemName: "plus") }
                    .buttonStyle(IconButtonStyle())
                TextField("Správa", text: $message)
                    .padding(12)
                    .background(NerbyTheme.secondaryBackground)
                    .clipShape(Capsule())
                Button { message = "" } label: { Image(systemName: "arrow.up") }
                    .buttonStyle(IconButtonStyle(filled: true))
            }
            .padding(12)
            .background(NerbyTheme.surface)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(NerbyTheme.line)
                    .frame(height: 1)
            }
        }
        .background(NerbyTheme.background)
        .navigationTitle(chat.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button { } label: { Image(systemName: "phone") }
                Button { } label: { Image(systemName: "location") }
            }
        }
    }
}

struct ActivityView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dnešný priebeh")
                            .font(.largeTitle.weight(.bold))
                        Text("Sleduj dopyty, stretnutia a hodnotenia na jednom mieste.")
                            .font(.subheadline)
                            .foregroundStyle(NerbyTheme.muted)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 4)

                    VStack(spacing: 0) {
                        ForEach(Array(state.activities.enumerated()), id: \.element.id) { index, item in
                            ActivityTimelineRow(item: item, isLast: index == state.activities.count - 1)
                        }
                    }
                    .premiumSurface(padding: 0)
                }
                .padding(20)
            }
            .background(NerbyTheme.background)
            .navigationTitle("Aktivita")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 14) {
                        AvatarView(name: "Dávid", size: 88)
                        VStack(spacing: 4) {
                            Text("Dávid S.")
                                .font(.title2.weight(.semibold))
                            Text("Nerby účet · Bratislava")
                                .font(.subheadline)
                                .foregroundStyle(NerbyTheme.muted)
                        }
                        Text(state.mode.title)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(NerbyTheme.accent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(NerbyTheme.accent.opacity(0.10))
                            .clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity)
                    .premiumSurface()

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Rola")
                            .font(.headline)
                        Picker("Rola", selection: $state.mode) {
                            ForEach(UserMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .controlSize(.large)
                    }
                    .premiumSurface()

                    VStack(spacing: 0) {
                        SettingsRow(icon: "bell", title: "Notifikácie", value: "Zapnuté")
                        Divider()
                        SettingsRow(icon: "location", title: "Súkromie polohy", value: "Len pri používaní")
                        Divider()
                        SettingsRow(icon: "shield", title: "Bezpečnosť", value: "Report a blokovanie")
                        Divider()
                        SettingsRow(icon: "globe", title: "Jazyk", value: "Slovenčina")
                    }
                    .premiumSurface(padding: 0)

                    if state.mode == .provider {
                        ProviderSettingsCard()
                    }

                    Button(role: .destructive) {
                        state.loggedIn = false
                    } label: {
                        Label("Odhlásiť sa", systemImage: "rectangle.portrait.and.arrow.right")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(20)
            }
            .background(NerbyTheme.background)
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HomeHeader: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Dnes v okolí")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(NerbyTheme.muted)
                Text("Nájdi spoľahlivú pomoc nablízku")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(NerbyTheme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            AvatarView(name: "Dávid", size: 44)
        }
        .padding(.top, 4)
    }
}

struct MinimalSearchBar: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.headline)
                .foregroundStyle(NerbyTheme.muted)
            Text(text)
                .font(.body)
                .foregroundStyle(text == "Čo potrebuješ vyriešiť?" ? NerbyTheme.muted : NerbyTheme.ink)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(NerbyTheme.muted)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(NerbyTheme.secondaryBackground)
        .clipShape(Capsule())
    }
}

struct DashboardTile: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(NerbyTheme.ink)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3.weight(.semibold))
                Text(label)
                    .font(.caption)
                    .foregroundStyle(NerbyTheme.muted)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(NerbyTheme.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: NerbyTheme.compactRadius, style: .continuous))
    }
}

struct HomeStatusRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(NerbyTheme.ink)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(NerbyTheme.muted)
            }
            Spacer()
        }
    }
}

struct ProviderCard: View {
    let provider: Provider

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ProviderPhotoView(name: provider.name, imageName: provider.imageName, size: 78)
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 6) {
                            Text(provider.name)
                                .font(.headline)
                            if provider.verified {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(NerbyTheme.ink)
                            }
                        }
                        Text(provider.headline)
                            .font(.subheadline)
                            .foregroundStyle(NerbyTheme.muted)
                            .lineLimit(2)
                    }
                    Spacer()
                    AvailabilityBadge(online: provider.online)
                }

                HStack(spacing: 12) {
                    MetricLabel(title: provider.distance, subtitle: "od teba")
                    Divider().frame(height: 28)
                    MetricLabel(title: provider.rating, subtitle: "\(provider.reviewCount) recenzií")
                    Divider().frame(height: 28)
                    MetricLabel(title: provider.price, subtitle: "cena")
                }

                HStack {
                    Text(provider.responseTime)
                        .font(.caption)
                        .foregroundStyle(NerbyTheme.muted)
                    Spacer()
                    TagLabel(icon: provider.category.icon, text: provider.category.rawValue)
                }
            }
        }
        .premiumSurface()
    }
}

struct MiniProviderCard: View {
    let provider: Provider

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ProviderPhotoView(name: provider.name, imageName: provider.imageName, size: 42)
                AvailabilityBadge(online: provider.online)
            }
            Text(provider.name)
                .font(.headline)
            Text(provider.category.rawValue)
                .font(.caption)
                .foregroundStyle(NerbyTheme.muted)
            HStack {
                Label(provider.distance, systemImage: "location")
                Label(provider.rating, systemImage: "star.fill")
            }
            .font(.caption2.weight(.semibold))
            .foregroundStyle(NerbyTheme.muted)
        }
        .frame(width: 180, alignment: .leading)
        .padding(14)
        .background(NerbyTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: NerbyTheme.radius, style: .continuous)
                .stroke(NerbyTheme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: NerbyTheme.radius, style: .continuous))
    }
}

struct RequestCard: View {
    let request: ServiceRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: request.category.icon)
                    .foregroundStyle(NerbyTheme.accent)
                    .frame(width: 38, height: 38)
                    .background(NerbyTheme.accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                VStack(alignment: .leading, spacing: 4) {
                    Text(request.title)
                        .font(.headline)
                    Text(request.detail)
                        .font(.subheadline)
                        .foregroundStyle(NerbyTheme.muted)
                        .lineLimit(2)
                }
                Spacer()
            }

            HStack {
                TagLabel(icon: "location", text: request.distance)
                TagLabel(icon: "clock", text: request.time)
                Spacer()
                Text(request.priority)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(request.priority == "Urgentné" ? NerbyTheme.warm : NerbyTheme.muted)
            }
        }
        .premiumSurface()
    }
}

struct ProviderEditorPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "Tvoja stránka", action: "Upraviť")
            Text("Nastav bio, fotky, služby, cenu a radius. Profil sa môže zobrazovať len vtedy, keď si online.")
                .font(.subheadline)
                .foregroundStyle(NerbyTheme.muted)
                .lineSpacing(3)
            HStack {
                TagLabel(icon: "photo", text: "3 fotky")
                TagLabel(icon: "mappin.and.ellipse", text: "5 km radius")
                TagLabel(icon: "eye", text: "len online")
            }
        }
        .premiumSurface()
    }
}

struct ProviderSettingsCard: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Nastavenia providera")
                .font(.headline)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Radius pôsobenia")
                    Spacer()
                    Text("\(Int(state.serviceRadius)) km")
                        .font(.subheadline.weight(.bold))
                }
                Slider(value: $state.serviceRadius, in: 1...15, step: 1)
                    .tint(NerbyTheme.accent)
            }
            Toggle("Ukazovať profil len keď som online", isOn: $state.showOnlyWhenOnline)
                .toggleStyle(SwitchToggleStyle(tint: NerbyTheme.accent))
        }
        .premiumSurface()
    }
}

struct MapMockView: View {
    var body: some View {
        ZStack {
            NerbyTheme.background
            SoftMapPattern()
                .stroke(NerbyTheme.line.opacity(0.7), lineWidth: 1)
            Path { path in
                path.move(to: CGPoint(x: 20, y: 160))
                path.addCurve(to: CGPoint(x: 360, y: 210), control1: CGPoint(x: 120, y: 90), control2: CGPoint(x: 250, y: 285))
                path.move(to: CGPoint(x: 45, y: 420))
                path.addCurve(to: CGPoint(x: 370, y: 330), control1: CGPoint(x: 160, y: 360), control2: CGPoint(x: 240, y: 390))
            }
            .stroke(NerbyTheme.secondaryBackground, style: StrokeStyle(lineWidth: 18, lineCap: .round))
            Circle()
                .fill(NerbyTheme.accent.opacity(0.08))
                .frame(width: 260, height: 260)
                .blur(radius: 0.5)
            Circle()
                .fill(NerbyTheme.accent)
                .frame(width: 18, height: 18)
                .overlay(Circle().stroke(.white, lineWidth: 4))
                .position(x: 190, y: 310)
            MapPin(label: "Marek", online: true)
                .position(x: 105, y: 235)
            MapPin(label: "Lucia", online: true)
                .position(x: 260, y: 180)
            MapPin(label: "Tomáš", online: false)
                .position(x: 300, y: 360)
        }
    }
}

struct SoftMapPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let step: CGFloat = 84
        var x: CGFloat = 0
        while x <= rect.width {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
            x += step
        }
        var y: CGFloat = 0
        while y <= rect.height {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
            y += step
        }
        return path
    }
}

struct MapPin: View {
    let label: String
    let online: Bool

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: "mappin")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(online ? NerbyTheme.accent : NerbyTheme.warm)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.10), radius: 10, y: 5)
            Text(label)
                .font(.caption2.weight(.bold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(NerbyTheme.surface)
                .clipShape(Capsule())
        }
    }
}

struct ChatRow: View {
    let chat: ChatThread

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(name: chat.name, size: 48)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(chat.name)
                        .font(.headline)
                    Spacer()
                    Text(chat.time)
                        .font(.caption)
                        .foregroundStyle(NerbyTheme.muted)
                }
                Text(chat.preview)
                    .font(.subheadline)
                    .foregroundStyle(NerbyTheme.muted)
                    .lineLimit(2)
                Text(chat.status)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(NerbyTheme.accent)
            }
            if chat.unread {
                Circle()
                    .fill(NerbyTheme.accent)
                    .frame(width: 9, height: 9)
            }
        }
        .premiumSurface(padding: 14)
    }
}

struct ChatTrustHeader: View {
    let chat: ChatThread

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(name: chat.name, size: 42)
            VStack(alignment: .leading, spacing: 3) {
                Text(chat.name)
                    .font(.headline)
                HStack(spacing: 5) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.caption)
                        .foregroundStyle(NerbyTheme.accent)
                    Text("Overený provider · \(chat.status)")
                        .font(.caption)
                        .foregroundStyle(NerbyTheme.muted)
                }
            }
            Spacer()
            Button { } label: {
                Image(systemName: "phone.fill")
            }
            .buttonStyle(IconButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(NerbyTheme.surface)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(NerbyTheme.line)
                .frame(height: 1)
        }
    }
}

struct ChatBubble: View {
    let text: String
    let incoming: Bool

    var body: some View {
        HStack {
            if !incoming { Spacer(minLength: 50) }
            Text(text)
                .padding(12)
                .foregroundStyle(incoming ? NerbyTheme.ink : .white)
                .background(incoming ? NerbyTheme.surface : NerbyTheme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            if incoming { Spacer(minLength: 50) }
        }
    }
}

struct ActivityRow: View {
    let item: ActivityItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.icon)
                .foregroundStyle(NerbyTheme.accent)
                .frame(width: 42, height: 42)
                .background(NerbyTheme.accent.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(NerbyTheme.muted)
            }
            Spacer()
            Text(item.status)
                .font(.caption.weight(.bold))
                .foregroundStyle(NerbyTheme.accent)
        }
        .sectionCard()
    }
}

struct ActivityTimelineRow: View {
    let item: ActivityItem
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            VStack(spacing: 0) {
                Image(systemName: item.icon)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(NerbyTheme.accent)
                    .clipShape(Circle())
                if !isLast {
                    Rectangle()
                        .fill(NerbyTheme.line)
                        .frame(width: 1, height: 52)
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .firstTextBaseline) {
                    Text(item.title)
                        .font(.headline)
                    Spacer()
                    Text(item.status)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(NerbyTheme.accent)
                }
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(NerbyTheme.muted)
                    .lineLimit(2)
            }
            .padding(.bottom, isLast ? 0 : 20)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, isLast ? 16 : 0)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(NerbyTheme.accent)
                .frame(width: 34, height: 34)
                .background(NerbyTheme.accent.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            Text(title)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text(value)
                .font(.caption)
                .foregroundStyle(NerbyTheme.muted)
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(NerbyTheme.muted.opacity(0.7))
        }
        .padding(14)
    }
}

struct RoleRow: View {
    let mode: UserMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: mode.icon)
                    .frame(width: 38, height: 38)
                    .foregroundStyle(isSelected ? .white : NerbyTheme.accent)
                    .background(isSelected ? NerbyTheme.accent : NerbyTheme.accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                VStack(alignment: .leading, spacing: 3) {
                    Text(mode.title)
                        .font(.headline)
                    Text(mode == .seeker ? "Zadám problém a nájdem človeka nablízku." : "Zapnem dostupnosť a prijímam dopyty.")
                        .font(.caption)
                        .foregroundStyle(NerbyTheme.muted)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? NerbyTheme.accent : NerbyTheme.line)
            }
            .padding(14)
            .background(NerbyTheme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? NerbyTheme.accent : .clear, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct CleanTextField: View {
    let title: String
    @Binding var text: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(NerbyTheme.accent)
                .frame(width: 32)
            TextField(title, text: $text)
                .textInputAutocapitalization(.sentences)
        }
        .padding(14)
        .background(NerbyTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct SectionTitle: View {
    let title: String
    let subtitle: String?
    let action: String?

    init(title: String, subtitle: String? = nil, action: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(NerbyTheme.muted)
                }
            }
            Spacer()
            if let action {
                Button(action) { }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(NerbyTheme.accent)
            }
        }
    }
}

struct MetricLabel: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(NerbyTheme.ink)
            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(NerbyTheme.muted)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DetailSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content
        }
        .premiumSurface()
    }
}

struct ReviewRow: View {
    let name: String
    let text: String
    let rating: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(name)
                    .font(.subheadline.weight(.bold))
                Spacer()
                Label(rating, systemImage: "star.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(NerbyTheme.warm)
            }
            Text(text)
                .font(.subheadline)
                .foregroundStyle(NerbyTheme.muted)
        }
        .padding(.vertical, 6)
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(NerbyTheme.accent)
                .frame(width: 28)
            Text(title)
                .foregroundStyle(NerbyTheme.muted)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.semibold))
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

struct FlowLayout: View {
    let items: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(NerbyTheme.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(NerbyTheme.background)
                    .clipShape(Capsule())
            }
        }
    }
}

struct StatPill: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(NerbyTheme.muted)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(NerbyTheme.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: NerbyTheme.compactRadius, style: .continuous))
    }
}

struct AvailabilityBadge: View {
    let online: Bool

    var body: some View {
        Text(online ? "Online" : "Offline")
            .font(.caption2.weight(.bold))
            .foregroundStyle(online ? NerbyTheme.accent : NerbyTheme.warm)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background((online ? NerbyTheme.accent : NerbyTheme.warm).opacity(0.12))
            .clipShape(Capsule())
    }
}

struct TagLabel: View {
    let icon: String
    let text: String

    var body: some View {
        Label(text, systemImage: icon)
            .font(.caption.weight(.semibold))
            .foregroundStyle(NerbyTheme.muted)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(NerbyTheme.background)
            .clipShape(Capsule())
    }
}

enum ProfileAssets {
    static func imageName(for name: String) -> String? {
        switch name {
        case "Marek Kováč": return "profile-marek"
        case "Lucia Poláková": return "profile-lucia"
        case "Tomáš Varga": return "profile-tomas"
        case "Dávid", "Dávid S.": return "profile-david"
        default: return nil
        }
    }
}

struct ProfileImageView: View {
    let name: String
    let imageName: String?
    let size: CGFloat

    var body: some View {
        ZStack {
            if let resolvedImageName {
                Image(resolvedImageName)
                    .resizable()
                    .scaledToFill()
            } else {
                Text(initials)
                    .font(.system(size: size * 0.34, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(NerbyTheme.ink)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(NerbyTheme.line, lineWidth: 1)
        )
        .contentShape(Circle())
    }

    private var resolvedImageName: String? {
        imageName ?? ProfileAssets.imageName(for: name)
    }

    private var initials: String {
        let parts = name.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first }.map(String.init).joined()
    }
}

struct ProviderPhotoView: View {
    let name: String
    var imageName: String? = nil
    let size: CGFloat

    var body: some View {
        ProfileImageView(name: name, imageName: imageName, size: size)
    }
}

struct AvatarView: View {
    let name: String
    var imageName: String? = nil
    let size: CGFloat

    var body: some View {
        ProfileImageView(name: name, imageName: imageName, size: size)
    }
}

struct LegacyInitialsBadge: View {
    let name: String

    var body: some View {
        Text(initials)
            .font(.caption2.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(.black.opacity(0.55))
            .clipShape(Capsule())
    }

    private var initials: String {
        let parts = name.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first }.map(String.init).joined()
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .foregroundStyle(.white)
            .background(configuration.isPressed ? NerbyTheme.accentPressed : NerbyTheme.accent)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct IconButtonStyle: ButtonStyle {
    var filled = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(width: 40, height: 40)
            .foregroundStyle(filled ? .white : NerbyTheme.accent)
            .background(filled ? NerbyTheme.accent : NerbyTheme.accent.opacity(configuration.isPressed ? 0.18 : 0.10))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

extension View {
    func premiumSurface(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(NerbyTheme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: NerbyTheme.radius, style: .continuous)
                    .stroke(NerbyTheme.line, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: NerbyTheme.radius, style: .continuous))
    }

    func sectionCard(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(NerbyTheme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: NerbyTheme.radius, style: .continuous)
                    .stroke(NerbyTheme.line, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: NerbyTheme.radius, style: .continuous))
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
