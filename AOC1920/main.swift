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
        
        return left.0.maxX! > right.0.maxX!
        })!.0.maxX!
    
    return CGRect(x: minX,
                  y: minY,
                  width: maxX - minX + 1,
                  height: maxY - minY + 1)
}

func getInnerRange(theMap: [String], outerRange: CGRect) -> CGRect {
    let zipped = zip(theMap, 0..<theMap.count)
    let filteredY = zipped.filter{ $0.1 >= Int(outerRange.minY) && $0.1 < Int(outerRange.maxY) }
    let filteredXY = filteredY.map{ (string: $0.0[Int(outerRange.minX)..<Int(outerRange.maxX)], y: $0.1) }
    
    let xIndexes: [(minX: Int?, maxX: Int?, y: Int)] = filteredXY.map{
        let minX = $0.string.firstIndex(of: " ")?.distance(in: $0.string)
        let maxX = $0.string.lastIndex(of: " ")?.distance(in: $0.string)
        return (minX, maxX, $0.y)
    }.filter{ $0.minX != nil && $0.maxX != nil }
    
    let minY = xIndexes.first!.y
    let maxY = xIndexes.last!.y
    
    let minX = xIndexes.min(by: { left, right in
        if right.minX == nil {
            return true
        }
        
        if left.minX == nil {
            return false
        }
        
        return left.minX! < right.minX!
    })!.minX!
    
    let maxX = xIndexes.max(by: { left, right in
        if right.maxX == nil {
            return true
        }
        
        if left.maxX == nil {
            return false
        }
        
        return left.maxX! > right.maxX!
    })!.maxX!
    
    return CGRect(x: minX,
                  y: minY,
                  width: maxY - minY,
                  height: maxX - minY)
    
}

let input = """
         A
         A
  #######.#########
  #######.........#
  #######.#######.#
  #######.#######.#
  #######.#######.#
  #####  B    ###.#
BC...##  C    ###.#
  ##.##       ###.#
  ##...DE  F  ###.#
  #####    G  ###.#
  #########.#####.#
DE..#######...###.#
  #.#########.###.#
FG..#########.....#
  ###########.#####
             Z
             Z
"""

let theMap = input
    .split(separator: "\n")
    .map{ String($0) }
let o = getOuterRange(theMap: theMap)
let i = getInnerRange(theMap: theMap, outerRange: o)

print(o)
print(i)

