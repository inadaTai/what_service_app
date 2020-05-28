require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:rel) { create(:relationship) }

  it 'followerとfollowedのユーザーがいる場合は有効' do
    expect(rel).to be_valid
  end

  it 'follower(other_user)がないと無効' do
    rel.follower = nil
    expect(rel).not_to be_valid
  end

  it 'followed(user)がないと無効' do
    rel.followed = nil
    expect(rel).not_to be_valid
  end
end
