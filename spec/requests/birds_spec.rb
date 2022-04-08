require 'rails_helper'

RSpec.describe "Birds", type: :request do
  before do
    Bird.create!(name: "Black-Capped Chickadee", species: "Poecile Atricapillus")
    Bird.create!(name: "Grackle", species: "Quiscalus Quiscula")
    Bird.create!(name: "Common Starling", species: "Sturnus Vulgaris")
    Bird.create!(name: "Mourning Dove", species: "Zenaida Macroura")
  end

  describe "GET /index" do
    it 'returns an array of all birds' do
      get '/birds'

      expect(response.body).to include_json([
        {"id":1,"name":"Black-Capped Chickadee","species":"Poecile Atricapillus"},
        {"id":2,"name":"Grackle","species":"Quiscalus Quiscula"},
      ])
    end
  end

  describe "GET /birds/:id" do
    it 'returns the first bird' do
      get "/birds/#{Bird.first.id}"

      expect(response.body).to include_json({
        "id":1,"name":"Black-Capped Chickadee",
        "species":"Poecile Atricapillus"
      })
    end

    it 'returns the second bird' do
      get "/birds/#{Bird.second.id}"

      expect(response.body).to include_json({
        "id": 2,
        "name": "Grackle",
        "species": "Quiscalus Quiscula",
      })
    end
  end
end
