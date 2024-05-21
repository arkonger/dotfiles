from sys import argv
import subprocess
import json
import re

def get_workspaces():
  # Get a JSON of current workspaces
  proc = subprocess.run(['i3-msg', '-t', 'get_workspaces'], capture_output=True)

  # Check that the process exited successfully
  if proc.returncode:
    print("Error: Failed to get workspaces")
    exit(1)

  # Decode JSON
  workspaces = json.loads(proc.stdout)

  # Dictionary of current workspaces
  current_workspaces = []
  # Initialize focesed workspace as negative to check that it was changed
  focused = -1

  for workspace in workspaces:
    current_workspaces.append(workspace['num'])
    if workspace['focused']:
      focused = workspace['num']
  if focused < 0:
    print("Error: Could not find focused workspace")
    exit(1)
  return focused, current_workspaces

def swap(a, b, current_workspaces):
  # Check whether both workspaces are active
  if a in current_workspaces and b in current_workspaces:
    # Build command string
    command = str.format(
      """\
        rename workspace {0} to temp; \
          rename workspace {1} to {0}; \
          rename workspace temp to {1}""",
      a, b)

    # Pass command to i3
    proc = subprocess.run(['i3-msg', '-t', 'command', command])

    # Check return status
    if proc.returncode:
      print("Failed to give i3 command")
      exit(1)

  # Workspace b is not occupied
  elif a in current_workspaces:
    # Build command string
    command = str.format(
      "rename workspace {0} to {1}",
      a, b)

    # Pass command to i3
    proc = subprocess.run(['i3-msg', '-t', 'command', command])

    # Check return status
    if proc.returncode:
      print("Failed to give i3 command")
      exit(1)

  # Workspace a is not occupied
  else:
    # Build command string
    command = str.format(
      "rename workspace {0} to {1}",
      b, a)

    # Pass command to i3
    proc = subprocess.run(['i3-msg', '-t', 'command', command])

    # Check return status
    if proc.returncode:
      print("Failed to give i3 command")
      exit(1)

  # Notify of successful swap
  msg = str.format("Successfully swapped {0} and {1}", a, b)
  proc = subprocess.run(['notify-send', '-t', str(len(msg)*100), msg])

  # Check return status
  if proc.returncode:
    print("Failed to send notification")
    exit(1)

def prompt_user(prompt):
  proc = subprocess.run(
    ['yad', '--entry', '--title', 'Workplace Swap', '--text', prompt],
    capture_output = True)

  # Parse input for target number
  response = re.search(b'\d', proc.stdout)
  if not response:
    print("Error: Could not get response")
    exit(1)

  # Convert to int and zero-check
  response = int(response[0])
  if not response:
    response = 10
  return response

def start_swap(chain):
  # Get the workspaces
  focused, current_workspaces = get_workspaces()

  # Prompt user for target workspace(s)
  if chain:
    # Array for the workspace chain
    links = []

    while True:
      # Build prompt
      prompt = '<span font="FiraCode Nerd Font 16">'
      if len(links):
        prompt += 'Current chain: '
        for link in links:
          prompt += str.format('{}->', link)
        prompt += '?</span>'
      else:
        prompt += 'First workspace to swap:</span>'
      
      links.append(prompt_user(prompt))
      # Check if the chain loops yet
      if links[-1] == links[0] and len(links) > 1:
        break
    # Begin swaps
    for i in range(1, len(links)):
      swap(links[0], links[i], current_workspaces)
  else:
    target = prompt_user(
      '<span font="FiraCode Nerd Font 16">Swap with:</span>'
    )

    # Perform swap
    swap(focused, target, current_workspaces)

if __name__ == "__main__":
  if "--chain" in argv:
    start_swap(1)
  else:
    start_swap(0)
