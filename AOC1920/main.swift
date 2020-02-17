//
//  main.swift
//  AOC2019
//
//  Created by Heiko Goes on 25.01.20.
//  Copyright © 2020 Heiko Goes. All rights reserved.
//

import Foundation

extension StringProtocol {
    func indexDistance(of element: Element) -> Int? { firstIndex(of: element)?.distance(in: self) }
    func indexDistance<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.lowerBound.distance(in: self) }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

func getOuterRange(theMap: [String]) -> CGRect {
    let xIndexes: [(minX: Int?, maxX: Int?)] = theMap.map{
        let minX = $0.firstIndex(of: "#")?.distance(in: $0)
        let maxX = $0.lastIndex(of: "#")?.distance(in: $0)
        return (minX, maxX)
    }

    let xIndexesWithIndex = zip(xIndexes, 0..<theMap.count)
    let filtered = xIndexesWithIndex.filter{ $0.0.minX != nil && $0.0.maxX != nil }
    let minY = filtered.first!.1
    let maxY = filtered.last!.1

    let minX = filtered.min(by: { left, right in
        if right.0.minX == nil {
            return true
        }

        if left.0.minX == nil {
            return false
        }

        return left.0.minX! < right.0.minX!
        })!.0.minX!

    let maxX = filtered.max(by: { left, right in
        if right.0.maxX == nil {
            return true
        }

        if left.0.maxX == nil {
            return false
        }

        return left.0.maxX! < right.0.maxX!
        })!.0.maxX!

    return CGRect(x: minX,
                  y: minY,
                  width: maxX - minX,
                  height: maxY - minY)
}

func getInnerRange(theMap: [String], outerRange: CGRect) -> CGRect {
    let zipped = zip(theMap, 0..<theMap.count)
    let filteredY = zipped.filter{ $0.1 >= Int(outerRange.minY) && $0.1 <= Int(outerRange.maxY) }
    let filteredXY = filteredY.map{ (string: $0.0[Int(outerRange.minX)...Int(outerRange.maxX)], y: $0.1) }

    let xIndexes: [(minX: Int?, maxX: Int?, y: Int)] = filteredXY.map{
        let minX = $0.string.firstIndex(of: " ")?.distance(in: $0.string)
        let maxX = $0.string.lastIndex(of: " ")?.distance(in: $0.string)
        return (minX, maxX, $0.y)
    }.filter{ $0.minX != nil && $0.maxX != nil }

    let minY = xIndexes.first!.y - 1
    let maxY = xIndexes.last!.y + 1

    let minX = xIndexes.min(by: { left, right in
        if right.minX == nil {
            return true
        }

        if left.minX == nil {
            return false
        }

        return left.minX! < right.minX!
    })!.minX! + Int(outerRange.minX) - 1

    let maxX = xIndexes.max(by: { left, right in
        if right.maxX == nil {
            return true
        }

        if left.maxX == nil {
            return false
        }

        return left.maxX! < right.maxX!
    })!.maxX! + Int(outerRange.minX) + 1

    return CGRect(x: minX,
                  y: minY,
                  width: maxX - minX + 1,
                  height: maxY - minY + 1)

}

// ---------------------------------------------------------

class Node<T> {
    var value: T? = nil
    var next: Node<T>? = nil
    var prev: Node<T>? = nil

    init() {
    }

    init(value: T) {
        self.value = value
    }
}

class Queue<T> {

var count: Int = 0

var head: Node<T> = Node<T>()

var tail: Node<T> = Node<T>()

var currentNode : Node<T> = Node<T>()

    init() {
    }

    func isEmpty() -> Bool {
        return self.count == 0
    }

    func next(index:Int) -> T? {

        if isEmpty() {
            return nil
        } else if self.count == 1 {
            let temp: Node<T> = currentNode
            return temp.value
        } else if index == self.count{
            return currentNode.value

        } else {
            let temp: Node<T> = currentNode
            currentNode = currentNode.next!
            return temp.value
        }

    }

    func setCurrentNode(){
        currentNode = head
    }

    func enQueue(key: T) {
        let node = Node<T>(value: key)
        if self.isEmpty() {
            self.head = node
            self.tail = node
        } else {
            node.next = self.head
            self.head.prev = node
            self.head = node
        }

        self.count += 1
    }

    func deQueue() -> T? {
        if self.isEmpty() {
            return nil
        } else if self.count == 1 {
            let temp: Node<T> = self.tail
            self.count -= 1
            return temp.value
        } else {
            let temp: Node<T> = self.tail
            self.tail = self.tail.prev!
            self.count -= 1
            return temp.value
        }
    }

