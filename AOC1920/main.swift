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

//func getOuterRange(theMap: [String]) -> CGRect {
//    let xIndexes: [(minX: Int?, maxX: Int?)] = theMap.map{
//        let minX = $0.firstIndex(of: "#")?.distance(in: $0)
//        let maxX = $0.lastIndex(of: "#")?.distance(in: $0)
//        return (minX, maxX)
//    }
//
//    let xIndexesWithIndex = zip(xIndexes, 0..<theMap.count)
//    let filtered = xIndexesWithIndex.filter{ $0.0.minX != nil && $0.0.maxX != nil }
//    let minY = filtered.first!.1
//    let maxY = filtered.last!.1
//
//    let minX = filtered.min(by: { left, right in
//        if right.0.minX == nil {
//            return true
//        }
//
//        if left.0.minX == nil {
//            return false
//        }
//
//        return left.0.minX! < right.0.minX!
//        })!.0.minX!
//
//    let maxX = filtered.max(by: { left, right in
//        if right.0.maxX == nil {
//            return true
//        }
//
//        if left.0.maxX == nil {
//            return false
//        }
//
//        return left.0.maxX! < right.0.maxX!
//        })!.0.maxX!
//
//    return CGRect(x: minX,
//                  y: minY,
//                  width: maxX - minX + 1,
//                  height: maxY - minY + 1)
//}
//
//func getInnerRange(theMap: [String], outerRange: CGRect) -> CGRect {
//    let zipped = zip(theMap, 0..<theMap.count)
//    let filteredY = zipped.filter{ $0.1 >= Int(outerRange.minY) && $0.1 < Int(outerRange.maxY) }
//    let filteredXY = filteredY.map{ (string: $0.0[Int(outerRange.minX)..<Int(outerRange.maxX)], y: $0.1) }
//
//    let xIndexes: [(minX: Int?, maxX: Int?, y: Int)] = filteredXY.map{
//        let minX = $0.string.firstIndex(of: " ")?.distance(in: $0.string)
//        let maxX = $0.string.lastIndex(of: " ")?.distance(in: $0.string)
//        return (minX, maxX, $0.y)
//    }.filter{ $0.minX != nil && $0.maxX != nil }
//
//    let minY = xIndexes.first!.y
//    let maxY = xIndexes.last!.y
//
//    let minX = xIndexes.min(by: { left, right in
//        if right.minX == nil {
//            return true
//        }
//
//        if left.minX == nil {
//            return false
//        }
//
//        return left.minX! < right.minX!
//    })!.minX!
//
//    let maxX = xIndexes.max(by: { left, right in
//        if right.maxX == nil {
//            return true
//        }
//
//        if left.maxX == nil {
//            return false
//        }
//
//        return left.maxX! < right.maxX!
//    })!.maxX!
//
//    return CGRect(x: minX,
//                  y: minY,
//                  width: maxY - minY,
//                  height: maxX - minY)
//
//}
//
//let input = """
//         A
//         A
//  #######.#########
//  #######.........#
//  #######.#######.#
//  #######.#######.#
//  #######.#######.#
//  #####  B    ###.#
//BC...##  C    ###.#
//  ##.##       ###.#
//  ##...DE  F  ###.#
//  #####    G  ###.#
//  #########.#####.#
//DE..#######...###.#
//  #.#########.###.#
//FG..#########.....#
//  ###########.#####
//             Z
//             Z
//"""
//
//let theMap = input
//    .split(separator: "\n")
//    .map{ String($0) }
//let o = getOuterRange(theMap: theMap)
//let i = getInnerRange(theMap: theMap, outerRange: o)
//
//print(o)
//print(i)

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
                                         J       L   P           P   V T       X
                                         G       V   M           I   O R       C
  #######################################.#######.###.###########.###.#.#######.#########################################
  #...#.........#.#...#.#...#.........#.....#.#.....#.......#...#...#.....#.#...........#...........#.......#...#.......#
  ###.#########.#.#.###.#.#######.###.###.###.#####.#.###.###.#####.###.###.#####.#.#######.#####.###.#.#####.#####.#####
  #.#.....#...........#...#...#.#.#.....#.....#.#...#.#.....#.#.#.....#.....#.....#.#.#.#.......#.#...#.....#.#.#.....#.#
  #.#####.#####.###.#####.###.#.#######.#.#.###.#.#####.###.#.#.#.#########.#.#.#####.#.###.#######.#.#######.#.###.###.#
  #...#...#.....#...#.#...#.#.#...#.#.....#.#.......#...#.#.#...#.#.#.......#.#.#...............#.#.#.........#.#.#.....#
  ###.#.#.#########.#.###.#.#.#.###.#.#.#########.#####.#.#.#.#.#.#.###.#####.###.#.#.#.###.#.###.###.#######.#.#.#.#####
  #.....#...#.....#.........#...#.#...#.........#.....#.#...#.#.....#.....#.#.#...#.#.#.#...#...........#...#.........#.#
  #########.#####.#.#.#.#.#.###.#.#######.#####.###.#####.###.###.###.#####.#.#.###.#.#.###.#.#####.#.###.#########.###.#
  #.#.........#.....#.#.#.#.#.......#.......#.#.#.......#.#...#.#...#...#...#.....#.#.#...#.#.....#.#.............#.#...#
  #.###.###.#####.#########.###.#####.###.#.#.#####.#####.###.#.###.#.###.###.#.###.#######.###.#.#.#.#######.#####.###.#
  #...#...#.....#.#.#...#.........#...#...#.#.....#.#.#.....#...#...#.......#.#.#.........#...#.#.#.#.......#.#...#.#.#.#
  #.#########.###.#.#.#####.#.###.###.#######.###.#.#.#.###.###.###.#.#.#.###.#####.#.###.#.#.###.#.#.#.#######.#.###.#.#
  #...#.......#.#.#.....#.#.#.#...........#.....#.....#.#...#.....#.#.#.#.#.......#.#.#...#.#.#.#.#.#.#...#...#.#.#.#...#
  #.#########.#.###.###.#.###########.#########.###########.#.###.###.###.#########.#########.#.#####.#.###.###.###.###.#
  #...#.#.#.......#.#.....#.....#.....#.#.......#.#...#.#...#...#.#.#.#.#.#...#...........#.#.....#...#.....#...#.......#
  ###.#.#.#####.#####.###.#####.#####.#.#####.###.###.#.###.#.#####.#.#.###.#######.#######.#.#######.#.###.###.#####.###
  #.....#.#.#.#.....#.#.#.........#.#.....#.#...........#...#.....#.........#...#...#...#...#.#.#...#.#.#.#...#.#.#.....#
  #.#.#.#.#.#.#.#######.#########.#.###.###.###.#####.#####.#.#######.#########.###.###.###.###.#.#####.#.#####.#.#.#.###
  #.#.#.......#.....#.#.#.#.#.#.#.#.....#...#...#.#.#.#...#.#.#.#.#.....#...#...#...#...#.....#.....#.#.#.#...#...#.#.#.#
  #####.#####.#.#####.#.#.#.#.#.#.###.#####.#.###.#.###.###.#.#.#.#.#.###.###.#.#.#####.#.#.#######.#.###.#.#####.###.#.#
  #.#.#.#.....#.....#.......................#...#...#.......#.....#.#.#.......#.#.........#...#.#.#.#...#.....#.#.#.....#
  #.#.#######.#.#######.###.#.#####.#######.#.#####.#.#.###.###.#####.#######.#.###.#######.#.#.#.#.#.#####.###.#.###.###
  #...#...........#.#.#.#...#.#...#.#...#.#.#.....#...#...#.#...#...........#.#...#.....#.#.#...........#...#...#.#...#.#
  ###.#.#.###.#.###.#.#.#.#####.#####.###.#.#.#######.#.#.#.#.###########.###.###.#.#.#.#.#.#.#.#.###.#.###.###.#.#.#.#.#
  #.....#.#.#.#.#.....#.#...#...#.#.#.....#.#.....#...#.#.#.#...#.#.#...#.#...#.#.#.#.#.#.#.#.#.#.#.#.#...#.......#.#...#
  ###.#.#.#.#.#####.###########.#.#.#.###.#.#.#####.#.#######.###.#.#.#.#.#.#.#.#.#.#####.#.#######.#######.#.###.#.#####
  #.#.#.#.#...#.#.......#.......#.....#.#.#.#...#.#.#.......#.......#.#...#.#.#.#...#.#...#.#...#...#...#...#.#...#.....#
  #.#########.#.###.#.#####.#.#.#####.#.#.#.###.#.###.###.#########.#.#######.#.#####.###.###.###.#####.#########.###.###
  #.....#.#.#.#.....#...#...#.#.#.......#...#.....#.....#...#.......#.....#.................#...#...#.........#.#.#.#...#
  #.#####.#.#.#######.#######.#########.#########.#########.#.#########.#.#######.#########.#.###.#####.#######.#.#.#.###
  #.....#.#.#.#...#.#.#.#.#.#...#      F         O         O X         N U       W        #.#.....#.#.#...#.#.#.........#
  #.#####.#.#.#.###.#.#.#.#.#.###      Z         G         D L         B Y       W        ###.#####.#.###.#.#.###.###.###
  #...#.#.#.#.#.#...#.......#...#                                                         #.......#.....#...#...#.#.#...#
  #.###.#.#.#.#.###.#.#.###.#.#.#                                                         #.#.#######.###.#.###.#.#.#.###
