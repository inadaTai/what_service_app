require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user) }
  let(:micropost) { user.microposts.build(name: "ゲームクラウドサービス", price: "月額1000円", content: "良いサービス", user_id: user.id) }

  describe "記事の投稿テスト" do
    it "有効な記事の投稿ができる" do
      micropost.picture.attach(io: File.open(Rails.root.join('db', 'images_seeds', '1.png')), filename: '1.png', content_type: 'image/png')
      expect(micropost).to be_valid
    end

    it "画像は有るが値段、本文と題名がない場合は無効" do
      micropost.picture.attach(io: File.open(Rails.root.join('db', 'images_seeds', '1.png')), filename: '1.png', content_type: 'image/png')
      expect(micropost).to be_valid
      micropost.update_attributes(price: nil, name: nil, content: nil, user_id: user.id)
      expect(micropost).to be_invalid
    end

    it "5MBを超える画像は添付することできない" do
      micropost.picture.attach(io: File.open(Rails.root.join('db', 'images_seeds', '6mb.jpg')), filename: '6mb.jpg', content_type: 'image/jpg')
      expect(micropost).to be_invalid
    end

    it "記事に対し指定された拡張子以外の画像はあげることが出来ない" do
      micropost.picture.attach(io: File.open(Rails.root.join('db', 'images_seeds', 'iphone.gif')), filename: 'iphone.gif', content_type: 'image/gif')
      expect(micropost).to be_invalid
    end
  end
end
