// The MIT License (MIT)
//
// Copyright (c) 2016 Rizan Hamza
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//  NSIndexSet+NSIndexPath.swift
//  Pods
//
//  Created by rizan on 27/08/2016.
//
//


import Foundation

/**
 Extension for creating index paths from an index set
 */
extension NSIndexSet {
    /**
     - parameter section: The section for the created NSIndexPaths
     - return: An array with NSIndexPaths
     */
    func rh_indexPathsForSection(section: Int) -> [NSIndexPath] {
        var indexPaths: [NSIndexPath] = []
        
        enumerateIndexesUsingBlock { (index, _) -> Void in
            indexPaths.append(NSIndexPath(forItem: index, inSection: section))
        }
        
        return indexPaths
    }
}
