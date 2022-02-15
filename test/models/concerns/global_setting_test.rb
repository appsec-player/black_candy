# frozen_string_literal: true

require "test_helper"

class GlobalSettingTest < ActiveSupport::TestCase
  test "should have AVAILABLE_SETTINGS constant" do
    assert_equal [:media_path, :discogs_token, :transcode_bitrate, :allow_transcode_lossless], Setting::AVAILABLE_SETTINGS
  end

  test "should get env default value when setting value did not set" do
    ENV["MEDIA_PATH"] = "/test_media_path"

    assert_nil Setting.instance.values&.[]("media_path")
    assert_equal "/test_media_path", Setting.media_path
  end

  test "should get singleton global setting" do
    assert_equal Setting.instance, Setting.instance
  end

  test "should update settings" do
    assert_nil Setting.discogs_token

    Setting.update(discogs_token: "token")

    assert_equal "token", Setting.discogs_token
  end

  test "should get default value when setting value did not set" do
    assert_nil Setting.instance.values&.[]("transcode_bitrate")
    assert_equal 128, Setting.transcode_bitrate
  end

  test "should avoid others option value when set available_options" do
    assert_equal 128, Setting.transcode_bitrate
    Setting.update(transcode_bitrate: 10)

    assert_equal 128, Setting.transcode_bitrate
  end

  test "should get right type value when set type option" do
    assert_not Setting.allow_transcode_lossless
    Setting.update(allow_transcode_lossless: 1)

    assert Setting.allow_transcode_lossless
  end
end