import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

public func configure(_ app: Application) throws {
  // Serves files from `Public/` directory
  let fileMiddleware = FileMiddleware(
          publicDirectory: app.directory.publicDirectory
  )
  app.middleware.use(fileMiddleware)

  app.databases.use(.postgres(
          hostname: Environment.get("DATABASE_HOST") ?? "localhost",
          port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
          username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
          password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
          database: Environment.get("DATABASE_NAME") ?? "vapor_database"
  ), as: .psql)

  app.migrations.add(CreateTodo())
  app.migrations.add(CreateGalaxy())
  app.migrations.add(CreateStar())
  try app.autoMigrate().wait()

  app.views.use(.leaf)
  
  // Query Logging
//  app.logger.logLevel = .debug

  // register routes
  try routes(app)
}
