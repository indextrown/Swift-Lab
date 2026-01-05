//
//  main.swift
//  Swift-Lab
//
//  Created by 김동현 on 1/5/26.
//

import Foundation

/*
 https://dev-mandos.tistory.com/190
 
 // 압축 미적용
 |Benchmark       |Time(sec)       |Memory(MB)      |
 |:---------------|---------------:|---------------:|
 |IndexQueue      |0.189162        |83.08           |
 |DoubleStackQueue|0.263125        |98.73           |
 
 // 압축 적용
 |Benchmark       |Time(sec)       |Memory(MB)      |
 |:---------------|---------------:|---------------:|
 |IndexQueue      |0.193484        |100.86          |
 |DoubleStackQueue|0.262650        |101.17          |

 
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
        
        // 압축
        // 인덱스가 충분히 커졌고 실제로 안쓰는 공간이 절반 이상이면 정리
        if index > 1024 && index * 2 >= array.count {
            array.removeFirst(index)
            index = 0
        }
        
        return element
    }
}

struct DoubleStackQueue<T> {
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

@main
struct Main {
    static func main() {
        let runner = BenchmarkRunner(
            Benchmark(name: "IndexQueue") {
                var queue = Queue<Int>()
                return {
                    for i in 0..<1_000_000 {
                        queue.push(i)
                    }
                    for _ in 0..<1_000_000 {
                        queue.pop()
                    }
                }
            },
            Benchmark(name: "DoubleStackQueue") {
                var queue = DoubleStackQueue<Int>()
                return {
                    for i in 0..<1_000_000 {
                        queue.push(i)
                    }
                    for _ in 0..<1_000_000 {
                        queue.pop()
                    }
                }
            }
        )
        
        runner.run()
    }
}
