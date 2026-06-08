export default async ({ github, context, core, process }) => {
  try {
    const issue_number = parseInt(process.env.PR_NUMBER, 10);
    const owner = context.repo.owner;
    const repo = context.repo.repo;
    const runId = context.runId;
    const serverUrl = process.env.GITHUB_SERVER_URL || 'https://github.com';

    await github.rest.issues.createComment({
      issue_number: issue_number,
      owner: owner,
      repo: repo,
      body: `End to End Tests Passed! \n ${serverUrl}/${owner}/${repo}/actions/runs/${runId}`
    });
  } catch (error) {
    core.setFailed(`Failed to create issue comment: ${error.message}`);
  }
};
