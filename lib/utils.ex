defmodule Scidata.Utils do
  @moduledoc false
  require Logger

  def unzip_cache_or_download(base_url, zip, data_path) do
    path = Path.join(data_path, zip)

    data =
      if File.exists?(path) do
        Logger.debug("Using #{zip} from #{data_path}\n")
        File.read!(path)
      else
        Logger.debug("Fetching #{zip} from #{base_url}\n")
        :inets.start()
        :ssl.start()

        {:ok, {_status, _response, data}} = :httpc.request(base_url ++ zip)
        File.mkdir_p!(data_path)
        File.write!(path, data)

        data
      end

    :zlib.gunzip(data)
  end
end
