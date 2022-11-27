import Fluent
import Vapor

struct StarController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let stars = routes.grouped("stars")
    stars.get(use: index)
    stars.post(use: create)
    stars.group(":starID") { star in
      stars.delete(use: delete)
    }
  }

  func index(req: Request) async throws -> [Star] {
    try await Star.query(on: req.db).all()
  }

  func create(req: Request) async throws -> Star {
    let star = try req.content.decode(Star.self)
    try await star.save(on: req.db)
    return star
  }

  func delete(req: Request) async throws -> HTTPStatus {
    guard let star = try await Star.find(req.parameters.get("starID"), on: req.db) else {
      throw Abort(.notFound)
    }
    try await star.delete(on: req.db)
    return .noContent
  }
}