PL....#.#.#...#...#...#...#...#.#                                                         #.#.#.#.#...#.#.#.....#.#.#.#.#
  #.###.#.###.#.###.#.#.#.###.#.#                                                         #.###.#.#.###.###.#######.#.#.#
  #.......#.#.......#.#.#.#...#..EL                                                     PM..#.........#.#.....#.#.......#
  #.#.#.###.###.#.#.###########.#                                                         #.###.###.###.#.#.#.#.###.###.#
  #.#.#.........#.#.#.....#...#.#                                                         #.#.#...#.......#.#.......#....BR
  #############.#.#####.###.#####                                                         #.#.###.#########.#.#.###.###.#
YP..#.........#.#...#.#.#.#.....#                                                         #.#...#.....#.#.#.#.#...#...#.#
  #.#.###.#.#####.###.#.#.###.#.#                                                         #.#.#.###.###.#.###########.#.#
  #...#.#.#.#.#.#.#...#.....#.#.#                                                         #...#.....#.#.#.#...#.#...#.#.#
  #.###.###.#.#.###.#.#.#.###.###                                                         ###########.#.#.#.###.###.###.#
  #...#.#...........#...#........TH                                                       #.......#...............#...#.#
  ###.#.#####################.###                                                         #.#####.#.###.###.#####.#.#.###
