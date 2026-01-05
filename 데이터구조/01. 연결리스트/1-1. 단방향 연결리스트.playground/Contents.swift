import Cocoa

/**
 연결리스트
 - 각 노드가 데이터와 포인터를 가지고 한 줄로 연결되어 있는 방식으로 데이터를 저장하는 자료 구조
 - 노드들이 메모리 상에서 연속적으로 저장되지 않고, 참조를 통해 논리적으로 연결된다
 - 단일 연결 리스트(Singly Linked List), 이중 연결 리스트(Doubly Linked List), 원형 연결 리스트 등이 있다
 
 장점
 - 특정 노드 위치를 알고 있는 경우, 늘어선 노드의 중간지점에서도 자료의 추가와 삭제가 O(1)의 시간에 가능하다
 
 단점
 - 배열이나 트리 구조와 달리 임의 접근(Random Access)이 불가능하여 특정 위치의 데이터를 검색하는 데 O(n)의 시간이 소요된다
 
 https://babbab2.tistory.com/86
 https://fomaios.tistory.com/entry/DataStructure-연결리스트에-대해-알아보자Linked-List
 https://mechanicdong.tistory.com/52
 https://green1229.tistory.com/123
 https://minjae1995.tistory.com/40
 https://pooh-footprints.tistory.com/entry/Swift-자료구조-연결-리스트Linked-List
 
 A -> B -> C -> D
 
 Operator function '==' requires that 'T' conform to 'Equatable'
 - search에서 node?.data와 node비교시 제네릭으로 선언된 자료형을 런타임 전까지 모른다
 - Equatable 프로토콜이 채택되어 있는 자료형만 가능하도록 해주자
 
 */

class Node<T> {
    let data: T
    var next: Node<T>?
    
    init(data: T, next: Node<T>? = nil) {
        self.data = data
        self.next = next
    }
}

/// 단일 연결 리스트
class LinkedList<T: Equatable> {
    
    /// 리스트의 시작 노드
    private var head: Node<T>?
    
    /// 리스트 맨 뒤에 데이터 추가
    /// 시간복잡도: O(n)
    func append(data: T) {
        // 헤더가 비어있다면 헤더에 데이터 추가
        if head == nil {
            head = Node(data: data)
            return
        }
        
        // 마지막 노드까지 이동 및 데이터 추가
        var node = head
        while node?.next != nil {
            node = node?.next
        }
        node?.next = Node(data: data)
    }
    
    /// index 위치에 데이터 삽입
    /// - index == 0 이면 head 앞에 삽입
    /// - index 초과 이면 맨 뒤에 섭입
    /// - 시간복잡되 O(n)
    func insert(data: T, at index: Int) {
        guard index >= 0 else { return }
        
        // index == 0 -> head 교체
        if index == 0 {
            let newNode = Node(data: data)
            newNode.next = head
            head = newNode
            return
        }
        
        // 중간에 데이터 삽입(index-1번째 노드까지 이동)
        // 더 이상 다음 노드가 없거나 반복문만큼 진행
        // index가 1이면 실행 안됨
        var node = head
        for _ in 0..<(index-1) {
            if node?.next == nil { break }
            node = node?.next
        }
        
        // 현재 노드 뒤에 새 노드 삽입
        let nextNode = node?.next
        node?.next = Node(data: data)
        node?.next?.next = nextNode
    }
    
    /// 연결리스트의 마지막 노드를 제거
    /// - 리스트가 비어 있으면 아무것도 하지 않음
    /// - 노드가 1개면 head 제거
    /// - 시간복잡도: O(n)
    func removeLast() {
        // 리스트가 비어있다면 종료
        if head == nil { return }
        
        // 노드가 1개이면 head 삭제
        if head?.next == nil {
            head = nil
            return
        }
        
        // 데이터가 여러개이면 마지막 노드의 앞 노드까지 이동
        var node = head
        while node?.next?.next != nil {
            node = node?.next
        }
        
        // 마지막 노드 제거
        node?.next = nil
    }
    
    /// index 위치의 노드 제거
    /// - index == 0: head 제거
    func remove(at index: Int) {
        // index가 0 이상이고 리스트가 비어있지 않을 때만 진행
        guard index >= 0, head != nil else { return }
        
        // index == 0 -> head 삭제
        if index == 0 {
            head = head?.next
            return
        }
        
        // index-1번째 노드까지 이동
        var node = head
        for _ in 0..<(index-1) {
            // 더 이상 삭제할 다음 노드가 없으면 중단
            if node?.next?.next == nil { break }
            node = node?.next
        }
        
        // 다음 노드를 건너뛰어 연결(삭제)
        node?.next = node?.next?.next
    }
    
    /// 특정 데이터를 가진 노드 검색
    /// 시간복잡도: O(n)
    func search(data: T) -> Node<T>? {
        var node = head
        while node != nil {
            if node?.data == data {
                return node
            }
            node = node?.next
        }
        return nil
    }
    
    /// 전체 노드 출력
    func printList() {
        var node = head
        while let current = node {
            print(current.data, terminator: " -> ")
            node = current.next
        }
        print("nil")
    }
}

/*
 해당 인덱스 추가시 기존 인덱스 뒤로 밀어내거나
 해당 인덱스 삭제시 기존 인덱스 삭제
 */
print()
let list = LinkedList<Int>()
list.append(data: 10)
list.append(data: 20)
list.append(data: 30)
list.printList()                // 10 -> 20 -> 30

list.insert(data: 5, at: 0)
list.printList()                // 5 -> 10 -> 20 -> 30

list.insert(data: 25, at: 3)    // 5 -> 10 -> 20 -> 25 -> 30
list.printList()

list.remove(at: 2)
list.printList()                // 5 -> 10 -> 25 -> 30

print(list.search(data: 25) != nil)
print(list.search(data: 42) != nil)