    //retrieve the top most item
    func peek() -> T? {
        if isEmpty() {
            return nil
        }

        return head.value!
    }

    func poll() -> T? {
        if isEmpty() {
            return nil
        } else{
            let temp:T = head.value!
            let _ = deQueue()
            return temp
        }
    }

    func offer( key:T)->Bool{
        var status:Bool = false;

        self.enQueue(key: key)
        status = true

        return status
    }
}

struct Point: Hashable {
    let x: Int
    let y: Int
}

let input2 = """
             Z L X W       C
             Z P Q B       K
  ###########.#.#.#.#######.###############
  #...#.......#.#.......#.#.......#.#.#...#
  ###.#.#.#.#.#.#.#.###.#.#.#######.#.#.###
  #.#...#.#.#...#.#.#...#...#...#.#.......#
  #.###.#######.###.###.#.###.###.#.#######
  #...#.......#.#...#...#.............#...#
  #.#########.#######.#.#######.#######.###
  #...#.#    F       R I       Z    #.#.#.#
  #.###.#    D       E C       H    #.#.#.#
  #.#...#                           #...#.#
  #.###.#                           #.###.#
  #.#....OA                       WB..#.#..ZH
  #.###.#                           #.#.#.#
CJ......#                           #.....#
  #######                           #######
  #.#....CK                         #......IC
  #.###.#                           #.###.#
  #.....#                           #...#.#
  ###.###                           #.#.#.#
XF....#.#                         RF..#.#.#
  #####.#                           #######
  #......CJ                       NM..#...#
  ###.#.#                           #.###.#
RE....#.#                           #......RF
  ###.###        X   X       L      #.#.#.#
  #.....#        F   Q       P      #.#.#.#
  ###.###########.###.#######.#########.###
  #.....#...#.....#.......#...#.....#.#...#
  #####.#.###.#######.#######.###.###.#.#.#
  #.......#.......#.#.#.#.#...#...#...#.#.#
  #####.###.#####.#.#.#.#.###.###.#.###.###
  #.......#.....#.#...#...............#...#
  #############.#.#.###.###################
               A O F   N
               A A D   M
"""

let maxX = input2
    .split(separator: "\n")
    .map{ String($0).count }
    .max()!

let list = input2
    .split(separator: "\n")
    .map{ String($0).padding(toLength: maxX, withPad: " ", startingAt: 0) }

let zippedX = list
    .map{ zip($0, 0..<$0.count) }
    
let zippedXY = zip(zippedX, 0..<list.count)
    
let points = Set(zippedXY
    .flatMap{ rowY in
        rowY.0.reduce(into: [Point]()){ accu, current in
            if current.0 == "." {
                accu.append(Point(x: current.1, y: rowY.1))
            }
        }
    })

let teleportPoints = points
    .reduce(into: Dictionary<Point, String>()){ accu, current in
        if current.x > 1 && list[current.y][current.x-2...current.x-1].range(of: "[^A-Z]", options: .regularExpression) == nil {
            accu[Point(x: current.x, y: current.y)] = list[current.y][current.x-2...current.x-1]
        }
        if current.x < list.first!.count-2 && list[current.y][current.x+1...current.x+2].range(of: "[^A-Z]", options: .regularExpression) == nil {
            accu[Point(x: current.x, y: current.y)] = list[current.y][current.x+1...current.x+2]
        }
        if current.y > 1 && list[current.y-2][current.x...current.x].range(of: "[^A-Z]", options: .regularExpression) == nil && list[current.y-1][current.x...current.x].range(of: "[^A-Z]", options: .regularExpression) == nil {
            accu[Point(x: current.x, y: current.y)] = list[current.y-2][current.x...current.x] + list[current.y-1][current.x...current.x]
        }
        if current.y < list.count-2 && list[current.y+1][current.x...current.x].range(of: "[^A-Z]", options: .regularExpression) == nil && list[current.y+2][current.x...current.x].range(of: "[^A-Z]", options: .regularExpression) == nil {
            accu[Point(x: current.x, y: current.y)] = list[current.y+1][current.x...current.x] + list[current.y+2][current.x...current.x]
        }
}

extension Point {
    func getNeighbors() -> [Point] {
        return [
            Point(x: self.x - 1, y: self.y),
            Point(x: self.x + 1, y: self.y),
            Point(x: self.x,     y: self.y - 1),
            Point(x: self.x,     y: self.y + 1),
        ]
    }
}

struct State {
    let startPoint: Point
    let mazePoints: Set<Point>
    let teleportPoints: [Point:String]
    let visited: Set<Point>
    
