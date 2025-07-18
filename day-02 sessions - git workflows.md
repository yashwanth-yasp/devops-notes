
- A Git workflow is a set of rules and practices that teams follow when working with Git. It defines how developers create branches, merge code, and manage releases.

# Gitflow 

- Gitflow is a branching strategy that uses multiple types of branches to manage different aspects of development.
	- **master/main**: Contains production-ready code
	- **develop**: Where all development work happens
	- **feature branches**: For individual features
	- **release branches**: For preparing releases
	- **hotfix branches**: For urgent fixes to production

![[Pasted image 20250718144350.png]]

- If there is a bug after the test release have been merged, you create a hotfix branch

```bash
# Start a new feature
git checkout develop
git pull origin develop
git checkout -b feature/user-login

# Work on feature, then merge back
git checkout develop
git merge feature/user-login
git branch -d feature/user-login #safe delete the branch

# Create release branch
git checkout -b release/1.0.0
# Test and fix bugs in release branch

# Merge to master and develop
git checkout master
git merge release/1.0.0
git checkout develop
git merge release/1.0.0
```

- when to use
	- when it's a large team and highly focused on differentiated and organized releases 
# Trunk-Based Development 

- All developers work on the main branch
- They create small, short-lived branches
- Feature branches only live for 1-2 days 
- Merge to main branch quickly 
- CICD

![[Pasted image 20250718145544.png]]

```bash
# Create short-lived feature branch
git checkout main
git pull origin main
git checkout -b quick-fix

# Make small change and merge quickly
git add .
git commit -m "Fix button color"
git checkout main
git merge quick-fix
git branch -d quick-fix
git push origin main
```

- when to use
	- small and medium teams 
	- teams with continous development 
	- teams that need to be fast and follow the agile methodolgy

![[Pasted image 20250718145802.png]]

# Rebase vs Merge

- Merge combines changes from one branch into another by creating a new commit that ties both branches together.
- Rebase moves your branch commits to the tip of another branch, making it look like your work was done on top of the latest changes.

![[Pasted image 20250718150025.png]]

- Use merge when 
	- you need to know the exact development history 
	- Working with shared commits where others might have the same commits
	- you want to see when the features were integrated 
- Use rebase when 
	- You want a clean, linear history
	- working on personal feature branches 
	- when you want to avoid cluttered commit history 

![[Pasted image 20250718153349.png]]

# Merge Conflicts 

- Merge conflicts happen when Git cannot automatically combine changes from different branches because they modify the same lines in the same file.

![[Pasted image 20250718153751.png]]


- yeah, so to resolve merge conflitcts, we can either keep the current branch content or the incoming branch content or have both of them one after the other 
- after resolving the merge conflict, make a commit saying that it's resolved 

# Practical examples

![[Pasted image 20250718173915.png]]

![[Pasted image 20250718173941.png]]

![[Pasted image 20250718173953.png]]

