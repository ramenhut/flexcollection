
import SwiftUI

let chips = ["One", "Two", "Three", "Four",
             "Five", "Six", "Seven", "Eight",
             "Nine", "Ten", "Eleven", "Twelve",
             "Thirteen", "Fourteen", "Fifteen"]

struct CircleModel : Hashable {
    var id = UUID()
    var color: Color
    var width: CGFloat
}

let circles = [CircleModel(color:Color(red:149/255.0, green:181/255.0, blue:148/255.0), width: 70),
               CircleModel(color:Color(red:231/255.0, green:189/255.0, blue:209/255.0), width: 60),
               CircleModel(color:Color(red:252/255.0, green:222/255.0, blue:215/255.0), width: 30),
               CircleModel(color:Color(red:240/255.0, green:190/255.0, blue:166/255.0), width: 15),
               CircleModel(color:Color(red:136/255.0, green:186/255.0, blue:205/255.0), width: 45),
               CircleModel(color:Color(red:111/255.0, green:172/255.0, blue:200/255.0), width: 25)]

struct ContentView: View {
    @State var activeChips = chips
    @State var activeCircles = circles
    @State var selection = "Text"
    
    var body: some View {
        
        TabView (selection:$selection) {
            
            /*
             * Text Demo
             */
            
            VStack {
                FlexCollection(elementCount: 30, maxUsableWidth: 390) { index in
                    Text("Index: \(index)")
                        .padding()
                        .foregroundColor((index % 2 == 0) ? .black : .white)
                        .background((index % 2 == 0) ? Color.white : Color.black)
                        .border(.gray)
                }.padding()
            
                Spacer()
            }
            .tabItem {
                Image(systemName: "doc.text")
                Text("Text")
            }.tag("Text")
            
            /*
             * Circles Demo
             */
            
            VStack {
                ScrollView {
                    FlexCollection(elementCount: activeCircles.count, maxUsableWidth: 390) { index in
                        Circle()
                            .foregroundColor(activeCircles[index].color)
                            .frame(width: activeCircles[index].width, height:activeCircles[index].width)
                            .shadow(radius: 2.0)
                    }.padding()
                
                    Spacer()
                }
                
                Divider()
                
                Button {
                    var newCircle = circles[Int.random(in:0..<circles.count)]
                    newCircle.id = UUID()
                    activeCircles.append(newCircle)
                } label: {
                    Circle()
                        .foregroundColor(.black)
                        .frame(width: 50.0, height: 50.0)
                        .shadow(radius:5.0)
                        .overlay {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                        .padding()
                }
            }.tabItem {
                Image(systemName: "circles.hexagongrid")
                Text("Circles")
            }.tag("Circles")
            
            /*
             * Chips Demo
             */
            
            VStack {
                ScrollView {
                    FlexCollection(elementCount: activeChips.count, maxUsableWidth: 390) { index in
                        ChipButton(name:activeChips[index]) {
                            let target = activeChips[index]
                            activeChips = activeChips.filter { $0 != target }
                        }
                    }.padding()
                
                    Spacer()
                }
                
                Divider()
                
                Button {
                    activeChips.append(chips[Int.random(in:0..<chips.count)])
                } label: {
                    Circle()
                        .foregroundColor(.black)
                        .frame(width: 50.0, height: 50.0)
                        .shadow(radius:5.0)
                        .overlay {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                        .padding()
                }
            }.tabItem {
                Image(systemName: "memorychip")
                Text("Chips")
            }.tag("Chips")
        }
    }
}
