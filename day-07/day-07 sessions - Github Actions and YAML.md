---
date: 2025-07-25
tags:
  - devops
  - ust
  - github
  - cicd
---

# YAML

- YAML (YAML Ain't Markup Language) is a human-readable data serialization standard. It's widely used for configuration files, including GitHub Actions workflows.

### Basic YAML syntax rules 

- Indentation
	- YAML uses **spaces** for indentation not tabs
	- 2 spaces is the standard
- Key value pairs 
	- simple key value pairs 
	- multi word keys either can be used with hyphens like `word1-word2: value` or can be used with quotes `"word1 word2: value`
- Lists/arrays

```YAML
# Method 1: Dash notation
fruits:
  - apple
  - banana
  - orange

# Method 2: Inline notation
fruits: [apple, banana, orange]

# Complex list items
employees:
  - name: John
    position: Developer
    skills:
      - Java
      - Python
  - name: Jane
    position: Designer
    skills:
      - Figma
      - Photoshop
```

- Multi line strings

```YAML
# Literal block scalar (preserves line breaks)
description: |
  This is a multi-line string
  that preserves line breaks
  exactly as written.

# Folded block scalar (folds line breaks into spaces)
summary: >
  This is a long text that will
  be folded into a single line
  with spaces replacing line breaks.
```

- Comments 
	- Use '#'
- YAML data types 
	- Strings, Numbers, Booleans (true, false, yes, no), Null values (null, ~, " " ), dates 

# Github Actions 

- GitHub Actions is a CI/CD platform that allows you to automate software workflows directly in your GitHub repository. You can build, test, and deploy your code right from GitHub.
- Key Concepts 
	- Workflow: A configurable automated process made up of one or more jobs. 
	- Event: A specific activity that triggers a workflow (push, pull request, issue, etc.).
	- Job: A set of steps that execute on the same runner.
	- Step: An individual task that can run commands or actions.
	- Action: A custom application that performs complex but frequently repeated tasks.
	- Runner: A server that runs your workflows (GitHub-hosted or self-hosted).

## Workflow file Structure 

- Workflows are defined in YAML files stored in `.github/workflows/` directory.

```YAML
name: Workflow Name           # Optional: Display name
on: [push, pull_request]     # Events that trigger the workflow
jobs:                        # One or more jobs
  job-name:                  # Job identifier
    runs-on: ubuntu-latest   # Runner environment
    steps:                   # Sequence of tasks
      - name: Step Name      # Optional: Step name
        run: echo "Hello"    # Command to run
```

## Workflow Triggers 

### Push Events 

```YAML
# Trigger on any push
on: push

# Trigger on push to specific branches
on:
  push:
    branches: [main, develop]

# Trigger on push to specific paths
on:
  push:
    paths:
      - 'src/**'
      - '**.java'

# Exclude specific branches or paths
on:
  push:
    branches-ignore: [feature-*]
    paths-ignore:
      - 'docs/**'
      - '**.md'
```

### Pull Request Events 

```YAML
# Trigger on pull requests
on: pull_request

# Trigger on specific PR activities
on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [main]
```

### Schedule Events (Cron Jobs)

```YAML
# Run daily at 2:30 AM UTC
on:
  schedule:
    - cron: '30 2 * * *'

# Run every Monday at 9 AM UTC
on:
  schedule:
    - cron: '0 9 * * 1'
```

### Manual Triggers 

- Mnaual triggers are written to allow user to use github action from the UI manually
- The following code has inputs that are required such as environment to deploy to.

```YAML
# Manual workflow dispatch
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production
```

### Multiple Triggers

```YAML
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 2 * * *'
  workflow_dispatch:
```

### Release Events 

```YAML
on:
  release:
    types: [published, created]
```

## Advanced Workflows

- Environment Specific deployments
	- Github actions can accept custom inputs and dynamically run environment specific deployments using `environment: ${{ github.event.inputs.environment }}`
- Conditional workflows 
	- Workflows can run when a specific type of file or folder has been changed

```YAML
name: Conditional Workflows

on: [push, pull_request]

jobs:
  changes:
    runs-on: ubuntu-latest
    outputs:
      java: ${{ steps.changes.outputs.java }}
      docs: ${{ steps.changes.outputs.docs }}
    steps:
    - uses: actions/checkout@v4
    - uses: dorny/paths-filter@v2
      id: changes
      with:
        filters: |
          java:
            - '**/*.java'
            - 'pom.xml'
          docs:
            - 'docs/**'
            - '**.md'

  test-java:
    needs: changes
    if: ${{ needs.changes.outputs.java == 'true' }}
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Run Java tests
      run: echo "Running Java tests"

  update-docs:
    needs: changes
    if: ${{ needs.changes.outputs.docs == 'true' }}
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Update documentation
      run: echo "Updating documentation"
```

- Resuable Workflows 
	- Resuable workflows are like functions that can be referenced in other workflows, that's why resuable 
	- It can be done by using `workflow_call` in `on` and `call-resuable-workflow` in `jobs`

## Best Practices

- Security best practices
	- Use specific action versions
	- Use secrets for sensitive data
	- Limit permissions
	- Use environment protection rules (for ex using environments other than production or release)
- Performance Optimization 
	- Cache dependencies
	- Use build matrices ffor parallel execution 
	- Skip uncessary steps (for ex skipping when the commit message has 'docs only')
- Error handling and debugging
	- Continue on error
	- Add debugging output
	- Use step conditions
- Workflow Organization 
	- Use meaningful names 
	- Group related steps 
	- Use job dependencies 
- Monitoring and Notifications 
	- Add status badges to README.md
	- Notify on failure (using `if: failure()`) 
