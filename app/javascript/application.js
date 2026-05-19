// Entry point for the application bundle
// Import Stimulus and controllers here

import "@hotwired/turbo-rails"
import controllers from "./controllers"
import application from "./application"

// Import all Stimulus controllers
application.load(controllers)
