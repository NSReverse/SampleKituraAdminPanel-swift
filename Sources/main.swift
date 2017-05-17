import Foundation
import Kitura

class Server : NSObject {
    let router = Router()
    let documentPath = FileManager.default.currentDirectoryPath + "/public_html"
    
    public func createServer() {
        router.get("/") { (request, response, next) in
            try response.redirect("/index.html")
        }
        
        router.get("/:pageName") { (request, response, next) in
            do {
                var resourcePath = self.documentPath + "/\(request.parameters["pageName"]!)"
                
                if (!request.parameters["pageName"]!.contains(".html")) {
                    resourcePath.append(".html")
                }
                
                try response.send(fileName: resourcePath)
            }
            catch {
                print("Unable to load resource: \(error.localizedDescription)")
                print("Resource: " + self.documentPath + "/assets/\(request.parameters["pageName"]!)")
            }
        }
        
        router.get("/assets/:directory/:resource") { (request, response, next) in
            do {
                try response.send(fileName: self.documentPath + "/assets/\(request.parameters["directory"]!)/\(request.parameters["resource"]!)")
            }
            catch {
                print("Unable to load resource: \(error.localizedDescription)")
                print("Resource: " + self.documentPath + "/assets/\(request.parameters["directory"]!)/\(request.parameters["resource"]!)")
            }
        }
    }
    
    public func getRouter() -> Router {
        return router
    }
}

let server = Server()
server.createServer()

Kitura.addHTTPServer(onPort: 8080, with: server.getRouter())
Kitura.run()
