# type: ignore
start_all()

# Wait for the `ume.service` unit to finish.
server.wait_for_unit("ume")

with subtest("connecting to the server works"):
    print(server.succeed("curl http://localhost:3621"))
