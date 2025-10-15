

import SwiftUI

struct Login_Page_View: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State var visible = false
    @State var visible1 = true
    @State var color = Color.black.opacity(0.7)
    @StateObject private var toastManager = ToastManager()
    @StateObject var viewModel = ProductViewModel()
    @EnvironmentObject var router: AppRouter   // 👈 Access global router

    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                Color.appPrimary
                Color.white
            }
            .ignoresSafeArea()
            
            Image("Group 15")
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .top)
                .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // MARK: Header
                HStack {
                    VStack(alignment: .trailing, spacing: 1) {
                        Text("Dairy product")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.title)
                            .regularTextStyle(foreground: .white, fontWeight: .bold)
//                            .fontWeight(.bold)
//                            .foregroundStyle(.white)
                        Text("Delivery Solutions")
                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundStyle(.white)
                            .regularTextStyle(foreground: .white, fontWeight: .bold)
                    }
                    .padding()
                }
                Spacer(minLength: 200)
                
                // MARK: Username & Password
                VStack {
                    HStack {
                        if visible1 {
                            TextField("USERNAME", text: $username)
                        } else {
                            SecureField("USERNAME", text: $username)
                        }
                        Image(systemName: "checkmark")
                            .foregroundColor(color)
                    }
                    .background(.white)
                    .cornerRadius(3)
                    .padding()
                    
                    HStack {
                        if visible {
                            TextField("PASSWORD", text: $password)
                        } else {
                            SecureField("PASSWORD", text: $password)
                        }
                        Button(action: { visible.toggle() }) {
                            Image(systemName: visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(color)
                        }
                    }
                    .background(.white)
                    .cornerRadius(3)
                    .padding()
                }
                
                Spacer(minLength: 60)
                
                // MARK: Sign In Button
                SignINbutton(
                    toastManager: toastManager,
                    username: $username,
                    password: $password
                )
                
                Spacer(minLength: 50)
                
                VStack {
                    Image("logopic")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Spacer(minLength: 50)
                }
            }
        }
        .environmentObject(router)
        //.toast(toastManager: toastManager)
        .onAppear {
            Task {
                await viewModel.fetchData()
            }
        }
    }
}

// MARK: Sign In Button with Router
struct SignINbutton: View {
    @ObservedObject var toastManager: ToastManager
    @Binding var username: String
    @Binding var password: String
    @State private var isLoading = false
    @AppStorage("User_Login") var isLoggedIn: Bool = false
    @EnvironmentObject var router: AppRouter   // 👈 Inject router

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .padding()
            }
            else {
                Button(action: {
                    Task {
                        isLoading = true
                        await signin()
                        isLoading = false
                    }
                }) {
                    Text("SIGN IN")
                        .frame(width: 350, height: 50)
                        .background(Color.appPrimary)
                        .font(.headline)
                        .foregroundColor(.white)
                        .cornerRadius(9)
                }
            }
        }
    }
    
    // MARK: Signin Function
    func signin() async {
        guard validateForm() else {
            isLoading = false
            return
        }
        
        let compDet = username.components(separatedBy: "-")
        guard let compSH = compDet.first?.uppercased() else {
            toastManager.showToast(message: "Invalid username format")
            return
        }
        
        do {
            let fetchedData: [String: DataItem] = try await NetworkManager.shared.fetchData(
                from: milk_url,
                as: [String: DataItem].self
            )
            if let dataItem = fetchedData[compSH] {
                APIClient.shared.BaseURL = dataItem.base_url
                await userAuth()
            }
            else {
                toastManager.showToast(message: "Enter correct Username and Password")
            }
        }
        catch {
            toastManager.showToast(message: "Something went wrong. Please try again.")
        }
        isLoading = false
    }
    
    // MARK: User Authentication
    func userAuth() async {
        let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL +
            "get/GoogleLogin&Email=\(username)&UserID=\(username)&Pwd=\(password)&AppVer=iOS&DvID=test"
        print("The urlstring in the login page is \(urlString)")
        
        do {
            let response: LoginResponse = try await NetworkManager.shared.fetchData(
                from: urlString,
                as: LoginResponse.self
            )
            print("Login Response: \(response)")
            if response.success == true, let user = response.data?.first {
                UserDefaults.standard.set(user.sfCode, forKey: "Sf_code")
                print("The SF Code is \(UserDefaults.standard.string(forKey: "Sf_code") ?? "")")
                print("The Ukey is \(Ukey)")
                UserDefaults.standard.set(user.divisionCode, forKey: "Division_Code")
                UserDefaults.standard.set(user.sfName, forKey: "Sf_Name")
                UserDefaults.standard.set(user.sfDesignation, forKey: "sf_Designation_Short_Name")
                isLoggedIn = true
                
                await MainActor.run {
                    router.root = .dashboard   // 👈 Navigate using router//qad-802320
                }
            }
            else {
                await MainActor.run {
                    toastManager.showToast(message: "Enter correct Password")
                }
            }
        }
        catch {
            print("Login error:", error.localizedDescription)
            await MainActor.run {
                toastManager.showToast(message: "Something went wrong. Please try again.")
            }
        }
    }
    
    func validateForm() -> Bool {
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            toastManager.showToast(message: "Enter Username")
            return false
        }
        if password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            toastManager.showToast(message: "Enter Password")
            return false
        }
        return true
    }
}

struct CustomBtn: View {
    var title: String
    var height: CGFloat = 50
    var cornerRadius: CGFloat = 9
    var fontsize: CGFloat = 17
    var backgroundColor: Color = Color.backgroundColour
    var fontWeight: Font.Weight = .medium
    var action: () -> Void   // 👈 action passed from outside
    
    var body: some View {
        Button(action: action) {   // 👈 executes your action
            Text(title)
                .frame(maxWidth: .infinity, minHeight: height)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .regularTextStyle(size: fontsize, foreground: .white, fontWeight: fontWeight)
        }
    }
}

#Preview {
    ContentView()
}



