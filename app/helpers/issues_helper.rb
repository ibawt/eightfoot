module IssuesHelper

  def num_cols
    @issues.max_by(&:col).col
  end

  def pull_request_url(issue)
    pr = issue.try(:pull_request)

    if pr.rels[:html]
      return pr.rels[:html].href
    else
      nil
    end
  end

  def pull_request_changes_url(pr_url)
    return "#{pr_url}/files"
  end
end
