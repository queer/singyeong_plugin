defmodule Mix.Tasks.Singyeong.Package do
  use Mix.Task
  require Logger

  @shortdoc "Packages up a plugin from your compiled code + natives."
  def run(_) do
    Mix.Task.run "compile"

    project =
      Mix.Project.config()[:app]
      |> Atom.to_string

    cwd = File.cwd!()
    work_dir = "#{cwd}/work"
    beam_dir = "#{work_dir}/beam"
    natives_dir = "#{work_dir}/natives"
    out = "#{cwd}/#{project}.zip"

    if File.exists?(work_dir) do
      Logger.info "Cleaning up working directory #{work_dir}..."
      File.rm_rf! work_dir
    end

    if File.exists?(out) do
      Logger.info "Cleaning up plugin output #{out}..."
    end

    File.mkdir_p! beam_dir
    File.mkdir_p! natives_dir

    {plugin_code, native_code} = scan_files project, File.exists?("_build/prod")

    # Copy code into workdir
    plugin_code
    |> Enum.each(fn file ->
      file_name =
        file
        |> String.split("/")
        |> Enum.reverse
        |> hd

      File.copy! file, "#{beam_dir}/#{file_name}"
    end)
    native_code
    |> Enum.each(fn file ->
      file_name =
        file
        |> String.split("/")
        |> Enum.reverse
        |> hd

      File.copy! file, "#{natives_dir}/#{file_name}"
    end)

    # Zip it up
    zipped_files =
      work_dir
      |> File.ls!
      |> Enum.map(&to_charlist/1)

    _res = create_zip out, zipped_files, work_dir
    Logger.info "Created plugin zip #{out}."
  end

  defp scan_files(project_name, prod) do
    base_path =
      if prod do
        "_build/prod/lib"
      else
        # No point in copying test BEAM files
        "_build/dev/lib"
      end

    dependencies =
      base_path
      |> File.ls!
      |> Enum.filter(fn dir -> dir != project_name end)
      |> Enum.map(fn dir ->
        File.ls! "#{base_path}/#{dir}/ebin"
      end)
      |> List.flatten
      |> MapSet.new

    plugin_dependency_code =
      base_path
      |> File.ls!
      |> Enum.filter(fn dir -> dir == project_name end)
      |> Enum.flat_map(fn dir ->
        "#{base_path}/#{dir}/consolidated"
        |> File.ls!
        |> Enum.map(fn file ->
          "#{base_path}/#{dir}/consolidated/#{file}"
        end)
      end)
      |> Enum.filter(fn beam_file ->
        file_name =
          beam_file
          |> String.split("/")
          |> Enum.reverse
          |> hd

        MapSet.member? dependencies, file_name
      end)

    plugin_code =
      base_path
      |> File.ls!
      |> Enum.filter(fn dir -> dir == project_name end)
      |> Enum.map(fn dir ->
        files = File.ls! "#{base_path}/#{dir}/ebin"
        {dir, files}
      end)
      |> Enum.flat_map(fn {dir, files} ->
        Enum.map files, fn file -> "#{base_path}/#{dir}/ebin/#{file}" end
      end)

    plugin_native_code =
      base_path
      |> File.ls!
      |> Enum.filter(fn dir -> dir == project_name end)
      |> Enum.filter(fn dir -> File.exists?("#{base_path}/#{dir}/priv/native") end)
      |> Enum.map(fn dir ->
        files = File.ls! "#{base_path}/#{dir}/priv/native"
        {dir, files}
      end)
      |> Enum.flat_map(fn {dir, files} ->
        Enum.map files, fn file -> "#{base_path}/#{dir}/priv/native/#{file}" end
      end)

    {plugin_code ++ plugin_dependency_code, plugin_native_code}
  end

  defp create_zip(zip_name, files, cwd) do
    files = Enum.map(files, &to_charlist/1)

    :zip.create zip_name, files, cwd: cwd
  end
end
