---
date: 2025-07-18
tags:
  - ust
  - devops
  - git
---
# Basic git commands
 
 - git is a distributed version control system
 - `git init` to initialize a repository 
 - `git add .` to stage the repository
 - `git commit -m "message"` to commit the repository with commit message "message"
 - `git clone` to copy a project, basically downloading the whole repository
# Branches and Merge

- `git branch` - see all branches
- `git branch feature` - create a new branch 
- `git checkout feature` - switch to branch "feature"
- `git checkout -b feature` - create and swtich in one command 
- `git merge feature` - merging feature into main, the command is executed after switching to the main branch
# Working with remote repository 

- `git remote -v` : see remote repositories 
- `git remote add origin <link>`
- `git push origin main` : push to remote 
- `git pull origin main` : pull from remote 
- ssh key setup to github login 
	- generate ssh key pair : `ssh-keygen -t rsa -b 4096 -C "your.email@example.com"`
	- copy the public key and paste it in github ssh keys 
	- make sure both the public and private key that was generated is in ~/.ssh
	- `git remote add origin git@github.com:username/project.git` : using ssh link instead

# Complete Workflow 

```bash
# 1. Clone repository
git clone <https://github.com/username/project.git>
cd project

# 2. Create feature branch
git checkout -b new-feature

# 3. Make changes
echo "New feature code" > feature.js
git add feature.js
git commit -m "Add new feature"

# 4. Push branch to GitHub
git push origin new-feature

# 5. Create pull request on GitHub
# 6. After review, merge on GitHub
# 7. Update local main branch
git checkout main
git pull origin main
```

# Common Scenarios 

![[Pasted image 20250718140106.png]]

![[Pasted image 20250718140142.png]]

![[Pasted image 20250718140155.png]]

![[Pasted image 20250718142554.png]]

