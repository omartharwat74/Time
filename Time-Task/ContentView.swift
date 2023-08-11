//
//  ContentView.swift
//  Time-Task
//
//  Created by Omar Tharwat on 14/07/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedOption = 0
    @State private var time = Date()
    @State private var minutes = ""
    @State private var updatedTime = ""
    @State private var showInstructions = false
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var selectedMinute = 0
    @State private var selectedHour = 0
    @State private var showHstack = false
    @State private var showAlert = false
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("TIME OUT")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Oppenheimer Edition")
                .font(.title3)
                .fontWeight(.medium)
            // .foregroundColor(.blue)
            
            Picker(selection: $selectedOption, label: Text("اختر الخيار")) {
                Text("الوقت الحالي").tag(0)
                Text("تخصيص الوقت").tag(1)
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedOption) { newValue in
                if newValue == 0 {
                    time = Date()
                } else {
                    selectedHours = 0
                    selectedMinutes = 0
                }
                updatedTime = ""
            }
            
            if selectedOption == 1 {
                VStack{
                    DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack{
                        Toggle("",isOn: $showHstack.animation())
                            .labelsHidden()
                        Text("اختر المده باستخدام الساعات والدقائق")
                            .fontWeight(.medium)
                    }
                    if showHstack {
                        HStack {
                            Picker("Hour", selection: $selectedHour) {
                                ForEach(0...5, id: \.self) { hour in
                                    Text("\(hour)")
                                        .foregroundColor(Color(hex: "f56f3b"))
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100)
                            
                            Text(":")
                            
                            Picker("Minute", selection: $selectedMinute) {
                                ForEach(0...60, id: \.self) { minute in
                                    Text(String(format: "%02d", minute))
                                        .foregroundColor(Color(hex: "f56f3b"))
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100)
                        }
                        //                        .opacity(showHstack ? 1 : 0)
                        .padding(.horizontal)
                    }else{
                        TextField("أدخل الدقائق", text: $minutes)
                            .padding(.horizontal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .preferredColorScheme(.dark)
                            .foregroundColor(Color.white)
                        //                            .opacity(showHstack ? 0 : 1)
                    }
                    
                    
                    
                }
                
            }
            if selectedOption == 0{
                TextField("أدخل الدقائق", text: $minutes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                    .preferredColorScheme(.dark)
                    .foregroundColor(Color.white)
            }
            
            Button(action: {
                if let minutes = Int(minutes){
                    calculateTime()
                }else if selectedHour != 0 || selectedMinute != 0{
                    calculateTime()
                }
                else{
                    showAlert = true
                }
            }) {
                Text("احسب")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color(hex: "f56f3b"))
                    .cornerRadius(10)
            }
            
            Spacer()
            
            if !updatedTime.isEmpty {
                Text("وقت خروجك: \(updatedTime)")
                    .font(.title)
                    .foregroundColor(.green)
            }
            
            Button(action: {
                showInstructions.toggle()
            }) {
                Text("التعليمات")
                    .font(.title2)
                // .foregroundColor(.blue)
            }
            .padding()
            .sheet(isPresented: $showInstructions) {
                InstructionsView()
            }
        }
        .foregroundColor(Color(hex: "f56f3b"))
        .background(Image("opp_image"))
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("خطأ"),
                message: Text("يرجي ادخال ارقام باللغه الانجليزيه فقط"),
                dismissButton: .default(Text("حسنآ"))
            )
        }
    }
    
    
    
    private func calculateTime() {
        let calendar = Calendar.current
        var updatedTime = time
        
        if selectedOption == 0 {
            if let minutes = Int(minutes) {
                updatedTime = calendar.date(byAdding: .minute, value: minutes, to: updatedTime)!
            }
        }else if selectedHour != 0 || selectedMinute != 0{
            let modifiedTime = calendar.date(byAdding: .hour, value: selectedHour, to: updatedTime)!
            updatedTime = calendar.date(byAdding: .minute, value: selectedMinute, to: modifiedTime)!
        }else{
            if let minutes = Int(minutes) {
                updatedTime = calendar.date(byAdding: .minute, value: minutes, to: updatedTime)!
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        self.updatedTime = dateFormatter.string(from: updatedTime)
    }
    
    struct InstructionsView: View {
        var body: some View {
            VStack(spacing: 20) {
                Text("تقوم أغلب دور السينما بإضافة إعلانات متوسط مدتها عشر دقائق")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("البرنامج في الوقت الحالي لا يدعم إدخال الأرقام العربية (سيتم دعم الأرقام العربية في التحديثات القادمة)")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("زر مشاركة النتيجة سيتم إضافته في التحديثات القادمة.")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("يرجى مشاركة المشاكل التقنية عبر صفحة تواصل مع المطور.")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                
                
                Link("التواصل مع المطور", destination: URL(string: "https://www.instagram.com/hussainux/")!)
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xff) / 255.0
        let g = Double((rgb >> 8) & 0xff) / 255.0
        let b = Double(rgb & 0xff) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
