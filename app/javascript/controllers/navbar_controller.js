import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["receiver"]

  toggle() {
    this.receiverTarget.classList.toggle("invisible")
  }
}
