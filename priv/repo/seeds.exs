alias CdGigalixir.Accounts
alias CdGigalixir.Products

Accounts.register_user(%{
  email: "adm@elxpro.com",
  password: "adm@elxpro.comD1!",
  role: "ADMIN"
})

Accounts.register_user(%{
  email: "user@elxpro.com",
  password: "user@elxpro.comD1!",
  role: "USER"
})

Enum.each(1..200, fn _ ->
  image = :rand.uniform(4)

  %{
    name: Faker.Food.dish(),
    description: Faker.Food.description(),
    price: :random.uniform(10_000),
    size: "small",
    product_url: %Plug.Upload{
      content_type: "image/png",
      filename: "product_#{image}.png",
      path: "priv/static/images/product_#{image}.jpg"
    }
  }
  |> Products.create_product()
end)
