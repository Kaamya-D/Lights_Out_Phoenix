defmodule LightsOutWeb.DashboardLive do
    use Phoenix.LiveView

    def mount(_params, _session, socket) do
      # Initial data or logic can be added here if needed
      {:ok, socket}
    end

    def handle_event("start_game", %{"theme" => theme, "gridSize" => grid_size}, socket) do
      IO.inspect({theme, grid_size}, label: "Received theme and gridSize")

      url =
        case {theme, grid_size} do
          {"Theme1", "3"} -> "/grid3"
          {"Theme1", "4"} -> "/grid4"
          {"Theme1", "5"} -> "/grid"
          {"Theme2", "3"} -> "/grid3_light"
          {"Theme2", "4"} -> "/grid4_light"
          {"Theme2", "5"} -> "/grid_light"
        end

      # Debugging output to check if the url is being set correctly
      IO.inspect(url, label: "Redirecting to")

      # Navigate to the URL
      {:noreply, push_redirect(socket, to: url)}
    end


    def render(assigns) do
      ~H"""
      <head>
      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Bubblegum+Sans&family=Cinzel:wght@400..900&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">    <style>
          /* Reset styles */
          * {
              margin: 0;
              padding: 0;
              box-sizing: border-box;
          }

          body {
              font-family: "Bubblegum Sans", sans-serif;
              background: linear-gradient(135deg, #54bccc 0%, #4a74cf 25%, #7e0db7 50%, #1a188f 100%);
              color: #444;
              display: flex;
              justify-content: center;
              align-items: center;
              height: 100vh;
              margin: 0;
          }

          .container {
              max-width: 900px;
              width: 100%;
              background: #ffffff;
              border-radius: 10px;
              box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
              padding: 30px;
              position: relative;
              text-align: center;
          }

          .help-btn {
              position: absolute;
              top: 20px;
              right: 20px;
              background: #f04e30;
              color: white;
              border: none;
              border-radius: 50%;
              width: 40px;
              height: 40px;
              font-size: 20px;
              cursor: pointer;
              box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
          }

          .help-btn:hover {
              background: #c23b27;
          }

          h2 {
              font-family: "Bubblegum Sans", sans-serif;
              font-size: 2rem;
              margin-bottom: 10px;
          }

          .profile-section {
              margin-bottom: 30px;
          }

          #profilePicPreview {
              width: 120px;
              height: 120px;
              border-radius: 50%;
              border: 3px solid #007bff;
              object-fit: cover;
              margin: 0 auto 10px;
              display: block;
              transition: transform 0.2s ease-in-out;
          }

          #profilePicPreview:hover {
              transform: scale(1.1);
          }

          .profile-section h3 {
              font-family: "Bubblegum Sans", sans-serif;
              color: #333;
              margin-top: 10px;
          }

          .profile-section p {
              font-family: "Bubblegum Sans", sans-serif;
                          color: #555;
              font-weight: bold;
          }
          .statement1 {
              font-size: 2rem;
              color:rgb(52, 5, 49); /* Example: Tomato color */
              font-family: "Bubblegum Sans", sans-serif;
              margin-bottom: 15px;
              text-align: center;
          }

          .statement2 {
              font-size: 1.5rem;
              color:rgb(175, 42, 131); /* Example: Lime Green color */
              font-family: "Cinzel", serif;
              text-align: center;
          }


          #profilePicInput {
              margin-top: 10px;
              padding: 8px;
              border: 1px solid #ddd;
              border-radius: 5px;
          }

          #editMessage {
              color: green;
              font-size: 0.9rem;
              margin-top: 5px;
              display: none;
          }

          section {
              text-align: left;
          }

          .buttons {
              margin: 20px 0;
          }

          .buttons a {
              padding: 12px 20px;
              background-color: #0a2c50;
              color: white;
              text-decoration: none;
              border-radius: 5px;
              margin: 0 10px;
              box-shadow: 0 4px 10px rgba(0, 123, 255, 0.4);
              transition: background-color 0.2s ease, transform 0.2s ease;
          }

          .buttons a:hover {
              background-color: #0056b3;
              transform: translateY(-2px);
          }

          .modal {
              display: none;
              position: fixed;
              z-index: 1000;
              top: 0;
              left: 0;
              width: 100%;
              height: 100%;
              background: rgba(0, 0, 0, 0.6);
              overflow: auto;
          }

          .modal-content {
              background: #ffffff;
              margin: 10% auto;
              padding: 20px;
              width: 70%;
              border-radius: 10px;
              box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
          }

          .close {
              color: #aaa;
              float: right;
              font-size: 28px;
              font-weight: bold;
              cursor: pointer;
          }

          .close:hover {
              color: #000;
          }

          form label {
              font-family: "Bubblegum Sans", sans-serif;
                          font-size: 1rem;
              font-weight: bold;
              display: block;
              margin-bottom: 8px;
          }

          form input, form select, form button {
              margin-bottom: 15px;
              padding: 10px;
              width: 100%;
              border-radius: 5px;
              border: 1px solid #ddd;
          }

          form button {
              background: #007bff;
              color: white;
              border: none;
              cursor: pointer;
          }

          form button:hover {
              background: #0056b3;
          }

          #gameModal:target {
              display: block;
          }
      </style>
      </head>

      <body>

      <div class="container">
          <button class="help-btn" onclick="alert('The Lights Out game is a puzzle where the objective is to turn off all the lights on a grid. Clicking a light toggles its state and the state of its adjacent neighbors, and the game is won when all lights are turned off.');">?</button>

          <h2>Welcome, User!</h2>

          <div class="profile-section" >
            <img id="profilePicPreview" src="/images/default_profile.jpg" alt="Profile Picture" width="100" height="100">
            
        </div>

          <section>
      <h2 class="statement1">Outplay the darkness. Outshine the challenge!</h2>
      <h2 class="statement2">Can you outsmart the dark? It’s time to turn the Lights Out!</h2>
      </section>



          <div class="buttons">
              <a href="/leaderboard">Leaderboard</a>
              <a href="#gameModal">Play Game</a>
          </div>
      </div>

      <div id="gameModal" class="modal">
          <div class="modal-content">
              <span class="close" onclick="window.location.hash='';">&times;</span>
              <h2>Select Game Options</h2>
              <form id="gameOptionsForm" phx-submit="start_game">
                  <label for="theme">Choose a theme:</label>
                  <input type="radio" id="theme1" name="theme" value="Theme1" checked> Snow Theme<br>
                  <input type="radio" id="theme2" name="theme" value="Theme2"> Light Theme<br><br>

                  <label for="gridSize">Select Grid Size:</label>
                  <select id="gridSize" name="gridSize">
                      <option value="3">3x3</option>
                      <option value="4">4x4</option>
                      <option value="5">5x5</option>
                  </select><br><br>

                  <button type="submit">Start Game</button>
              </form>
          </div>
      </div>

      <script>
          function previewProfilePic(event) {
              const file = event.target.files[0];
              const reader = new FileReader();

              reader.onload = function(e) {
                  document.getElementById('profilePicPreview').src = e.target.result;
                  document.getElementById('editMessage').style.display = 'block';
                  setTimeout(() => {
                      document.getElementById('editMessage').style.display = 'none';
                  }, 3000);
              };

              if (file) {
                  reader.readAsDataURL(file);
              }
          }
      </script>
      </body>
      """
    end

    def handle_event("show_help", _params, socket) do
      IO.puts("Help information triggered!")
      {:noreply, socket}
    end

    def handle_event("preview_profile_pic", %{"profile_pic_input" => pic}, socket) do
      IO.puts("Profile picture preview logic here!")
      {:noreply, socket}
    end

    def handle_event("close_game_modal", _params, socket) do
      {:noreply, socket}
    end

    def handle_event("open_game_modal", _params, socket) do
      {:noreply, socket |> push_event("show_modal", %{})}
    end
  end
