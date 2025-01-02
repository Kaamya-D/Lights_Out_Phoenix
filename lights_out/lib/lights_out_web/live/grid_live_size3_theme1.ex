defmodule LightsOutWeb.GameLive3 do
  use Phoenix.LiveView

  # Initializes the game with a solvable 3x3 grid
  def mount(_params, _session, socket) do
    grid = generate_solvable_grid(3)
    timer_pid = start_timer(self())
    {:ok, assign(socket, grid: grid, moves: 0, timer: 0, timer_pid: timer_pid, success_message: nil)}
  end
  def handle_event("redirect_to_dashboard", _, socket) do
    {:noreply, push_redirect(socket, to: "/dashboard")}
  end

  # Handles the click on a cell in the grid, toggling the clicked cell and its neighbors
  def handle_event("toggle", %{"row" => row, "col" => col}, socket) do
    row = String.to_integer(row)
    col = String.to_integer(col)

    # Toggle the cell
    new_grid = toggle_cell(socket.assigns.grid, row, col)

    # Check if the game is solved
    if game_solved?(new_grid) do
      # Stop the timer and reset it to 0
      stop_timer(socket.assigns.timer_pid)


      {:noreply,
        assign(socket,
          grid: new_grid,
          moves: socket.assigns.moves + 1,
          timer: 0,
          success_message: "Congratulations, you've solved the puzzle!"
        )}
    else
      {:noreply, assign(socket, grid: new_grid, moves: socket.assigns.moves + 1)}
    end
  end

  # Resets the grid to the initial state and stops the old timer before starting a new one
  def handle_event("reset", _, socket) do
    # Stop the previous timer process
    stop_timer(socket.assigns.timer_pid)

    # Start a new timer process
    grid = generate_solvable_grid(3)
    timer_pid = start_timer(self())

    {:noreply, assign(socket, grid: grid, moves: 0, timer: 0, timer_pid: timer_pid, success_message: nil)}
  end

  # Periodically increments the timer
  def handle_info(:tick, socket) do
    {:noreply, assign(socket, timer: socket.assigns.timer + 1)}
  end

  # Starts a new timer process that sends :tick every second
  defp start_timer(pid) do
    timer_pid = spawn(fn -> timer_loop(pid) end)
    timer_pid
  end

  # The timer loop that sends a :tick message every second
  defp timer_loop(pid) do
    Process.sleep(1000)
    send(pid, :tick)
    timer_loop(pid)
  end

  # Stops the previous timer process
  defp stop_timer(timer_pid) do
    Process.exit(timer_pid, :normal)
  end

  # Generates a solvable grid
  defp generate_solvable_grid(n) do
    grid = for _ <- 1..n, do: Enum.map(1..n, fn _ -> 0 end)
    {solvable_grid, _toggles} = apply_random_toggles(grid, n, [])
    solvable_grid
  end

  # Applies random toggles to the grid
  defp apply_random_toggles(grid, n, toggles) do
    num_toggles = :rand.uniform(n * n)  # Random number of toggles
    Enum.reduce(1..num_toggles, {grid, toggles}, fn _, {current_grid, toggle_list} ->
      x = :rand.uniform(n) - 1  # Random row
      y = :rand.uniform(n) - 1  # Random column
      new_grid = toggle_cell(current_grid, x, y)
      {new_grid, [{x, y} | toggle_list]}  # Track toggles
    end)
  end

  # Toggles a cell and its adjacent neighbors
  defp toggle_cell(grid, x, y) do
    directions = [{0, 0}, {-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    Enum.reduce(directions, grid, fn {dx, dy}, acc_grid ->
      nx = x + dx
      ny = y + dy
      if valid_cell?(acc_grid, nx, ny), do: toggle(acc_grid, nx, ny), else: acc_grid
    end)
  end

  # Toggles a specific cell
  defp toggle(grid, x, y) do
    List.update_at(grid, x, fn row ->
      List.update_at(row, y, fn cell -> 1 - cell end)
    end)
  end

  # Validates cell coordinates
  defp valid_cell?(grid, x, y) do
    x >= 0 and x < length(grid) and y >= 0 and y < length(grid)
  end

  # Checks if the game is solved (all cells are "off")
  defp game_solved?(grid) do
    Enum.all?(grid, fn row -> Enum.all?(row, fn cell -> cell == 0 end) end)
  end

  def render(assigns) do
    ~H"""
    <%= if @success_message do %>
      <!-- Popup Modal -->
      <div class="modal">
        <div class="modal-content">
          <h3 style="color: green;"><%= @success_message %></h3>
          <button class="dashboard-button" phx-click="redirect_to_dashboard">Go to Dashboard</button>
        </div>
      </div>
    <% end %>
    <iframe src="/theme1"></iframe>
    <div class="game-container">
      <h1>Lights Out Game</h1>
      <h2>Moves: <%= @moves %></h2>
      <h2>Time: <%= @timer %> seconds</h2>

      <div class="grid-container">
        <%= for row <- 0..2 do %>
          <div class="row">
            <%= for col <- 0..2 do %>
              <%= light_class = if Enum.at(@grid, row) |> Enum.at(col) == 1, do: "on", else: "off" %>
              <button phx-click="toggle" phx-value-row={row} phx-value-col={col} class={"grid-item #{light_class}"}></button>
            <% end %>
          </div>
        <% end %>
      </div>

      <button phx-click="reset" class="reset-button">Reset Game</button>
    </div>

    <style>
    body, html {
      margin: 0;
      padding: 0;
      height: 100%;
      color: white;
    }

    iframe {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      border: none;
      z-index: -1;
    }

    .game-container {
      text-align: center;
      padding: 20px;
    }

    h1 {
      font-size: 2rem;
      margin-bottom: 20px;
    }

    h2 {
      font-size: 1.5rem;
      margin: 10px 0;
    }

    h3 {
      font-size: 1.25rem;
      margin-top: 20px;
    }

    .grid-container {
      display: grid;
      grid-template-columns: repeat(3, 60px);
      gap: 10px;
      justify-content: center;
      margin-bottom: 20px;
    }

    .grid-item {
      width: 60px;
      height: 60px;
      border-radius: 50%;
      cursor: pointer;
      transition: transform 0.2s, box-shadow 0.3s;
    }

    .grid-item:hover {
      transform: scale(1.1);
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    .on {
      background-color: blue;
      box-shadow: 0 0 15px rgba(0, 0, 255, 0.5);
    }

    .off {
      background-color: grey;
      box-shadow: 0 0 15px rgba(169, 169, 169, 0.5);
    }

    .reset-button {
      padding: 10px 20px;
      font-size: 1rem;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      margin-top: 20px;
    }

    .reset-button:hover {
      background-color: #45a049;
    }
    /* Modal Styles */
    .modal {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 10;
    }

    .modal-content {
      background-color: white;
      color: black;
      padding: 20px;
      border-radius: 10px;
      text-align: center;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    .dashboard-button {
      padding: 10px 20px;
      font-size: 1rem;
      background-color: #007BFF;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      margin-top: 10px;
    }

    .dashboard-button:hover {
      background-color: #0056b3;
    }
    </style>
    """
  end
end
