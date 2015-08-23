require 'rails_helper'
require 'spec_helper'

describe User do
  it {should validate_presence_of(:email)}
  it {should validate_presence_of(:password)}
  it {should validate_presence_of(:username)}
  it {should validate_presence_of(:email)}
  it {should have_many(:cart_items)}
  it {should have_many(:reviews)}
  it {should have_many(:orders)}
  it {should have_many(:products).through(:orders)}
end
