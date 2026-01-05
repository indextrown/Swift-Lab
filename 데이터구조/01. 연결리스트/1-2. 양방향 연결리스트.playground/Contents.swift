import Cocoa

class Node<T> {
    var prev: Node<T>?
    var data: T
    var next: Node<T>?
    
    init(prev: Node<T>? = nil, data: T, next: Node<T>? = nil) {
        self.prev = prev
        self.data = data
        self.next = next
    }
}

class DoublyLinkedList<T: Equatable> {
    private var head: Node<T>?
    private var tail: Node<T>?
    
    /// 리스트 맨 뒤에 데이터 추가
    /// 시간복잡도: O(1)
    func append(_ data: T) {
        let newNode = Node(data: data)
        
        // 리스트가 비어 있는 경우
        if head == nil {
            head = newNode
            tail = newNode
            return
        }
        
        // 기존 tail 뒤에 연결
        newNode.prev = tail
        tail?.next = newNode
        tail = newNode
    }
    
    /// 마지막 노드 제거
    /// 시간복잡도: O(1)
    func removeLast() {
        guard let tailNode = tail else { return }

        // 노드가 1개인 경우
        if head === tail {
            head = nil
            tail = nil
            return
        }

        tail = tailNode.prev
        tail?.next = nil
    }
    
    /// 특정 데이터 검색
    /// 시간복잡도: O(n)
    func search(_ data: T) -> Node<T>? {
        var node = head

        while node != nil {
            if node?.data == data {
                return node
            }
            node = node?.next
        }

        return nil
    }
    
    /// 디버그 출력
    func printForward() {
        var node = head
        while let current = node {
            print(current.data, terminator: " <-> ")
            node = current.next
        }
        print("nil")
    }

    func printBackward() {
        var node = tail
        while let current = node {
            print(current.data, terminator: " <-> ")
            node = current.prev
        }
        print("nil")
    }
}

print()
let list = DoublyLinkedList<Int>()

list.append(10)
list.append(20)
list.append(30)

list.printForward()
// 10 <-> 20 <-> 30 <-> nil

list.printBackward()
// 30 <-> 20 <-> 10 <-> nil

list.removeLast()
list.printForward()
// 10 <-> 20 <-> nil

print(list.search(20) != nil) // true
print(list.search(99) != nil) // false