EV..#.#...#.................#...#                                                       LV..#.#.....#...#...#.#.#...#.#..UN
  #.###.#.#####.#.###.#.#.###.###                                                         #.#.#.###.###.#.#.#.#.#####.#.#
  #.#...#...#...#.#...#.#.#.#...#                                                         #.#...#.#.#.#.#.#.#.#.......#.#
  #.#.#####.#.#.#.###.###.#.#####                                                         #######.###.#######.#.#######.#
  #.#.#.....#.#.#...#.#.#.......#                                                         #.#.......#.....#.#.#.........#
  #.#.#.#######.#######.###.#.#.#                                                         #.#####.#.###.###.#.###########
  #...#...........#...#...#.#.#..XC                                                       #...#.#.#.........#...........#
  #######.#########.###.###.#####                                                         #.#.#.###.###.###.###.#.#.#.###
WV..#.#.#.#...............#.#.#.#                                                         #.#...#.#.#.#.#.......#.#.#....OD
  #.#.#.#.#.#.#.###.#####.###.#.#                                                         #.###.#.#.#.#########.#########
  #.....#.#.#.#...#.#.....#.#.#..PI                                                       #.#.....#...#.....#.#.....#...#
  #####.###.#####.#.#####.#.#.#.#                                                         #.#.#.#.###.###.###.#########.#
