defmodule CdGigalixirWeb.Admin.Products.Form do
  use CdGigalixirWeb, :live_component
  alias CdGigalixir.Products

  @upload_configs [accept: ~w/.png .jpeg .jpg/, max_entries: 1, max_file_size: 10_000_000]

  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)
     |> allow_upload(:photo, @upload_configs)
     |> assign(product: product)}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Products.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    action = socket.assigns.action
    product_params = build_photo_to_upload(socket, product_params)
    save(socket, action, product_params)
  end

  def save(socket, :new, product_params) do
    case Products.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product was created")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def save(socket, :edit, product_params) do
    product = socket.assigns.product

    case Products.update_product(product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product was updated")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp build_photo_to_upload(socket, product_params) do
    socket
    |> consume_uploaded_entries(:photo, fn %{path: path}, entry ->
      filename = get_filename(entry)
      destination = Path.join("/tmp/", filename)

      File.cp!(path, destination)

      file_upload = %Plug.Upload{
        content_type: entry.client_type,
        filename: entry.client_name,
        path: destination
      }

      {:ok, file_upload}
    end)
    |> add_file_upload(product_params)
  end

  defp add_file_upload([], product_params), do: product_params

  defp add_file_upload([file_upload | _], product_params) do
    Map.put(product_params, "product_url", file_upload)
  end

  defp get_filename(%Phoenix.LiveView.UploadEntry{uuid: uuid, client_type: client_type}) do
    [ext | _] = MIME.extensions(client_type)
    "#{uuid}.#{ext}"
  end
end
