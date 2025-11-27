import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["hideable"]

  connect() {
    console.log("Hello from toggle_controller.js")
  }

  call(e) {
    e.preventDefault()
    this.hideableTarget.classList.toggle("d-none")
  }
}
