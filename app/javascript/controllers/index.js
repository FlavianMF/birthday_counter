import { Application } from "@hotwired/stimulus"

import CelebrationController from "./celebration_controller"
import CountdownController from "./countdown_controller"
import GameController from "./game_controller"
import IntersectionController from "./intersection_controller"
import ModalController from "./modal_controller"
import TabsController from "./tabs_controller"

const application = Application.start()

// Manual registration to ensure mapping is exact
application.register("game", GameController)
application.register("celebration", CelebrationController)
application.register("countdown", CountdownController)
application.register("intersection", IntersectionController)
application.register("modal", ModalController)
application.register("tabs", TabsController)

export { application }
