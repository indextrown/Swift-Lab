import Foundation

/*
 https://dev-mandos.tistory.com/190
 */

struct Queue<T> {
    private var array: [T] = []
    private var index: Int = 0
    
    var isEmpty: Bool {
        return array.count - index <= 0
    }
    
    var top: T? {
        return isEmpty ? nil : array[index]
    }
    
    var count: Int {
        return array.count - index
    }
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    @discardableResult
    mutating func pop() -> T? {
        guard !self.isEmpty else { return nil }
        
        let element = array[index]
        index += 1
        return element
    }
}

var queue = Queue<Int>()
queue.push(1)
queue.push(2)
queue.push(3)

print(queue.pop() ?? 0)

while let element = queue.pop() {
    print(element)
}

