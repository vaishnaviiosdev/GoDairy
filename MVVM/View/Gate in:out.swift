//
//  Gate in:out.swift
//  GoDairy
//
//  Created by San eforce on 05/10/24.
//

import SwiftUI

struct Gate_in_out: View {
    @State var SliderValue: Float = 0.0
    var body: some View {
        Text("Hello, Gate_in_out!")
        Spacer()
            .frame(height: 50)
        Text("world")
        
       /* Slider(value: $SliderValue, in: 0...10,step:2){ didChange in
            print("Did change:\(didChange)")
        }.padding()*/
    }
}

#Preview {
    Gate_in_out()
}

/*import SwiftUI

struct Login_Page_View: View {
    @State private var username : String = ""
    @State private var pass : String = ""
    @State var color = Color.black.opacity(0.7)
    @State var visible = false
    @StateObject private var toastManager = ToastManager()
    //@State var isAuthenticated:Bool = false
    var body: some View {
         NavigationView{
        ZStack {
            VStack(spacing: 4){
                Color(red:25/255,green: 151/255,blue: 206/255)
                Color.white
            }
            .ignoresSafeArea()
            
            Image("Group 15")
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
            //.frame(width: 0,height: 680 ,alignment: .topLeading)
                .frame(minWidth: 0,maxWidth: .infinity,alignment: .top)
                .frame(minHeight: 0, maxHeight: .infinity,alignment: .top)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    
                    VStack(alignment: .trailing, spacing: 1) {
                        Text("Dairy product")
                            .frame(maxWidth: .infinity,alignment: .trailing)
                        //.frame(width: 200,height: 30,alignment: .trailing)
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
                    TextField("USER NAME",text: $username)
                    //.foregroundStyle(.black)
                    //.frame(width: 350,height: 60)
                        .background(.white)
                        .cornerRadius(3)
                        .padding()
                    HStack(spacing: 15){
                        
                        
                        HStack{
                            
                            VStack{
                                if self.visible{
                                    
                                    
                                    TextField("PASSWORD", text: self.$pass)
                                }
                                else{
                                    SecureField("PASSWORD", text: self.$pass)
                                }
                            }
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                        }
                        
                    }
                    
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color"):.white,lineWidth:0))
                    .padding(.top,10)
                    
                    //                    TextField("password",text: $password)
                    //                        //.frame(width: 350,height: 60)
                    //                        .background(.white)
                    //                        .cornerRadius(3)
                    //                        .padding()
                }
                Spacer(minLength: 60)
                
                //Spacer()
                
                NavigationLink(
                    destination:Dashboard()
                        .toolbarRole(.editor),
                    label: {
                        //forgetbtn()
                        
                    })
                
                SignINbutton(toastManager: toastManager,username: $username,password: $pass)
                //})
                Spacer(minLength: 50)
                
                VStack(alignment:.center) {
                    Text("Powered by")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Image("logopic")
                        .resizable()
                        .frame(width: 50,height: 50)
                    Spacer(minLength: 50)
                }
            }
        }
        Toast(toastManager: toastManager)
            .padding(.bottom, 50)
        //                .navigationBarBackButtonHidden(true)
        //                .navigationBarItems(leading: SignINbutton)
    }
    }
    
    
    
}
//}
struct page:View {
    
    @StateObject private var viewModel = DataViewModel()
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    Button("GET", action: {
                        viewModel.fetchData()
                    })
                    
                    ForEach(viewModel.data) { item in
                        VStack(alignment: .leading) {
                            Text("title: \(item.title)")
                            Text("base_url: \(item.base_url)")
                        }
                    }
                    
                }
                
                HStack {
                    Spacer()
                    //EditButton()
                    Spacer()
                    Spacer()
                }
            }
            //.navigationTitle("Custom List")
            
        }
    }
}

struct DataItem: Codable, Identifiable {
    var id = UUID()
    let title: String
    let base_url: String
}

struct SignINbutton: View {
    @ObservedObject var toastManager: ToastManager
    @Binding var username:String
    @Binding var password:String
    @State private var isAuthenticated = false
    var body: some View {
                    VStack {
                        Button(action: {
                            signin()
                        }) {
                            Text("SIGN IN")
                                .frame(width: 350, height: 50, alignment: .center)
                                .background(Color(red: 25/255, green: 151/255, blue: 206/255))
                                .font(.headline)
                                .foregroundColor(.white)
                                .cornerRadius(9)
                        }

                        NavigationLink(destination: Dashboard(), isActive: $isAuthenticated) {
                            EmptyView()
                        }
                    }
        
    }
    
    func signin() {
        if validateForm() == false {
            return
        }
        
        let CompDet:[String] = (username.components(separatedBy: "-"))
        let url = URL(string: "https://admin.godairy.in/server/milk_url_config.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error while fetching data:", error)
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let fetchedData = try JSONDecoder().decode([String: DataItem].self, from: data)
                DispatchQueue.main.async {
                    let uppercaseCompSH = CompDet[0]
                    let CompSH: String = uppercaseCompSH.uppercased()
                    if let dataItem = fetchedData[CompSH]{
                        APIClient.shared.BaseURL = dataItem.base_url
                        userAuth()
                    }else{
                        toastManager.showToast(message: "Enter correct Usernmae and Password")
                    }
                }
            } catch let jsonError {
                print("Failed to decode JSON:", jsonError)
            }
        }
        task.resume()
    }
    
   
    func userAuth() {
           let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL + "get/GoogleLogin&Email=\(username)&UserID=\(username)&Pwd=\(password)&AppVer=iOS&DvID=test"
           guard let url = URL(string: urlString) else {
               print("Invalid URL")
               return
           }
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               if let error = error {
                   print("Error: \(error.localizedDescription)")
                   return
               }
               guard let httpResponse = response as? HTTPURLResponse,
                     (200...299).contains(httpResponse.statusCode),
                     let data = data else {
                   print("Invalid response or no data")
                   return
               }
               do {
                   let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                   print("Response: \(jsonResponse)")

                   if let jsonObject = jsonResponse as? [String: Any] {
                       if let success = jsonObject["success"] as? Int, success == 1 {
                           DispatchQueue.main.async {
                               self.isAuthenticated = true
                           }
                       } else {
                           DispatchQueue.main.async {
                               toastManager.showToast(message: "Enter correct Password")
                           }
                       }
                   }
               } catch {
                   print("JSON parsing error: \(error.localizedDescription)")
               }
           }
           task.resume()
       }
    
    func validateForm() -> Bool {
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            toastManager.showToast(message: " Enter Username")
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
            // .background(Color.white)
                .font(.caption)
            //  .background(Color(red:255/255,green: 151/255,blue: 206/255))
                .foregroundColor(.primary)
        }
        .padding()
    }
}
*/
/*import SwiftUI
import Combine

struct Login: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var isValid: Bool = false
    
    // Validation rules
    private let emailPredicate = try! NSRegularExpression(
        pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
        options: []
    )
    
    private let passwordRules: [(String, (String) -> Bool)] = [
        ("At least 8 characters long", { $0.count >= 8 }),
        ("Contains uppercase letter", { $0.contains(where: { $0.isUppercase }) }),
        ("Contains lowercase letter", { $0.contains(where: { $0.isLowercase }) }),
        ("Contains number", { $0.contains(where: { $0.isNumber }) }),
        ("Contains special character", { $0.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) }) })
    ]
    
    private func validateEmail() {
        let range = NSRange(location: 0, length: email.utf16.count)
        let matches = emailPredicate.matches(in: email, options: [], range: range)
        
        if email.isEmpty {
            emailError = "Email is required"
        } else if matches.isEmpty {
            emailError = "Please enter a valid email address"
        } else {
            emailError = nil
        }
        updateValidState()
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = "Password is required"
        } else {
            let failedRules = passwordRules.filter { !$0.1(password) }
            if !failedRules.isEmpty {
                passwordError = "Password must have: " + failedRules.map { $0.0 }.joined(separator: ", ")
            } else {
                passwordError = nil
            }
        }
        updateValidState()
    }
    
    private func updateValidState() {
        isValid = emailError == nil && passwordError == nil && !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        VStack {
            // Back button
            /*HStack {
                Button(action: {
                    // Handle back action
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
            }*/
            
            // Splash image and title
            
            ZStack {
                Color(red: 0.13, green: 0.65, blue: 0.85)
                    .ignoresSafeArea()
                    //.frame(height: 300)
                Image("Group 15")
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0,maxWidth: .infinity,alignment: .top)
                    .frame(minHeight: 0,maxHeight: .infinity,alignment: .top)
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack (alignment:.trailing,spacing: 4){
                    
                    Text("Dairy Product")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Delivery Solutions")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        //.multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(.all,50)
            }
           // Spacer(minLength: 100)
            .frame(height: 300)
 Spacer(minLength: 50)
 // Login form
            VStack(spacing: 20) {
                // Email field
                VStack(alignment: .leading, spacing: 8) {
                    Text("USER NAME")
                        .foregroundColor(.gray)
                        .font(.caption)
                    
                    HStack {
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .onChange(of: email) { _ in
                                validateEmail()
                            }
                        
                        if !email.isEmpty && emailError == nil {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(emailError != nil ? Color.red : Color.clear, lineWidth: 1)
                    )
                    
                    if let error = emailError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // Password field
                VStack(alignment: .leading, spacing: 8) {
                    Text("PASSWORD")
                        .foregroundColor(.gray)
                        .font(.caption)
                    
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .onChange(of: password) { _ in
                        validatePassword()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(passwordError != nil ? Color.red : Color.clear, lineWidth: 1)
                    )
                    
                    if let error = passwordError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // Password rules
                if !password.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(passwordRules, id: \.0) { rule, validate in
                            HStack {
                                Image(systemName: validate(password) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(validate(password) ? .green : .gray)
                                Text(rule)
                                    .font(.caption)
                                    .foregroundColor(validate(password) ? .green : .gray)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                // Forget Password link
                HStack {
                    Spacer()
                    Button("Forget Password?") {
                        // Handle forget password action
                    }
                    .foregroundColor(.gray)
                }
                
                // Sign In button
                Button(action: {
                    // Handle sign in action
                }) {
                    Text("SIGN IN")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValid ? Color(red: 0.13, green: 0.65, blue: 0.85) : colorData.shared.Appcolor)
                        .cornerRadius(8)
                }
                .disabled(!isValid)
                .padding(.top)
            }
            .padding()
            
            Spacer()
            
            // Footer
            VStack {
                Text("Powered by")
                    .foregroundColor(.gray)
                Image("logopic")
                    .resizable()
                   // .scaledToFit()
                    .frame(width: 50,height: 50)
            }
            .padding(.bottom)
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
*/
