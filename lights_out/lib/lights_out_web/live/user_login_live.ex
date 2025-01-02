defmodule LightsOutWeb.UserLoginLive do
  use LightsOutWeb, :live_view

  def render(assigns) do
    ~H"""
    <style>
    /* Global Styles */
/* Global Styles */
/* Global Styles */
body, html {
  margin: 0;
  padding: 0;
  height: 100%;
  font-family: Arial, sans-serif;
  background-image: url('/images/b.jpg'); /* Replace with your background image URL */
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}

/* Login Container Styles */
.login-container {

  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.card {

  padding: 40px;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* Light shadow for visibility */
  width: 100%;
  max-width: 450px;
}

h1 {
  font-size: 1.8rem;
  margin-bottom: 20px;
  color: #333;
}

h2 {
  font-size: 1rem;
  margin-bottom: 10px;
  color: #555;
}

.text-center {
  text-align: center;
}

.subtitle {
  font-size: 0.9rem;
  color: #777;
}

a {
  color: #4CAF50;
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}

button {
  padding: 10px 20px;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

button:hover {
  background-color: #45a049;
}

input[type="checkbox"] {
  margin-right: 10px;
}

input[type="text"], input[type="email"], input[type="password"] {
  width: 100%;
  padding: 10px;
  margin-bottom: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
}


    </style>
    <div class="login-container">
      <div class="card">
        <.header class="text-center">
          Log in to your account
          <:subtitle>
            Don't have an account?
            <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
              Sign up
            </.link>
            for an account now.
          </:subtitle>
        </.header>

        <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />

          <:actions>
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
              Forgot your password?
            </.link>
          </:actions>
          <:actions>
            <.button phx-disable-with="Logging in..." class="w-full">
              Log in <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>

    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
