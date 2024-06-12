//
//  ContentView.swift
//  BetterRest
//
//  Created by HTLILI on 10/06/2024.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmout = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

   static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now    }
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up ?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmout.formatted()) hours", value: $sleepAmout, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    //"^[\(coffeeAmount) cup](inflect: true)"
                    //This is to adapt th eplural forms cup -> au pluriel
                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                }
            }
        .navigationTitle("BetterRest")
        .toolbar {
            Button("Calculate", action: calculateBedTime)
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        }message: {
            Text(alertMessage)
        }
    }
    }
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let component = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (component.hour ?? 0) * 60 * 60
            let minute = (component.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double((hour + minute)), estimatedSleep: sleepAmout, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedTime is "
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
           alertTitle = "Error!!!"
            alertMessage = "Sorry there was a problem calculating your bedtime"
        }
        showingAlert = true
    }
}
    #Preview {
        ContentView()
    }


