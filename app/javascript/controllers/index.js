// Import and register all Stimulus controllers using Vite

import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Import all controllers automatically
const controllers = import.meta.glob("./controllers/**/*_controller.js", { eager: true })

// Register controllers
Object.keys(controllers).forEach((path) => {
  const name = path.replace("./controllers/", "").replace("_controller.js", "")
  const controller = controllers[path].default
  if (controller) {
    application.register(name, controller)
  }
})

export default application