    private func getTeleportDestination(forPoint: Point, withName: String) -> Point? {
        teleportPoints
            .filter{ $0.value == withName && $0.key != forPoint }.first?.key
    }
    
    private func getNeighbors(_ point: Point) -> [Point] {
        var result = point.getNeighbors()
            .filter{ mazePoints.contains($0) && !visited.contains($0) }
        
        if let teleportName = teleportPoints[point] {
            let teleportDestination = getTeleportDestination(forPoint: point, withName: teleportName)
            if let dest = teleportDestination, !visited.contains(dest) {
                result.append(dest)
            }
        }
        
        return result
    }
    
    func getNextStates() -> [State] {
        getNeighbors(startPoint)
            .reduce(into: [State]()) { accu, current in
                accu.append(State(startPoint: current, mazePoints: mazePoints, teleportPoints: teleportPoints, visited: visited.union([current])))
            }
    }
}


let startPoint = teleportPoints.filter{ $0.value == "AA" }.first!.key
let endPoint = teleportPoints.filter{ $0.value == "ZZ" }.first!.key

// Breadth first
var queue = Queue<State>()

queue.enQueue(key: State(startPoint: startPoint, mazePoints: points, teleportPoints: teleportPoints, visited: [startPoint]))

repeat {
    let state = queue.deQueue()!

   // print(robotState)

    for nextState in state.getNextStates() {
        if nextState.startPoint == endPoint {
            print("\(nextState.visited.count - 1) Steps")
            break
        } else
        {
            queue.enQueue(key: nextState)
        }
    }
} while !queue.isEmpty()

// Zweiter Stern: ---------------------------------------------------------------

let innerRange = getInnerRange(theMap: list, outerRange: getOuterRange(theMap: list))

let innerTeleportPoints =  Set(teleportPoints
    .map{ CGPoint(x: $0.key.x, y: $0.key.y) }
    .filter{ innerRange.contains($0) }
    .map{ Point(x: Int($0.x), y: Int($0.y)) })

struct Visited: Hashable {
    let point: Point
    let level: Int
}

struct State2 {
    let startPoint: Point
    let mazePoints: Set<Point>
    let teleportPoints: [Point:String]
    let innerTeleportPoints: Set<Point>
    let visited: Set<Visited>
    let level: Int
    
    private func getTeleportDestination(forPoint: Point, withName: String) -> Point? {
        teleportPoints
            .filter{ $0.value == withName && $0.key != forPoint }.first?.key
    }
    
    private func getNeighbors(_ point: Point) -> [Point] {
        point.getNeighbors()
            .filter{ mazePoints.contains($0) && !visited.contains(Visited(point: $0, level: level)) }
    }
    
    private func getTeleportPoint(_ point: Point) -> Point? {
        if let teleportName = teleportPoints[point] {
            if teleportName == "ZZ" && level != 0 {
                return nil
            }
            
            if level == 0 && !innerTeleportPoints.contains(point) {
                return nil
            }
            
            return getTeleportDestination(forPoint: point, withName: teleportName)
        }
        
        return nil
    }
    
    func getNextStates() -> [State2] {
        var states =  getNeighbors(startPoint)
            .reduce(into: [State2]()) { accu, current in
                accu.append(State2(startPoint: current,
                                   mazePoints: mazePoints, teleportPoints: teleportPoints,
                                   innerTeleportPoints: innerTeleportPoints,
                                   visited: visited.union([Visited(point: current, level: level)]),
                                   level: level))
            }
        
        if let teleportPoint = getTeleportPoint(startPoint) {
            let newLevel = innerTeleportPoints.contains(startPoint)
                ? level + 1
                : level - 1
            if !visited.contains(Visited(point: teleportPoint, level: newLevel)) {
                states.append(State2(startPoint: teleportPoint,
                    mazePoints: mazePoints, teleportPoints: teleportPoints,
                    innerTeleportPoints: innerTeleportPoints,
                    visited: visited.union([Visited(point: teleportPoint, level: newLevel)]),
                    level: newLevel))
            }
        }
        
        return states
    }
}

let state2 = State2(startPoint: startPoint, mazePoints: points,
                    teleportPoints: teleportPoints, innerTeleportPoints: innerTeleportPoints,
                    visited: [Visited(point: startPoint, level: 0)], level: 0)

var queue2 = Queue<State2>()

queue2.enQueue(key: state2)

repeat {
    let state = queue2.deQueue()!

    for nextState in state.getNextStates() {
        if nextState.startPoint == endPoint && nextState.level == 0 {
            print("\(nextState.visited.count - 1) Steps")
            break
        } else
        {
            queue2.enQueue(key: nextState)
        }
    }
} while !queue2.isEmpty()
