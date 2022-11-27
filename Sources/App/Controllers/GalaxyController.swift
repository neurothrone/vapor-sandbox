import Fluent
import Vapor

struct GalaxyController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let galaxies = routes.grouped("galaxies")
    galaxies.get(use: index)
    galaxies.get("stars", use: galaxiesWithStars)
    galaxies.post(use: create)
    galaxies.group(":galaxyID") { galaxy in
      galaxy.delete(use: delete)
    }
  }

  func index(req: Request) async throws -> [Galaxy] {
    try await Galaxy.query(on: req.db).all()
  }
  
  func galaxiesWithStars(req: Request) async throws -> [Galaxy] {
    try await Galaxy.query(on: req.db).with(\.$stars).all()
  }

  func create(req: Request) async throws -> Galaxy {
    let galaxy = try req.content.decode(Galaxy.self)
    try await galaxy.save(on: req.db)
    return galaxy
  }

  func delete(req: Request) async throws -> HTTPStatus {
    guard let galaxy = try await Galaxy.find(req.parameters.get("galaxyID"), on: req.db) else {
      throw Abort(.notFound)
    }
    try await galaxy.delete(on: req.db)
    return .noContent
  }
}
