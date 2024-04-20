require 'test_helper'
class UserTest < ActiveSupport::TestCase
  test 'should not save User without first_name' do
    user = User.new(last_name: 'Test', email: 'test@test.com', password: 'testing', password_confirmation: 'testing')

    refute user.save, 'Saved the user without the first_name'
    assert_equal user.errors.messages, { first_name: ["can't be blank"] }
  end

  test 'should not save User without last_name' do
    user = User.new(first_name: 'Test', email: 'test@test.com', password: 'testing', password_confirmation: 'testing')

    refute user.save, 'Saved the user without the last_name'
    assert_equal user.errors.messages, { last_name: ["can't be blank"] }
  end

  test 'should not save User without email' do
    user = User.new(first_name: 'Test', last_name: 'Test', password: 'testing', password_confirmation: 'testing')

    refute user.save, 'Saved the user without the email'
    assert_equal user.errors.messages, { email: ["can't be blank"] }
  end

  test 'should not save User with duplicate email' do
    User.create(first_name: 'Test', last_name: 'Test', email: 'test@test.com', password: 'testing',
                password_confirmation: 'testing')
    user_invalid = User.new(first_name: 'Test', last_name: 'Test', email: 'test@test.com', password: 'testing',
                            password_confirmation: 'testing')

    refute user_invalid.save, 'Saved the user with duplicate email'
    assert_equal user_invalid.errors.messages, { email: ['has already been taken'] }
  end

  test 'should not save User without password' do
    user = User.new(first_name: 'Test', last_name: 'Test', email: 'test@test.com', password_confirmation: 'testing')

    refute user.save, 'Saved the user without the password'
    assert_equal user.errors.messages,
                 { password: ["can't be blank"], password_confirmation: ["doesn't match Password"] }
  end

  test 'should not save User without password_confirmation' do
    user = User.new(first_name: 'Test', last_name: 'Test', email: 'test@test.com', password: 'testing')

    refute user.save, 'Saved the user without the password_confirmation'
    assert_equal user.errors.messages, { password_confirmation: ["can't be blank"] }
  end

  test "should not save User when password and password_confirmation don't match" do
    user = User.new(first_name: 'Test', last_name: 'Test', email: 'test@test.com', password: 'testing',
                    password_confirmation: 'asdasdasd')

    refute user.save, 'Saved the user without the password_confirmation'
    assert_equal user.errors.messages, { password_confirmation: ["doesn't match Password"] }
  end

  test 'should save a valid User' do
    user = User.new(first_name: 'Test', last_name: 'Test', email: 'test@test.com', password: 'testing',
                    password_confirmation: 'testing')
    assert user.save, "Didn't save a valid User"
  end

  test 'should create a bank account for a User after User creation' do
    user = User.create(first_name: 'Test', last_name: 'Test', email: 'test@test.com', password: 'testing',
                       password_confirmation: 'testing')
    assert user.bank_accounts.present?, "Didn't create a bank accoutn for a User"
  end

  test '.avatar should return a Gravatar link' do
    user = users(:john)
    link = "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}"
    assert_equal user.avatar, link, 'Avatar link is incorrect'
  end
end
