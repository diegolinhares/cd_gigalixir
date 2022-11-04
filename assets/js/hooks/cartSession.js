const CartSession = {
  mounted() {
    thisn.handleEvent("create-cart-session-cart_id", map => {
      var { cartId: cartId } = map
      sessionStorage.setItem("cart_id", cartId)
    })
  },
  destroyed() {
    this.observer.disconnect()
  }
}

export default CartSession