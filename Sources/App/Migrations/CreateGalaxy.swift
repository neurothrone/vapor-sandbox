import Fluent

struct CreateGalaxy: AsyncMigration {

  // Prepares the database for storing Galaxy models.
  func prepare(on database: Database) async throws {
    try await database.schema("galaxies")
    .id()
    .field("name", .string)
    .create()
  }

  // Optionally reverts the changes made in the prepare method.
  func revert(on database: Database) async throws {
    try await database.schema("galaxies").delete()
  }
}