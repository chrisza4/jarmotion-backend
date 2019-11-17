defmodule JarmotionWeb.Uploaders.Avatar do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  # use Arc.Ecto.Definition
  @acl :public_read
  # @versions [:original]

  # To add a thumbnail version:
  @versions [:original, :thumb]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  end

  # Override the persisted filenames:
  def filename(version, {file, _}) do
    file_name = stored_file_name(file.file_name)
    "#{version}_#{file_name}"
  end

  # Override the storage directory:
  # def storage_dir(version, {file, scope}) do
  #   "uploads/user/avatars/#{scope.id}"
  # end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  def s3_object_headers(_, {file, _}) do
    [content_type: MIME.from_path(file.file_name)]
  end

  def get_original_url(file_id) do
    get_file_url(file_id, "original")
  end

  def get_thumb_url(file_id) do
    (Path.basename(file_id, Path.extname(file_id)) <> ".png")
    |> get_file_url("thumb")
  end

  defp get_file_url(file_id, version) do
    ExAws.Config.new(:s3)
    |> ExAws.S3.presigned_url(
      :get,
      bucket_name(),
      "uploads/#{version}_#{file_id}",
      expires_in: 604_800
    )
  end

  defp stored_file_name(filename), do: Path.basename(filename, Path.extname(filename))
  defp bucket_name(), do: Application.get_env(:arc, :bucket)
end
