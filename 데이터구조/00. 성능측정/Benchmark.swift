//
//  Benchmark.swift
//  Swift-Lab
//
//  Created by 김동현 on 1/5/26.
//

import Foundation

struct Benchmark: @unchecked Sendable {
    let name: String
    let iteration: Int
    let prepare: () -> () -> Void
    
    init(name: String,
         iteration: Int = 1,
         prepare: @escaping () -> () -> Void
    ) {
        self.name = name
        self.iteration = iteration
        self.prepare = prepare
    }
    
    /// iterations 만큼 실행하는 단일 측정
    private func measureOnce() -> CFAbsoluteTime {
        let action = prepare()   // 데이터 생성은 여기서
        let start = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iteration {
            action()             // 실행부만 측정
        }
        return CFAbsoluteTimeGetCurrent() - start
    }
    
    /// 3번 측정해서 최소값 반환 (오차 제거)
    func measure() -> BenchmarkResult {
        let t1 = measureOnce()
        let t2 = measureOnce()
        let t3 = measureOnce()
        
        return BenchmarkResult(
            time: min(t1, t2, t3),
            memoryMB: currentMemoryMB()
        )
    }
}

struct BenchmarkRunner {
    var benchmarks: [Benchmark]
    
    init(_ benchmarks: Benchmark...) {
        self.benchmarks = benchmarks
    }
    
    func run() {
            let maxLength = benchmarks.map { $0.name.count }.max() ?? 10

            let nameTitle = "Benchmark".padding(toLength: maxLength, withPad: " ", startingAt: 0)
            let timeTitle = "Time(sec)".padding(toLength: maxLength, withPad: " ", startingAt: 0)
            let memTitle  = "Memory(MB)".padding(toLength: maxLength, withPad: " ", startingAt: 0)

            print()
            print("""
            |\(nameTitle)|\(timeTitle)|\(memTitle)|
            |:\(String(repeating: "-", count: maxLength - 1))|\
            \(String(repeating: "-", count: maxLength - 1)):|\
            \(String(repeating: "-", count: maxLength - 1)):|
            """)

            var results = ContiguousArray<BenchmarkResult?>(
                repeating: nil,
                count: benchmarks.count
            )

            let group = DispatchGroup()
            let queue = DispatchQueue(label: "benchmark.runner.queue", attributes: .concurrent)

            for (index, benchmark) in benchmarks.enumerated() {
                group.enter()
                queue.async {
                    results[index] = benchmark.measure()
                    group.leave()
                }
            }

            group.wait()

            for (index, benchmark) in benchmarks.enumerated() {
                guard let result = results[index] else { continue }

                let name = benchmark.name
                    .padding(toLength: maxLength, withPad: " ", startingAt: 0)
                let time = String(format: "%.6f", result.time)
                    .padding(toLength: maxLength, withPad: " ", startingAt: 0)
                let memory = String(format: "%.2f", result.memoryMB)
                    .padding(toLength: maxLength, withPad: " ", startingAt: 0)

                print("|\(name)|\(time)|\(memory)|")
            }

            print()
        }
}

import MachO

func currentMemoryMB() -> Double {
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(
        MemoryLayout<mach_task_basic_info>.size / MemoryLayout<natural_t>.size
    )

    let kerr = withUnsafeMutablePointer(to: &info) {
        $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
            task_info(
                mach_task_self_,
                task_flavor_t(MACH_TASK_BASIC_INFO),
                $0,
                &count
            )
        }
    }

    guard kerr == KERN_SUCCESS else { return -1 }
    return Double(info.resident_size) / 1024 / 1024 // MB
}

struct BenchmarkResult {
    let time: CFAbsoluteTime
    let memoryMB: Double
}
