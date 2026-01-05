import Cocoa

struct Queue<T> {
    private var enqueueStack: [T] = []
    private var dequeueStack: [T] = []
    
    var isEmpty: Bool {
        return enqueueStack.isEmpty && dequeueStack.isEmpty
    }
    
    var count: Int {
        return enqueueStack.count + dequeueStack.count
    }
    
    var top: T? {
        if let last = dequeueStack.last {
            return last
        }
        return enqueueStack.first
    }
    
    mutating func push(_ element: T) {
        enqueueStack.append(element)
    }
    
    @discardableResult
    mutating func pop() -> T? {
        if dequeueStack.isEmpty {
            dequeueStack = enqueueStack.reversed()
            enqueueStack.removeAll()
        }
        return dequeueStack.popLast()
    }
}
