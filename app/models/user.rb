class User < ApplicationRecord
  # validate :must_have_a_role, on: :update
  # acts_as_xlsx :columns => [:User]
  require 'csv'
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :phone, :presence => { :message => 'hello world, bad operation!' }, :numericality => true, :length => { :minimum => 10, :maximum => 10 }

  def self.to_index
    CSV.generate(col_sep: ";") do |csv|
      csv << ["FIRST NAME", "LAST NAME", "POST", "COMMENTS", "LIKES COUNT"]
      all.each do |record|
        record.articles.each do |article|
          article.comments.each do |com|
            csv << [record.first_name, record.last_name, article.body, com.body, article.likes.count]
          end
        end
      end
    end
  end

  def self.to_indexx
    package = Axlsx::Package.new
    workbook = package.workbook
      workbook.add_worksheet(:name => "User") do |sheet|
        all.each do |user|
          user.articles.each do |article|
            article.comments.each do |com|
              sheet.add_row [user.first_name, user.last_name, article.body, com.body, article.likes.count]
            end
          end
        end
        # %w(first second third).each { |label| sheet.add_row [label, rand(24)+1] }
        # sheet.add_chart(Axlsx::Pie3DChart, :start_at => [0,5], :end_at => [10, 20], :title => "example 3: Pie Chart") do |chart|
        #   chart.add_series :data => sheet["B2:B4"], :labels => sheet["A2:A4"],  :colors => ['FF0000', '00FF00', '0000FF']
      end
      # p.serialize('User.xlsx')
      package.to_stream.read
    end

  def self.to_download
    CSV.generate(col_sep: ";") do |csv|
      csv << ["FIRST NAME", "LAST NAME", "POST", "COMMENTS", "LIKES COUNT"]
      all.find_each do |record|
        if record.articles.count > 3
          record.articles.each do |article|
            article.comments.each do |com|
              csv << [record.first_name, record.last_name, article.body, com.body, article.likes.count]
            end
          end
        end
      end
    end
  end

  def self.to_downloads
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.add_worksheet(:name => "User") do |sheet|
      all.each do |user|
        if user.articles.count > 3
        user.articles.each do |article|
          article.comments.each do |com|
            sheet.add_row [user.first_name, user.last_name, article.body, com.body, article.likes.count]
          end
        end
      end
      # %w(first second third).each { |label| sheet.add_row [label, rand(24)+1] }
      # sheet.add_chart(Axlsx::Pie3DChart, :start_at => [0,5], :end_at => [10, 20], :title => "example 3: Pie Chart") do |chart|
      #   chart.add_series :data => sheet["B2:B4"], :labels => sheet["A2:A4"],  :colors => ['FF0000', '00FF00', '0000FF']
    end
    # p.serialize('User.xlsx')

    end
    package.to_stream.read
    end

  def self.to_post
    CSV.generate(col_sep: ";") do |csv|
      csv << ["TITLE", "POST", "COMMENTS", "LIKES COUNT"]
      all.find_each do |record|
        record.articles.each do |article|
          article.comments.each do |com|
            csv << [record.first_name, article.body, com.body, article.likes.count]
          end
        end
      end
    end
  end

  def self.to_posts
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.add_worksheet(:name => "User") do |sheet|
      all.each do |user|
          user.articles.each do |article|
            article.comments.each do |com|
              sheet.add_row [user.first_name, article.body, com.body, article.likes.count]
            end
          end
        end
        # %w(first second third).each { |label| sheet.add_row [label, rand(24)+1] }
        # sheet.add_chart(Axlsx::Pie3DChart, :start_at => [0,5], :end_at => [10, 20], :title => "example 3: Pie Chart") do |chart|
        #   chart.add_series :data => sheet["B2:B4"], :labels => sheet["A2:A4"],  :colors => ['FF0000', '00FF00', '0000FF']
      end
      # p.serialize('User.xlsx')
    package.to_stream.read
    end

  # validate :has_valid_email?
  #
  # VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #
  # def has_valid_email
  #   self.email =~ VALID_EMAIL_REGEX
  # end

  # private
  # def must_have_a_role
  #   unless roles.any?
  #     errors.add(:roles, "must have at least one role")
  #   end
  # end

  after_create :assign_default_role

  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :lockable
end
