//  Created by Austin Feight on 3/19/16.
//  Copyright © 2016 Max Howell. All rights reserved.

import PromiseKit
import XCTest

class JoinTests: XCTestCase {
    func testImmediates() {
        let successPromise = Promise(value: ())

        var joinFinished = false
        when(resolved: successPromise).done(on: nil) { _ in joinFinished = true }
        XCTAssert(joinFinished, "Join immediately finishes on fulfilled promise")
        
        let promise2 = Promise(value: 2)
        let promise3 = Promise(value: 3)
        let promise4 = Promise(value: 4)
        var join2Finished = false
        when(resolved: promise2, promise3, promise4).done(on: nil) { _ in join2Finished = true }
        XCTAssert(join2Finished, "Join immediately finishes on fulfilled promises")
    }

    #if false
    func testImmediateErrors() {
        let errorPromise = Promise<Void>(error: NSError(domain: "", code: 0, userInfo: nil))
        var joinFinished = false
        when(resolved: errorPromise).asVoid().recover(on: nil) { _ in
            joinFinished = true
            return Promise(value: ())
        }
        XCTAssert(joinFinished, "Join immediately finishes on rejected promise")
        
        let errorPromise2 = Promise<Void>(error: NSError(domain: "", code: 0, userInfo: nil))
        let errorPromise3 = Promise<Void>(error: NSError(domain: "", code: 0, userInfo: nil))
        let errorPromise4 = Promise<Void>(error: NSError(domain: "", code: 0, userInfo: nil))
        var join2Finished = false
        when(resolved: errorPromise2, errorPromise3, errorPromise4).asVoid().recover(on: nil) { _ in
            join2Finished = true
            return Promise(value: ())
        }
        XCTAssert(join2Finished, "Join immediately finishes on rejected promises")
    }
    #endif
    
    func testFulfilledAfterAllResolve() {
        let (promise1, seal1) = Promise<Void>.pending()
        let (promise2, seal2) = Promise<Void>.pending()
        let (promise3, seal3) = Promise<Void>.pending()
        
        var finished = false
        when(resolved: promise1, promise2, promise3).done(on: nil) { _ in finished = true }
        XCTAssertFalse(finished, "Not all promises have resolved")
        
        seal1.fulfill(())
        XCTAssertFalse(finished, "Not all promises have resolved")
        
        seal2.fulfill(())
        XCTAssertFalse(finished, "Not all promises have resolved")
        
        seal3.fulfill(())
        XCTAssert(finished, "All promises have resolved")
    }
}
