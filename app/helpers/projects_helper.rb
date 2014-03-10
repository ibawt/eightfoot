module ProjectsHelper
  def is_repo_in_project?(repo)
    false
  end

  def column_header(i)
    @project.column_headers[i.to_s] ? @project.column_headers[i.to_s] : ''
  end

end
