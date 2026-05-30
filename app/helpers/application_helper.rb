module ApplicationHelper
  def url_scans_enabled?
    return false unless current_user&.email.present?

    raw = ENV['URL_SCANS_AUTHORIZED_EMAILS'].presence || ENV['URL_SCANS_AUTHORIZED_EMAIL'].presence
    return false if raw.blank?

    # Split on commas, semicolons, or whitespace
    allowed = raw.split(/[\s,;]+/).map { |e| e.strip.downcase }.reject(&:blank?).uniq

    begin
      Rails.logger.debug("[URL_SCANS_GATE] current_user=#{current_user.email} raw_env='#{raw}' allowed=#{allowed.inspect}")
    rescue StandardError
      # ignore logging failures
    end

    allowed.include?(current_user.email.strip.downcase)
  end

  def sensitive_fuzzer_enabled?
    return false unless current_user&.email.present?

    raw = ENV['AUTHORIZED_EMAILS'].presence
    return false if raw.blank?

    # Split on commas, semicolons, or whitespace
    allowed = raw.split(/[\s,;]+/).map { |e| e.strip.downcase }.reject(&:blank?).uniq

    begin
      Rails.logger.debug("[SENSITIVE_FUZZER_GATE] current_user=#{current_user.email} raw_env='#{raw}' allowed=#{allowed.inspect}")
    rescue StandardError
      # ignore logging failures
    end

    allowed.include?(current_user.email.strip.downcase)
  end
end
