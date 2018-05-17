// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import UnsplashImageView

class UnsplashConfigSpec: QuickSpec {
    
    override func spec() {
        describe("unsplash config") {
            var config = UnsplashConfig()
            
            it("can have gallery mode with single query") {
                config.mode = .gallery(interval: 1.0, transition: .none)
                config.query = .photo(id: "id")
                
                expect(config.mode.isSingle) == true
            }

            it("can have gallery mode with fixed update daily") {
                config.mode = .gallery(interval: 1.0, transition: .none)
                config.fixed = .daily
                
                expect(config.mode.isSingle) == true
            }
            
            it("can have gallery mode with fixed update weekly") {
                config.mode = .gallery(interval: 1.0, transition: .none)
                config.fixed = .daily
                
                expect(config.mode.isSingle) == true
            }
        }
    }
    
}
