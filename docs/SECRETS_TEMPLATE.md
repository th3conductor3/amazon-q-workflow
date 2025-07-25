# Amazon Q Workflow Secrets (OFFLINE ONLY)
# ⚠️ WARNING: Never commit this file. Keep it offline and secure.

## GitHub Integration
```plaintext
GITHUB_USERNAME=<your_github_username>
GITHUB_TOKEN=<your_github_personal_access_token>
```

## AWS Credentials
```plaintext
AWS_ACCESS_KEY_ID=<your_aws_access_key>
AWS_SECRET_ACCESS_KEY=<your_aws_secret_key>
AWS_DEFAULT_REGION=<your_preferred_region>
```

## MCP Server Configurations
```plaintext
# GitHub MCP
GITHUB_MCP_TOKEN=<your_github_mcp_token>
GITHUB_MCP_WEBHOOK_SECRET=<your_webhook_secret>

# Additional MCP Servers
CUSTOM_MCP_TOKEN=<your_custom_token>
```

## API Keys
```plaintext
# Add any additional API keys used in your workflow
API_KEY_NAME=<your_api_key>
API_SECRET=<your_api_secret>
```

## Environment Variables
```plaintext
# Custom environment variables for your workflow
WORKFLOW_ENV_VAR=<your_env_value>
```

## Notes
1. Keep this file offline and secure
2. Store in a safe location outside of any git repository
3. Consider using a password manager for these secrets
4. Regularly rotate tokens and keys
5. Never share or expose these credentials

## Last Updated
Date: <update_date>
By: <your_name>
