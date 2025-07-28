---
date: 2025-07-28
tags:
  - cicd
  - devops
  - devsecops
---

# CI/CD

- Continuous Integration is the automation of the testing and integration of the devolopers code according to the application guidelines 
- Continous Deployment is a stage in the software release pipeline where the deployment to production is automated, and changes are released as soon as they are validated.

![[Pasted image 20250728165257.png]]

### Example: Node.js Application CI Pipeline

```YAML
name: CI Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  NODE_VERSION: '18'
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  # Job 1: Code Quality & Linting
  lint:
    name: Code Linting
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run ESLint
      run: npm run lint
    
    - name: Run Prettier check
      run: npm run format:check
    
    - name: Type checking (if using TypeScript)
      run: npm run type-check
      continue-on-error: false

  # Job 2: Unit Tests
  test:
    name: Unit Tests
    runs-on: ubuntu-latest
    needs: lint  # Wait for linting to pass
    
    strategy:
      matrix:
        node-version: [16, 18, 20]  # Test multiple Node versions
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Setup Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run tests with coverage
      run: npm run test:coverage
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info
        flags: unittests
        name: codecov-umbrella

  # Job 3: Build and Dockerize
  build:
    name: Build & Docker
    runs-on: ubuntu-latest
    needs: [lint, test]
    outputs:
      image: ${{ steps.image.outputs.image }}
      digest: ${{ steps.build.outputs.digest }}
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Build application
      run: npm run build
    
    - name: Setup Docker Buildx
      uses: docker/setup-buildx-action@v3
    
    - name: Log in to Container Registry
      uses: docker/login-action@v3
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=sha,prefix=sha-
          type=raw,value=latest,enable={{is_default_branch}}
    
    - name: Build and push Docker image
      id: build
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max
    
    - name: Output image
      id: image
      run: |
        echo "image=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}" >> $GITHUB_OUTPUT

  # Job 4: Upload Artifacts
  artifacts:
    name: Upload Artifacts
    runs-on: ubuntu-latest
    needs: build
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Build application
      run: npm run build
    
    - name: Create deployment package
      run: |
        mkdir -p deployment-package
        cp -r dist/ deployment-package/
        cp package.json deployment-package/
        cp package-lock.json deployment-package/
        tar -czf deployment-package.tar.gz deployment-package/
    
    - name: Upload build artifacts
      uses: actions/upload-artifact@v4
      with:
        name: build-artifacts-${{ github.sha }}
        path: |
          dist/
          deployment-package.tar.gz
        retention-days: 30
    
    - name: Upload test results
      uses: actions/upload-artifact@v4
      with:
        name: test-results-${{ github.sha }}
        path: |
          coverage/
          test-results.xml
        retention-days: 7
```

### Multi Environment CD pipeline

```YAML
name: CD Pipeline

on:
  workflow_run:
    workflows: ["CI Pipeline"]
    types: [completed]
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  # Deploy to Staging
  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    environment: 
      name: staging
      url: https://staging.example.com
    
    steps:
    - name: Checkout deployment scripts
      uses: actions/checkout@v4
    
    - name: Download artifacts
      uses: actions/download-artifact@v4
      with:
        name: build-artifacts-${{ github.sha }}
        github-token: ${{ secrets.GITHUB_TOKEN }}
        run-id: ${{ github.event.workflow_run.id }}
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1
    
    - name: Deploy to ECS Staging
      run: |
        # Update ECS service with new image
        aws ecs update-service \
          --cluster staging-cluster \
          --service myapp-service \
          --task-definition myapp-staging:${{ github.run_number }} \
          --force-new-deployment
    
    - name: Wait for deployment
      run: |
        aws ecs wait services-stable \
          --cluster staging-cluster \
          --services myapp-service
    
    - name: Run smoke tests
      run: |
        curl -f https://staging.example.com/health || exit 1
        npm run test:e2e:staging

  # Integration Tests on Staging
  integration-tests:
    name: Integration Tests
    runs-on: ubuntu-latest
    needs: deploy-staging
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run integration tests
      run: npm run test:integration
      env:
        TEST_URL: https://staging.example.com
        API_KEY: ${{ secrets.STAGING_API_KEY }}
    
    - name: Upload test results
      uses: actions/upload-artifact@v4
      if: always()
      with:
        name: integration-test-results
        path: test-results/

  # Deploy to Production
  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: integration-tests
    environment: 
      name: production
      url: https://example.com
    
    steps:
    - name: Checkout deployment scripts
      uses: actions/checkout@v4
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1
    
    - name: Blue-Green Deployment
      run: |
        # Get current task definition
        TASK_DEF=$(aws ecs describe-services \
          --cluster production-cluster \
          --services myapp-service \
          --query 'services[0].taskDefinition' \
          --output text)
        
        # Create new task definition with updated image
        aws ecs register-task-definition \
          --family myapp-production \
          --task-role-arn arn:aws:iam::123456789012:role/ecsTaskRole \
          --execution-role-arn arn:aws:iam::123456789012:role/ecsExecutionRole \
          --network-mode awsvpc \
          --cpu 256 \
          --memory 512 \
          --container-definitions '[{
            "name": "myapp",
            "image": "${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:sha-${{ github.sha }}",
            "portMappings": [{"containerPort": 3000}],
            "essential": true,
            "logConfiguration": {
              "logDriver": "awslogs",
              "options": {
                "awslogs-group": "/ecs/myapp-production",
                "awslogs-region": "us-east-1",
                "awslogs-stream-prefix": "ecs"
              }
            }
          }]'
        
        # Update service
        aws ecs update-service \
          --cluster production-cluster \
          --service myapp-service \
          --task-definition myapp-production:${{ github.run_number }}
    
    - name: Wait for deployment
      run: |
        aws ecs wait services-stable \
          --cluster production-cluster \
          --services myapp-service
    
    - name: Post-deployment verification
      run: |
        curl -f https://example.com/health || exit 1
        curl -f https://example.com/api/status || exit 1

  # Update badges and notifications
  update-badges:
    name: Update Deployment Status
    runs-on: ubuntu-latest
    needs: [deploy-staging, deploy-production]
    if: always()
    
    steps:
    - name: Create deployment badge
      uses: schneegans/dynamic-badges-action@v1.7.0
      with:
        auth: ${{ secrets.GIST_SECRET }}
        gistID: your-gist-id
        filename: deployment-status.json
        label: Deployment
        message: ${{ needs.deploy-production.result == 'success' && 'Success' || 'Failed' }}
        color: ${{ needs.deploy-production.result == 'success' && 'green' || 'red' }}
    
    - name: Notify Slack
      if: always()
      uses: 8398a7/action-slack@v3
      with:
        status: ${{ job.status }}
        text: 'Deployment to production ${{ job.status }}'
      env:
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

# DevSecOps Integration 

- You can integrate security into the github actions workflow in many ways
	- Triggers for Security Scans
		- Each push and pull has a security scan 
	- Static Code Analysis & Linting
		- services are used to identify weak linting and code that could lead to security risks
	- Software Composition Analysis (SCA)
		- Uses the module's default audit facilities and other analysis services to identify security risks 
	- Static Application Security Testing (SAST)
		- Uses software such as CodeQL to do static security analysis 
	- Container Security Scanning
		- Checks for vulnerabilities in containers 
	- Dynamic Application Security Testing
		- Dynamic testing with services such as OWASP ZAP
	- Security Policy compliance 
		- Verifies the presence of crucial security-related files
		- Searching for secrets in the code 
	- Security Report Generation
		- Generates a security report 

