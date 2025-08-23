//
//  Login_Page_View.swift
//  GoDairy
//
//  Created by Mani V on 28/09/24.
//
import SwiftUI

struct Login_Page_View: View {
    @State private var username : String = ""
    @State private var password : String = ""
    @State var visible = false
    @State var visible1 = true
    @State var color = Color.black.opacity(0.7)
    @StateObject private var toastManager = ToastManager()
    @StateObject var viewModel = ProductViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 4) {//qad-801090
                Color.appPrimary
                Color.white
            }
            .ignoresSafeArea()
            
            Image("Group 15")
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 0,maxWidth: .infinity,alignment: .top)
                .frame(minHeight: 0, maxHeight: .infinity,alignment: .top)
                .edgesIgnoringSafeArea(.all)
        
            VStack {
                HStack {
                    VStack(alignment: .trailing, spacing: 1) {
                        Text("Dairy product")
                            .frame(maxWidth: .infinity,alignment: .trailing)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Text("Delivery Solutions")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .padding()
                }
                Spacer(minLength: 200)
                
                VStack {
                    HStack {
                        if self.visible1 {
                            TextField("USERNAME", text: self.$username)
                        }
                        else {
                            SecureField("USERNAME", text: self.$username)
                        }
                        Image(systemName:  "checkmark" )
                            .foregroundColor(self.color)
                    }
                    .background(.white)
                    .cornerRadius(3)
                    .padding()
                    
                    HStack {
                        Spacer(minLength: 20)
                        if self.visible {
                            TextField("PASSWORD", text: self.$password)
                        }
                        else {
                            SecureField("PASSWORD", text: self.$password)
                        }
                    Button(action: {
                        self.visible.toggle()
                    }) {
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(self.color)
                    }
                    .background(.white)
                    .cornerRadius(3)
                    .padding()
                    }
                }
                Spacer(minLength: 60)
                SignINbutton(toastManager: toastManager,username: $username,password: $password)
                    Spacer(minLength: 50)
                    VStack(alignment:.center) {
//                        Text("Powered by")
//                            .font(.caption)
//                            .foregroundColor(.gray)
                        Image("logopic")
                            .resizable()
                            .frame(width: 50,height: 50)
                        Spacer(minLength: 50)
                }
            }
        }
        Toast(toastManager: toastManager)
            .padding(.bottom, 50)
            .onAppear() {
                Task {
                    await viewModel.fetchData()
                }
            }
    }
}

#Preview {
    ContentView()
}

struct page:View {
    @StateObject private var viewModel = DataViewModel()
    var body: some View {
        NavigationView {
            VStack {
                Text("forget password")
                
                HStack {
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .navigationTitle("Custom List")
        }
    }
}

struct SignINbutton: View {
    @ObservedObject var toastManager: ToastManager
    @Binding var username:String
    @Binding var password:String
    @State private var isLoading = false
    @State private var isAuthenticated = false
    @StateObject var viewModel = ProductViewModel()
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                  .scaleEffect(2) // makes it 2x larger
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
                        .background(Color.blue)
                        .font(.headline)
                        .foregroundColor(.white)
                        .cornerRadius(9)
                }
            }