AA........#.....#.#.#...#.......#                                                       UN..#.#.#.....#...#...#.#.#.#...#
  #.#######.###########.###.###.#                                                         ###.###########.###.#.#.#.###.#
  #...........#.#.#.#.....#.#.#.#                                                         #...#...#.......#..............OA
  #.#.#.#.#.#.#.#.#.###.#####.###                                                         #####.#.#.#.###.#.#.###.###.#.#
  #.#.#.#.#.#.....#.............#                                                         #.#...#...#.#.....#.#...#...#.#
  #################.#########.###                                                         #.#.###.#.#########.###########
  #.....#.#.#.#.......#.....#...#                                                         #.#...#.#.#.......#.#.#.....#.#
  #.#.###.#.#.#######.#.###.###.#                                                         #.#.###.#.#.#########.#.#####.#
  #.#.#...#...#.#...#.....#.#.#.#                                                       SL....#.#.#.#.#.#.....#...#.#...#
  #.#.#.#.#.###.#.#.#######.#.#.#                                                         #####.#####.#.#.#.#####.#.#.###
EL..#...#.........#.........#.#..WV                                                       #...............#.#.#..........XP
  #.###########.###.#########.###                                                         #.#########.###.###.###.#####.#
  #.#.......#...#...#...........#                                                         #.#.....#...#...#...#.......#.#
  ###.#####.###.#########.#.###.#                                                         #.#.###.#.#.#####.#.#####.#.#.#
UY..#...#.....#.#.........#.#....XP                                                     PL..#...#...#.#.#.#.#...#...#.#.#
  #.#.###.#.###########.#.#.#####                                                         #.###.#######.#.###.#.#.#####.#
  #.#.#...#.#.#.#.#.#...#.#.....#                                                         #...#...............#.....#.#.#
  #.#.#.#####.#.#.#.###.###.#####                                                         #.#.###############.#.#.###.#.#
  #...#...................#.....#                                                         #.#.#...........#...#.#.#...#.#
  ###############.###############                                                         #.#.###.#######.###########.###
  #...........#.#.#.............#                                                         #.#.#.....#...........#...#.#.#
  #####.#.#.###.###.#######.###.#                                                         #########.#.#.###########.#.#.#
  #.....#.#.#.#.#.........#.#...#                                                         #.#.#.....#.#.#...#...#...#....TH
  #.#####.###.#.#######.#####.###                                                         #.#.###.#.#.#########.###.#.#.#
ZZ....#...#...#.#...........#.#.#                                                       JG........#.#.................#.#
  ###.#.###.#.#.###.#.#.#####.#.#                                                         #.###.#.###.#.#.#####.###.#.###
