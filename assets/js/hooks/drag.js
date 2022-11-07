import Sortable from "sortablejs"

const Drag = {
  mounted() {
    const hook = this
    const selector = `#${hook.el.id}`
    const el = document.getElementById(hook.el.id)

    new Sortable(el, {
      animation: 0,
      group: "shared",
      draggable: ".draggable",
      onEnd: function (event) {
        hook.pushEventTo(selector, "dropped", {
          order_id: event.item.id,
          new_status: event.to.id,
          old_status: event.from.id
        })
      }
    })

  }
}

export default Drag