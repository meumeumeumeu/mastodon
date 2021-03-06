# frozen_string_literal: true

class ReactionValidator < ActiveModel::Validator
  SUPPORTED_EMOJIS = Oj.load(File.read(Rails.root.join('app', 'javascript', 'mastodon', 'features', 'emoji', 'emoji_map.json'))).keys.freeze

  def validate(reaction)
    return if reaction.name.blank?
    reaction.errors.add(:name, I18n.t('reactions.errors.unrecognized_emoji')) if reaction.custom_emoji_id.blank? && !unicode_emoji?(reaction.name)
    reaction.errors.add(:name, I18n.t('reactions.errors.unrecognized_emoji')) unless unicode_emoji?(reaction.name)
  end

  private

  def unicode_emoji?(name)
    SUPPORTED_EMOJIS.include?(name)
  end

  def new_reaction?(reaction)
    !reaction.announcement.announcement_reactions.where(name: reaction.name).exists?
  end

end