JH....#.....#.......#.#...#......EV                                                       #.#...#...#.#.#...#.....#.#...#
  #.#.#######.#.#####.#.#####.###                                                         #.###.#########.###.#.#####.#.#
  #.#.#.......#.#.#.#.#.....#.#.#                                                         #.#...#...........#.#.#.#...#.#
  #.#.###.#.#.###.#.#.#######.#.#    V     J           Y       T     C     B       O      #.#####.###.#.###.#.###.###.#.#
  #.#.#...#.#...#.....#.#.......#    O     H           P       R     K     R       A      #.#.....#...#...#.#.#.#.....#.#
  #.#.#.#.###.#.#.#.#.#.#.###.#.#####.#####.###########.#######.#####.#####.#######.###############.#.#.#.###.#.#.#.#.###
  #.#.#.#.#...#.#.#.#...#...#.#.#.......#.......#...#.....#.....#.......#...#...#.........#.#.#.....#.#.#.#.#.#...#.#.#.#
  ###.#####.#.#######.###.###.#######.#####.#####.###.#######.###.#######.###.#.#.#.#.###.#.#.###.#####.###.#########.#.#
  #.....#.#.#.....#...#...#.#.#...........#.........#.....#...#.#.....#.#.....#.#.#.#.#.....#...#.#.#.........#.........#
  #.#####.#.###.#####.#####.#.#.###.###.#.###.#.###.#####.#.#.#.#.#####.###.###.#.#####.#.###.#####.###.###.###.#.#.###.#
  #...#...#...#.#.........#...#.#...#.#.#.#.#.#...#.#.....#.#...#.......#.#.#...#.#...#.#.#.....#.#.....#.....#.#.#.#...#
  #######.#####.#####.#######.#####.#.#.###.#####.#####.###.###########.#.#####.#.#.#########.###.###.#.###.#######.###.#
  #.......#.#.....#...#.........#...#.#.#...#.........#...#.#.#.......#...#.#.#.#...#...#...#.#.....#.#.#.#.#.........#.#
  #.#.#.#.#.#.#####.#####.###.#####.#.#.#.#####.#.#.#.###.#.#.#####.#.#.###.#.#.#.###.###.###.###.###.###.###.#.###.#####
  #.#.#.#.......#...#...#.#...#.......#.#...#...#.#.#.#.#.#.....#...#.#.....#...#...#.#.#.........#.#...#...#.#.#.......#
  #######.###.###.#.#.###############.###.#####.###.###.#.#.#.#.#.#.#.#.###.###.###.#.#.#.###.#.###.###.#.#.#.#####.#.#.#
  #...#.#.#.....#.#.#.#.........#.#.........#.....#.#...#.#.#.#.#.#.#.....#.#...#...#...#...#.#.....#.#.#.#.......#.#.#.#
  #.###.###.#.#####.#.#########.#.#######.#.###.#####.###.#.#.#####.###.#######.#.###.###.#######.#.#.#####.#.#.#.###.###
  #.....#...#...#.#.....#...............#.#.#.....#.......#.#.#.....#.#...#.....#.....#.....#.....#.....#.#.#.#.#.#.....#
  #####.#.#.###.#.#.#########.#####.###.#.###.###.#######.#.#####.###.#.#.#####.#.###.#.#.#######.#.#.###.#.#######.#.#.#
  #.......#.#.#.#.....#.......#.#...#.#.....#.#...#.#.#...#...#.......#.#.#.....#.#.....#...#...#.#.#.#.......#.#.#.#.#.#
  #.###.#.#.#.###.#######.#####.#.#.#####.#.###.###.#.#.#.#.#####.#####.#####.###.#.###.###.#.###.#.###########.#.#.#.#.#
  #.#.#.#.#...#...#...#.#.#.#.#.#.#.....#.#...#...#.....#.#...#.#.....#.#.......#.#.#...#.#.....#.#.#.........#...#.#.#.#
  #.#.#.#.#.###.#####.#.###.#.#.###.#######.#####.#.###.###.#.#.#.#############.#######.#.#.###.#####.#.###.###.#####.###
  #.#.#.#.#...#...#.#.....................#.#.....#...#.#...#...#.#...#.#.......#...#.#...#.#.#.#.....#.#.........#.#...#
  #.#.#.#.#.#######.#####.#####.#####.#########.#.#.#########.#.#.###.#.#####.###.###.#.#.###.#####.#########.#####.#####
  #.#...#.#.#...#.........#.#.#.#.......#...#.#.#.#.........#.#.#.#.....#...........#...#.#.......#.#.#.#.#...........#.#
  #.#######.###.###.#######.#.#####.#####.###.#.#######.#####.###.###.#.###.###.#######.#######.###.#.#.#.###.###.###.#.#
  #.....#.#.#.#.#.#.#.#.....#.........#.........#.#...#...#.#...#.....#.#.#...#.#.#.#.#.....#...............#...#.#.....#
  #.#####.###.#.#.###.#####.#######.#####.#.###.#.#.#.#.###.#.#########.#.#.###.#.#.#.#.#########.#####.#.#.#######.#.#.#
  #.#.#.......................#.#.#.#...#.#.#.....#.#...#.#...#.#.#.......#.#.....#.#...#...#.........#.#.#.......#.#.#.#
  #.#.#.###.#####.#########.#.#.#.#.#.###########.#.###.#.#.###.#.###.###.###.#####.###.###.#.#.#.#.###.#####.#.###.#####
  #.#...#.#.#.#...#.........#.........#...#.#.....#...#.#.......#...#...#.#.....#...#.........#.#.#...#...#...#.#.#...#.#
  #######.###.###.#####.#####.#####.#.#.###.###.###.#######.#.#.#.#####.#######.#.#.#.#####.#####.#.#.#.#####.###.#####.#
  #...............#.....#.......#...#.....#.......#.....#...#.#.#.......#.......#.#.......#.....#.#.#.#.....#...........#
  #####################################.#####.#######.#######.###.#########.#####.#######################################
                                       O     C       N       X   F         S     W
                                       G     K       B       L   Z         L     W                                         
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

print(points)

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
            if let dest = teleportDestination {
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

