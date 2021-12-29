
import SwiftUI

let HContentPadding = 10.0
let VContentPadding = 5.0

// Flexible Collection View -
//
//  A simple container view that automatically expands as content is
//  added, with proper layout flow (wrap around).
//
// Example usage:
//   FlexCollection(elementCount: 30, maxUsableWidth: 390) {
//        index in
//        Text("Index: \(index)")
//   }
//
// Specify elementCount with the number of elements in the collection.
// Provide a closure that generates one element. It will be called
// 'elementCount' times to generate the contents within the collection.
//
// See github.com/ramenhut/flexcollection for more information.

struct FlexCollection<Content: View> : View {
    // The number of elements currently contained in the collection.
    var elementCount: Int
    // The maximum horizontal span that may be occupied by this collection.
    // We do not infer this via GeometryReader because we want our collection
    // to only span the space used by its contents. If individual Content
    // elements appear to layout incorrectly, check to ensure that the max
    // usable width is less than or equal to the available space provided
    // by the parent.
    var maxUsableWidth = UIScreen.main.bounds.size.width
    // A generator that is supplied by the caller. This will be invoked once
    // for each index in the range of 0..<elementCount to generate each of
    // the views contained within this container.
    var createElement: (Int) -> Content
    // Stores the computed widths of each of our Content elements in the
    // collection. Sizing is computed with on-screen coordinates below.
    @State private var elementWidths: [Int:CGFloat] = Dictionary<Int, CGFloat>()

    // This method computes the indices that belong in each row/col position.
    // When building the actual view, we'll simply follow the layout of our
    // indices, re-calling the generators with the appropriate index at each
    // location.
    private func layoutContent(maxWidth: CGFloat = UIScreen.main.bounds.size.width) -> [[Int]] {
        var result: [[Int]] = Array<Array<Int>>()
        var totalWidth = 0.0

        for index in 0..<elementCount {
            if let itemWidth = elementWidths[index] {
                if (totalWidth + itemWidth < maxWidth) {
                    totalWidth += itemWidth
                    if (result.count == 0 ) {
                        result.append([index])
                    } else {
                        result[result.count - 1].append(index)
                    }
                } else {
                    totalWidth = itemWidth
                    result.append([index])
                }
            }
        }

        return result
    }

    // Cache the size of the current indexed content generated in pass 1.
    // We'll leverage this when laying out the content in pass 2.
    private func measureView(_ geometry: GeometryProxy, _ index: Int) -> some View {
        DispatchQueue.main.async {
            self.elementWidths[index] = geometry.size.width
        }
        return Color.clear
    }
    
    var body: some View {
        if (elementWidths.count != elementCount) {
            DispatchQueue.main.async {
                self.elementWidths.removeAll()
            }
        }
        
        return ZStack {
            Group {
                // Layer 1: measure the sizes of our content views. The structure
                // must remtain intact to avoid visible flicker, but we only
                // genereate elements if sizing is actually required.
                ForEach(0..<elementCount, id:\.self) { index in
                    if (elementWidths.count != elementCount) {
                        createElement(index)
                            .padding(.trailing, HContentPadding)
                            .background(GeometryReader { geometry in
                                measureView(geometry, index)
                            })
                    }
                }
            }
            .hidden()
            
            VStack (spacing: 0) {
                // Layer 2: layout our content views with sizes provided.
                ForEach(layoutContent(maxWidth:maxUsableWidth), id:\.self) { lane in
                    HStack (spacing: 0) {
                        ForEach(lane, id:\.self) { index in
                            createElement(index)
                                .padding(.trailing, HContentPadding)
                        }
                        Spacer()
                    }.padding(.vertical, VContentPadding)
                }
            }
        }
    }
}
