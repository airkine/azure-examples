## Copilot instructions for this repository

Purpose
-------
This file provides a short, actionable prompt template and a set of rules for GitHub Copilot / AI assistants to follow when making code changes, creating examples, or editing infrastructure in the `azure-examples` repository.

Repository context
------------------
- Repo name: `azure-examples`
- Focus: small Azure example projects and infrastructure-as-code (Bicep/Terraform/Bash/TF) demonstrating patterns and utilities.
- Common folders: `afd/`, `azure-storage-account/`, `nsg-asg/` and supporting `scripts/` and README files.

High-level rules (must follow)
------------------------------
1. Preserve repository style and structure. Make minimal, localised changes unless the task explicitly requests refactoring.
2. Never add or expose secrets, credentials, or tokens in code or docs. If the task requires sensitive values, reference environment variables and document how to set them locally.
3. When changing IaC (Terraform, Bicep) files, follow Azure best practices: use parameterization, outputs, resource naming tokens, and managed identities where appropriate. If unsure, add TODO comments and suggest follow-ups.
4. Run relevant lint/build/test commands after edits (or add tests) and report the result in the PR description.
5. Keep commits small, self-contained, and include a short explanatory commit message.
6. Terraform resources go in their specific tf file. Variables in `variables.tf`, outputs in `outputs.tf`, provider config in `provider.tf`, and main resources in `main.tf` or a named file (e.g., `front_door.tf`), locals in `locals.tf`.
7. For inputs, always use variables with sensible defaults in `variables.tf` unless the user specifies otherwise.

Minimal prompt template (use when creating or editing files)
--------------------------------------------------------
Use the following template when the user asks the assistant to make changes. Fill placeholders precisely.

Task summary:
- Short one-line description of the requested change.

Files to change / add:
- List the exact files (paths) to edit or create.

Constraints & environment:
- Language(s): e.g., Terraform, Bash, PowerShell, Python
- Runtime / OS: Linux (zsh) by default
- No network calls or secret creation; use env vars for secrets

Acceptance criteria (explicit):
- What must be true for the task to be considered complete (build passes, lint passes, tests added, README updated, etc.)

Quality gates — what to check before finishing:
- Syntax/format: run terraform validate, shellcheck, or linters where applicable
- Small smoke test: run a quick local command (e.g., terraform fmt && terraform validate) and report output
- Tests: add at least one happy-path test when changing code (not required for tiny doc changes)

Example instruction (copyable):
"Implement an Azure Storage Account example that creates a storage account with secure defaults. Edit `azure-storage-account/main.tf` and `azure-storage-account/variables.tf`. Use environment variables for credentials, add outputs for the primary_connection_string, run `terraform validate` and show the result. Add or update `azure-storage-account/README.md` with usage instructions."

Best practices checklist for IaC changes
-------------------------------------
- Parameterize values in `variables.tf` or equivalent.
- Add or update `outputs.tf` for useful runtime values.
- Ensure `provider.tf` uses pinned provider versions if adding new providers.
- Add comments explaining any non-obvious choices.

Examples of brief assistant responses
-----------------------------------
- If asked to add a small doc: "Added `azure-storage-account/README.md` explaining how to run `terraform init` and `terraform apply` with examples using environment variables."
- If asked to implement code: include the changed file list, a one-line summary of each change, and the results of any quick validations executed.

Do / Don't list
---------------
Do:
- Keep changes focused and verifiable.
- Add tests and linting when changing behavior.
- Explain assumptions and list follow-ups (e.g., suggest managed identity for production).

Don't:
- Don't add secrets or hard-coded credentials.
- Don't commit large binary files or generated state files.

Assumptions (if not stated by user)
---------------------------------
- Default shell is `zsh` on Linux for any terminal commands.
- When a user doesn't specify files, prefer editing examples under the most relevant folder (e.g., `azure-storage-account/` for storage tasks).

If you cannot complete a requested change
----------------------------------------
- Explain why (missing info, lack of permissions, or need for secrets). Provide a minimal, safe alternative and list exactly what input is required to proceed.

Contact / follow-up
-------------------
If the change affects documentation or usage, update the relevant README and include a small "Try it" section with copyable terminal commands.

Final note
----------
Be concise and factual in PR descriptions. Include the verification steps you ran and the outputs. Prefer small, easily reviewed changes.

