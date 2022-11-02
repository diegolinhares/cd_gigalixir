alias CdGigalixir.Accounts

import CdGigalixir.Factory

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

Enum.each(1..200, fn _ -> insert(:product) end)
