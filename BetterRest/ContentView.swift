//
//  ContentView.swift
//  BetterRest
//
//  Created by paucrow on 18/07/2022.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    let coffeeAmounts = [0, 1, 2, 3, 4, 5, 6, 7 ,8]

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }

    var calculatedBedtime: String {
        var bedtime = ""
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep


            bedtime = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            bedtime = "Sorry, there was an error calculating your bedtime"
        }
        return bedtime
    }


    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                        .font(.headline)
                }

                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step:0.25)
                } header:  {
                    Text("Desired amount of sleep")
                        .font(.headline)
                }

                Section {
                    Picker("cups", selection: $coffeeAmount) {
                        ForEach(coffeeAmounts, id: \.self) {
                            Text($0, format: .number)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Daily coffee intake")
                        .font(.headline)
                }
                Section {
                    Text(calculatedBedtime)
                }
            }
//            Initial code before updating follwoing challenge
//            .navigationTitle("BetterRest")
//            .toolbar {
//                Button("Calculate", action: calculateBedtime)
//            }
//            .alert(alertTitle, isPresented: $showingAlert) {
//                Button("OK") { }
//            } message: {
//                Text(alertMessage)
//            }


        }
    }

//            Initial functin used before updating follwoing challenge
//    func calculateBedtime() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//
//            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//
//            let sleepTime = wakeUp - prediction.actualSleep
//
//            alertTitle = "Your ideal bedtime is..."
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was an error calculating your bedtime"
//        }
//        showingAlert = true
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