            NavigationLink(destination: DashboardView(), isActive: $isAuthenticated) {
                EmptyView()
            }
        }
    }
    
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
                DispatchQueue.main.async {
                    self.isAuthenticated = true   // triggers NavigationLink
                }
            }
            else {
                toastManager.showToast(message: "Enter correct Username and Password")
            }
        }
        catch {
            toastManager.showToast(message: "Something went wrong. Please try again.")
        }
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
        
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
                UserDefaults.standard.set(user.divisionCode, forKey: "Division_Code")
                UserDefaults.standard.set(user.sfName, forKey: "Sf_Name")
                UserDefaults.standard.set(true, forKey: "User_Login")
                await MainActor.run {
                    self.isAuthenticated = true
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

struct forgetbtn:View {
    var body: some View {
        VStack(alignment: .trailing, spacing: 4){
            Text("Forget Password?")
                .frame(maxWidth: .infinity,alignment: .trailing)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .padding()
    }
}

//struct CustomBtn: View {
//    var title: String
//   // var width: CGFloat = 350    // default width
//    var height: CGFloat = 50    // default height
//    var backgroundColor: Color = Color(red: 25/255, green: 151/255, blue: 206/255)
//    
//    var body: some View {
//        
//        Button(action: {
//            
//        }) {
//            Text(title)
//                .frame(height: height, alignment: .center)
//                .background(backgroundColor)
//                .font(.headline)
//                .font(.system(size: 17, weight: .medium))
//                .foregroundColor(.white)
//                .cornerRadius(9)
//        }
//    }
//}

struct CustomBtn: View {
    var title: String
    var height: CGFloat = 50
    var backgroundColor: Color = Color.backgroundColour
    var action: () -> Void   // 👈 action passed from outside
    
    var body: some View {
        Button(action: action) {   // 👈 executes your action
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: height) 
                .background(backgroundColor)
                .cornerRadius(9)
        }
    }
}


/*enum ValidationError: LocalizedError, Identifiable {
    case invalidUsername
    case invalidPassword
    case emptyFields
    case passwordTooShort
    case passwordToolength
    case passwordMissingRequirements

    var id: Self { self }

    var errorDescription: String? {
        switch self {
        case .invalidUsername:
            return "Username must be at least 3 characters long."
        case .invalidPassword:
            return "Password must be at least 8 characters long and include a number."
        case .emptyFields:
            return "Please fill in all fields."
        case .passwordTooShort:
            return "Password is too short."
        case .passwordToolength:
            return "Password is too length"
        case .passwordMissingRequirements:
            return "Password must include at least one uppercase letter, one lowercase letter, and one number."
        }
    }
}

struct Login_Page_View: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @StateObject private var toastManager = ToastManager()
    @State var visible = false
    @State var isAuthenticated: Bool = false
    @State private var validationError: ValidationError?

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 4) {
                    Color(red: 25/255, green: 151/255, blue: 206/255)
                    
                    Color.white
                }
                .ignoresSafeArea()
                
                Image("Group 15")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .top)
                    .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        VStack(alignment: .trailing, spacing: 1) {
                            Text("Dairy product")
                                .frame(maxWidth: .infinity,alignment: .trailing)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Delivery Solutions")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    Spacer(minLength: 150)
                    
                    VStack {
                        //Form{
                        //Section(header: Text("username")){
                        TextField("USER NAME", text: self.$email)
                            .padding()
                        
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : .white, lineWidth: 0))
                            .padding(.top, 25)
                        // }
                        
                        HStack(spacing: 15) {
                            //Section(header: Text("password")){
                            if self.visible {
                                TextField("PASSWORD", text: self.$pass)
                            } else {
                                SecureField("PASSWORD", text: self.$pass)
                            }
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            //}
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : .white, lineWidth: 0))
                        .padding(.top, 10)
                        // }
                    }
                    
                    Spacer(minLength: 60)
                    
                    NavigationLink(
                        destination: Dashboard2()
                            .toolbarRole(.editor),
                        label: {
                            forgetbtn()
                                .toolbarRole(.editor)
                        })
                    
                    SignINbutton(toastManager: toastManager, username: $email, password: $pass, isAuthenticated: $isAuthenticated)
                    
                    Spacer(minLength: 50)
                    
                    VStack(alignment: .center) {
                        Text("Powered by")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Image("logopic")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Spacer(minLength: 50)
                    }
                }
                
                .navigationDestination(isPresented: $isAuthenticated) {
                    Dashboard()
                }
                
                Toast(toastManager: toastManager)
                    .padding(.bottom, 50)
                //  }
            }
        }
    }
}

struct SignINbutton: View {
    @ObservedObject var toastManager: ToastManager
    @Binding var username: String
    @Binding var password: String
    @Binding var isAuthenticated: Bool

    var body: some View {
        VStack {
            Button(action: {
                if validateForm() {
                    isAuthenticated = true
                }
            }) {
                Text("SIGN IN")
                    .frame(width: 350, height: 50, alignment: .center)
                    .background(Color(red: 25/255, green: 151/255, blue: 206/255))
                    .font(.headline)
                    .foregroundColor(.white)
                    .cornerRadius(9)
            }
        }
    }

    func validateForm() -> Bool {
        // Check if fields are empty
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            toastManager.showToast(message: ValidationError.emptyFields.errorDescription!)
            return false
        }

        // Validate username length
        if username.count < 3 {
            toastManager.showToast(message: ValidationError.invalidUsername.errorDescription!)
            return false
        }

        // Validate password short
       if password.count >= 2 {
            toastManager.showToast(message: ValidationError.passwordTooShort.errorDescription!)
            return false
        }
        
        if password.count != 6 {
            toastManager.showToast(message: ValidationError.passwordToolength.errorDescription!)
            return false
        }

        // Validate password requirements (at least one uppercase letter, one lowercase letter, and one number)
        let passwordRegex = "^[0-9]{4}$"//"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if !passwordPredicate.evaluate(with: password) {
            toastManager.showToast(message: ValidationError.passwordMissingRequirements.errorDescription!)
            return false
        }

        return true
    }
}

struct forgetbtn: View {
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("Forget Password?")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .padding()
    }

}*/
