# hyperledger-fabric-management

Restart 2

## Project Overview
This project implements a comprehensive Hyperledger Fabric network management system. It includes a custom Fabric network setup, an API Gateway for interacting with the ledger, and a backend system for management tasks.
- **Goal**: Provide a robust framework for deploying and managing a Fabric network.
- **Components**: 
  - 1 ApiGateway (Fabric SDK)
  - 1 Orderer (Raft)
  - 3 Peers (Org1)
  - 1 Fabric CA

## Prerequisites
Before you begin, ensure you have the following installed:
- **Docker** & **Docker Compose**
- **Node.js** (v18+)
- **Go** (v1.20+)
- **Git**
- **Curl**

## Architecture Reference
The network topology consists of a single organization (**Org1**) operating:
- **3 Peers**: Ensuring high availability and distributed validation.
- **1 Orderer**: Using Raft consensus for transaction ordering.
- **1 Fabric CA**: Managing identity and certificates.
- **API Gateway**: A middleware Layer using `fabric-network` SDK to expose REST endpoints.

## Project Structure
```bash
root/
├── backend/          # Backend application
├── frontend/         # Frontend application
├── gateway/          # Gateway API (Fabric client)
├── network/          # Fabric network scripts & config
│   ├── configtx.yaml
│   ├── crypto-config.yaml
│   └── docker-compose.yaml
├── chaincode/        # Smart Contracts (Go)
│   └── asset-transfer/
├── scripts/          # Helper scripts (setup, clean, deploy)
├── docs/             # Documentation
└── tmp/              # Temporary files
```

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## Tech Stack
- **Hyperledger Fabric**: v2.5 (LTS)
- **Fabric CA**: v1.5
- **Docker**: v20.10+
- **Docker Compose**: v2.x
- **Node.js**: Missing (Needs v18+)
- **Go**: v1.20+


## Database Guidelines

### PostgreSQL
- All database migrations go in `backend/migrations/`
- Use SQLAlchemy ORM models
- Implement database connection pooling
- Follow database naming conventions

## Testing Guidelines

### Unit Tests
- Backend: Test services and utilities
- Frontend: Test components and hooks
- Chaincode: Test chaincode functions

### Integration Tests
- Test API endpoints
- Test chaincode deployment flow
- Test end-to-end workflows

## Deployment Guidelines

### Environment
- Use environment variables for configuration
- Keep secrets in environment, never in code
- Use .env files for local development
- Document required environment variables

### Chaincode Deployment
1. Package chaincode
2. Install on peer
3. Approve for organization
4. Check commit readiness
5. Commit to channel
6. Initialize chaincode

## Error Handling

### Error Types
- **ChaincodeError**: Fabric chaincode operation failures
- **GatewayError**: Gateway API errors
- **InvalidRequestError**: Invalid input validation
- **PermissionError**: Authorization failures

### Logging
- Use structured logging with appropriate log levels
- Include context (user, operation, error details)
- Never log sensitive information

## Security Guidelines

### Authentication
- Use JWT tokens for API authentication
- Implement RBAC (Role-Based Access Control)
- Validate user permissions for sensitive operations

### Certificates
- Use proper certificate management for Fabric operations
- Never commit private keys to repository
- Store certificates securely

### Input Validation
- Validate all user inputs
- Sanitize data before database operations
- Prevent SQL injection and XSS attacks

## Git Guidelines

### Commits
- Write clear, descriptive commit messages
- Use conventional commits format when possible
- Reference issue numbers in commits

### Branching
- `main`: Production-ready code
- `develop`: Development integration branch
- Feature branches: `feature/description`
- Fix branches: `fix/description`

## Documentation

### Code Documentation
- Document complex algorithms and business logic
- Use docstrings for functions and classes
- Keep comments up-to-date with code changes

### API Documentation
- Document all API endpoints
- Include request/response examples
- Document error codes and responses

### Temporary Documentation
- **ALL temporary docs go in `tmp/`** (project directory)
- Include date and purpose in temporary docs
- Delete when no longer needed

## Performance Guidelines

### Backend
- Use database connection pooling
- Implement caching where appropriate
- Optimize database queries
- Use async operations for I/O

### Frontend
- Minimize bundle size
- Implement lazy loading for routes
- Optimize images and assets
- Use React.memo for expensive components

### Chaincode
- Optimize chaincode logic
- Minimize state reads/writes
- Implement proper indexing

## Common Workflows

### Adding a New Feature
1. Create feature branch
2. Implement feature
3. Write tests
4. Update documentation
5. Create pull request

### Fixing a Bug
1. Create fix branch
2. Reproduce and fix issue
3. Add test to prevent regression
4. Update documentation if needed
5. Create pull request

### Deploying Chaincode
1. Package chaincode
2. Install on peer
3. Approve for org
4. Check commit readiness
5. Commit to channel
6. Initialize if needed
7. Test with queries/invokes

## Remember
- Keep the project root clean - use `tmp/` for temporary files
- Follow the established patterns and conventions
- Test changes before committing
- Update documentation when making significant changes
- Ask for help when uncertain
